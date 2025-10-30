import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../web_document_scanner.dart';

class ScannerResponse {
  const ScannerResponse({
    this.path,
    this.imageFile,
    this.imageData,
    this.croppedData,
    this.analyzeData,
    this.rect,
  });

  final String? path;
  final XFile? imageFile;
  final Uint8List? imageData;
  final Uint8List? croppedData;
  final Uint8List? analyzeData;
  final Rect? rect;
}