import 'dart:ui';

import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'models/detection_arguments.dart';
import 'models/detection_model.dart';
import 'resources/resources.dart';
import 'utils/logger.dart';

DetectionModel _document = DetectionModel();
DetectionArguments _detectionArguments = DetectionArguments();

Rect getCorners(ScanImageFormat image) {
  final grayscale = img.grayscale(image);
  final edges = img.sobel(grayscale);
  final resizedEdges = img.copyResize(edges, height: (edges.height / 4).toInt(), width: (edges.width / 4).toInt());
  debugLog('Resize ${edges.height}x${edges.width} to ${resizedEdges.height}x${resizedEdges.width}');
  final result = _checkIsDoc(resizedEdges);
  debugLog('rect: ${result != Rect.zero}');
  return result;
}

DetectionModel analyze({required DetectionArguments detectionArguments, required ScanImageFormat image, XFile? file}) {
  _detectionArguments = detectionArguments;
  releaseLog('Analyze Started - ${image.data?.length}');
  final grayscale = img.grayscale(image);
  final edges = img.sobel(grayscale);
  final resizedEdges = img.copyResize(edges, height: (edges.height / 4).toInt(), width: (edges.width / 4).toInt());
  debugLog('Resize ${edges.height}x${edges.width} to ${resizedEdges.height}x${resizedEdges.width}');
  final result = _checkIsDoc(resizedEdges);
  debugLog('checkIsDoc: $result');
  if (result != Rect.zero) {
    releaseLog('Image Scanned');
    debugLog('Image Scanned Size: ${_document.originalImageData?.length}');
    debugLog('Resized Image Scanned Size: ${resizedEdges.length}');
    final cropped = _cropImage(image: image, rect: result);
    final croppedEdges = _cropImage(image: edges, rect: result);
    _document = _document.copyWith(
      path: file?.path,
      name: file?.name,
      originalImageFile: file,
      originalImageData: image.toUint8List(),
      grayScaleImageData: grayscale.toUint8List(),
      croppedData: cropped.toUint8List(),
      croppedEdgesData: croppedEdges.toUint8List(),
      edgesData: edges.toUint8List(),
      rect: result,
      size: Size(image.width.toDouble(), image.height.toDouble()),
    );
  }
  return _document;
}

Rect _checkIsDoc(ScanImageFormat edges) {
  debugLog('Checking Doc Started');
  List<Offset> corners = List<Offset>.empty(growable: true);
  int width = edges.width;
  int height = edges.height;
  int minX = width, maxX = 0;
  int minY = height, maxY = 0;
  int whitePixelCount = 0;

  for (int y = 0; y < height - 1; y++) {
    for (int x = 0; x < width - 1; x++) {
      final pixel = edges.getPixel(x, y);
      final luminance = img.getLuminance(pixel);
      if (luminance > _detectionArguments.luminanceLimit) {
        whitePixelCount++;
        if (x < minX) minX = x;
        if (x > maxX) maxX = x;
        if (y < minY) minY = y;
        if (y > maxY) maxY = y;

        // final bool isCorner = _cornerDetector(image: edges, x: x, y: y);
        // if (isCorner) {
        //   final Offset corner = Offset(x.toDouble(), y.toDouble());
        //   corners.add(corner);
        //   debugLog('Corner ${corners.length}: $corner');
        // }
      }
    }
  }

  corners
    ..add(Offset(minX.toDouble(), minY.toDouble()))
    ..add(Offset(minX.toDouble(), maxY.toDouble()))
    ..add(Offset(maxX.toDouble(), minY.toDouble()))
    ..add(Offset(maxX.toDouble(), maxY.toDouble()));
  _document = _document.copyWith(corners: corners);

  if (whitePixelCount == 0) return Rect.zero;

  final docWidth = maxX - minX;
  final docHeight = maxY - minY;
  final docArea = docWidth * docHeight;
  final imageArea = width * height;
  final fillRatio = docArea / imageArea;
  final aspectRatio = docWidth / docHeight;
  final whiteArea = docArea / whitePixelCount;

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

  final finalDecision = _document.documentDetails!.whiteArea! > _detectionArguments.whiteAreaMin &&
      _document.documentDetails!.fillRatio! > _detectionArguments.fillRatioMin &&
      _document.documentDetails!.fillRatio! < _detectionArguments.fillRatioMax &&
      _document.documentDetails!.aspectRatio! > _detectionArguments.aspectRatioMin &&
      _document.documentDetails!.aspectRatio! < _detectionArguments.aspectRatioMax;
  debugLog('finalDecision ==> $finalDecision');
  Rect? rect;
  if (finalDecision) {
    releaseLog('==> Scanner FINAL DECISION TRUE');
    rect = Rect.fromLTWH(minX.toDouble(), minY.toDouble(), docWidth.toDouble(), docHeight.toDouble());
  }
  return rect ?? Rect.zero;
}

bool _cornerDetector({required ScanImageFormat image, required int x, required int y}) {
  int threshold = 5; // Number of neighbor edges
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

ScanImageFormat _cropImage({required ScanImageFormat image, required Rect rect}) {
  const int constInt = 20;
  final cropped = kIsWeb
      ? image
      : img.copyCrop(
          image,
          x: rect.left.toInt() + constInt,
          y: rect.top.toInt() + constInt,
          width: rect.width.toInt() - constInt,
          height: rect.height.toInt() - constInt,
        );
  debugLog('Scanner Crop');
  return cropped;
}
