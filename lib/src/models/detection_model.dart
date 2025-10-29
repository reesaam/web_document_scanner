import 'dart:ui';
import 'dart:typed_data';
import 'package:camera/camera.dart';

import 'detection_document_detail.dart';
export 'detection_document_detail.dart';

class DetectionModel {
  const DetectionModel({
    this.name,
    this.path,
    this.originalImageFile,
    this.originalImageData,
    this.grayScaleImageData,
    this.edgesData,
    this.croppedData,
    this.croppedEdgesData,
    this.corners,
    this.size,
    this.rect = Rect.zero,
    this.documentDetails,
  });

  final String? name;
  final String? path;
  final XFile? originalImageFile;
  final Uint8List? originalImageData;
  final Uint8List? grayScaleImageData;
  final Uint8List? edgesData;
  final Uint8List? croppedData;
  final Uint8List? croppedEdgesData;
  final List<Offset>? corners;
  final Size? size;
  final Rect rect;
  final DetectionDocumentDetail? documentDetails;

  DetectionModel copyWith({
    String? name,
    String? path,
    XFile? originalImageFile,
    Uint8List? originalImageData,
    Uint8List? grayScaleImageData,
    Uint8List? edgesData,
    Uint8List? croppedData,
    Uint8List? croppedEdgesData,
    List<Offset>? corners,
    Size? size,
    Rect? rect,
    DetectionDocumentDetail? documentDetails,
  }) =>
      DetectionModel(
        name: name ?? this.name,
        path: path ?? this.path,
        originalImageFile: originalImageFile ?? this.originalImageFile,
        originalImageData: originalImageData ?? this.originalImageData,
        grayScaleImageData: grayScaleImageData ?? this.grayScaleImageData,
        edgesData: edgesData ?? this.edgesData,
        croppedData: croppedData ?? this.croppedData,
        croppedEdgesData: croppedEdgesData ?? this.croppedEdgesData,
        corners: corners ?? this.corners,
        size: size ?? this.size,
        rect: rect ?? this.rect,
        documentDetails: documentDetails ?? this.documentDetails,
      );
}
