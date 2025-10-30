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
    this.croppedData,
    this.analyzeData,
    this.corners,
    this.rect = Rect.zero,
    this.documentDetails,
  });

  final String? name;
  final String? path;
  final XFile? originalImageFile;
  final Uint8List? originalImageData;
  final Uint8List? croppedData;
  final Uint8List? analyzeData;
  final List<Offset>? corners;
  final Rect rect;
  final DetectionDocumentDetail? documentDetails;

  DetectionModel copyWith({
    String? name,
    String? path,
    XFile? originalImageFile,
    Uint8List? originalImageData,
    Uint8List? croppedData,
    Uint8List? analyzeData,
    List<Offset>? corners,
    Rect? rect,
    DetectionDocumentDetail? documentDetails,
  }) =>
      DetectionModel(
        name: name ?? this.name,
        path: path ?? this.path,
        originalImageFile: originalImageFile ?? this.originalImageFile,
        originalImageData: originalImageData ?? this.originalImageData,
        croppedData: croppedData ?? this.croppedData,
        analyzeData: analyzeData ?? this.analyzeData,
        corners: corners ?? this.corners,
        rect: rect ?? this.rect,
        documentDetails: documentDetails ?? this.documentDetails,
      );
}
