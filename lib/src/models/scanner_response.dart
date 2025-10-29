import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../web_document_scanner.dart';

class ScannerResponse {
  const ScannerResponse({
    this.path,
    this.imageFile,
    this.imageData,
    this.rect,
  });

  final String? path;
  final XFile? imageFile;
  final Uint8List? imageData;
  final Rect? rect;
}