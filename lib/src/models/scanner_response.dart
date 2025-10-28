import 'dart:typed_data';

import '../../web_document_scanner.dart';

class ScannerResponse {
  const ScannerResponse({
    this.path,
    this.imageFile,
    this.imageData,
  });

  final String? path;
  final XFile? imageFile;
  final Uint8List? imageData;
}