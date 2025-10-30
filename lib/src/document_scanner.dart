import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'extensions/extensions.dart';
import 'models/detection_arguments.dart';
import 'models/detection_model.dart';
import 'resources/resources.dart';
import 'utils/logger.dart';

DetectionModel _document = DetectionModel();
DetectionArguments _detectionArguments = DetectionArguments();

DetectionModel analyze({
  required DetectionArguments detectionArguments,
  required ScanImageFormat image,
  XFile? file,
}) {
  _detectionArguments = detectionArguments;
  releaseLog('Analyze Started - ${image.data?.length}');
  final grayscale = img.grayscale(image);
  final sobel = img.sobel(grayscale);
  final result = _checkIsDoc(sobel);
  _document = _document.copyWith(rect: result.value1);
  debugLog('checkIsDoc: ${result.value2}');
  if (result.value2) {
    releaseLog('Image Scanned');
    debugLog('Image Scanned Size: ${_document.originalImageData?.length}');
    final cropped = image.cropImage(result.value1);
    _document = _document.copyWith(
      path: file?.path,
      name: file?.name,
      originalImageFile: file,
      originalImageData: image.toUint8List(),
      croppedData: cropped.toUint8List(),
      analyzeData: sobel.toUint8List(),
    );
  }
  return _document;
}

Tuple2<Rect, bool> _checkIsDoc(ScanImageFormat source) {
  debugLog('Checking Doc Started');
  List<Offset> corners = List<Offset>.empty(growable: true);
  int width = source.width;
  int height = source.height;
  int minX = width, maxX = 0;
  int minY = height, maxY = 0;
  int whitePixelCount = 0;

  for (int y = 0; y < height - 1; y++) {
    for (int x = 0; x < width - 1; x++) {
      final pixel = source.getPixel(x, y);
      final luminance = img.getLuminance(pixel);
      if (luminance > _detectionArguments.luminanceLimit) {
        whitePixelCount++;
        if (x < minX) minX = x;
        if (x > maxX) maxX = x;
        if (y < minY) minY = y;
        if (y > maxY) maxY = y;

        final bool isCorner = _cornerDetector(image: source, x: x, y: y);
        if (isCorner) {
          final Offset corner = Offset(x.toDouble(), y.toDouble());
          corners.add(corner);
          // debugLog('Corner ${corners.length}: $corner');
        }
      }
    }
  }

  List<Offset> finalCorners = List<Offset>.empty(growable: true);
  finalCorners
    ..add(Offset(minX.toDouble(), minY.toDouble()))
    ..add(Offset(minX.toDouble(), maxY.toDouble()))
    ..add(Offset(maxX.toDouble(), minY.toDouble()))
    ..add(Offset(maxX.toDouble(), maxY.toDouble()));
  _document = _document.copyWith(corners: finalCorners);

  final docWidth = maxX - minX;
  final docHeight = maxY - minY;
  final docArea = docWidth * docHeight;
  final imageArea = width * height;
  final fillRatio = docArea / imageArea;
  final aspectRatio = docWidth / docHeight;
  final whiteArea = docArea / whitePixelCount;

  Rect rect = Rect.fromLTWH(minX.toDouble(), minY.toDouble(), docWidth.toDouble(), docHeight.toDouble());

  if (_document.documentDetails == null) _document = _document.copyWith(documentDetails: DetectionDocumentDetail());
  _document = _document.copyWith(
    documentDetails: _document.documentDetails?.copyWith(
      size: Size(width.toDouble(), height.toDouble()),
      docSize: Size(docWidth.toDouble(), docHeight.toDouble()),
      docArea: docArea,
      imageArea: imageArea,
      fillRatio: (fillRatio * 100).toInt(),
      aspectRatio: (aspectRatio * 100).toInt(),
      whiteArea: (whiteArea * 10).toInt(),
      imageDimensionString: '$minX : $minY x $maxX : $maxY',
      docDimensionString: 'w $docWidth x h $docHeight',
    ),
  );

  final finalDecision = whitePixelCount != 0 &&
      _document.documentDetails!.whiteArea! > _detectionArguments.whiteAreaMin &&
      _document.documentDetails!.fillRatio! > _detectionArguments.fillRatioMin &&
      _document.documentDetails!.fillRatio! < _detectionArguments.fillRatioMax &&
      _document.documentDetails!.aspectRatio! > _detectionArguments.aspectRatioMin &&
      _document.documentDetails!.aspectRatio! < _detectionArguments.aspectRatioMax;
  releaseLog('==> Scanner FINAL DECISION $finalDecision');
  return Tuple2(rect, finalDecision);
}

bool _cornerDetector({required ScanImageFormat image, required int x, required int y}) {
  int threshold = 2; // Number of neighbor edges
  int count = 0;
  for (int dy = -1; dy <= 1; dy++) {
    for (int dx = -1; dx <= 1; dx++) {
      if (x == 0 || y == 0) continue;
      final neighbor = image.getPixel(x + dx, y + dy);
      final luminance = img.getLuminance(neighbor);
      if (luminance > _detectionArguments.luminanceLimit) count++;
    }
  }
  return count >= threshold;
}
