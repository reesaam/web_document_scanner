import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import '../../web_document_scanner.dart';
import '../resources/resources.dart';
import '../resources/package_defaults.dart';

extension CropScanImageFormat on ScanImageFormat {
  ScanImageFormat cropImage(Rect rect) {
    final constCropAmount = PackageDefaults.constCropAmount;
    // final cropped = kIsWeb
    //     ? image
    //     : img.copyCrop(
    //         image,
    //         x: rect.left.toInt() + constInt,
    //         y: rect.top.toInt() + constInt,
    //         width: rect.width.toInt() - constInt,
    //         height: rect.height.toInt() - constInt,
    //       );
    final cropped = img.copyCrop(
      this,
      x: rect.left.toInt() + constCropAmount,
      y: rect.top.toInt() + constCropAmount,
      width: rect.width.toInt() - constCropAmount,
      height: rect.height.toInt() - constCropAmount,
    );
    return cropped;
  }
}

extension CropXFile on XFile {
  Future<Uint8List> cropToUintListImage(Rect rect) async {
    final constCropAmount = PackageDefaults.constCropAmount;
    final bytes = await readAsBytes();
    final decodedImage = img.decodeImage(bytes);
    final cropped = img.copyCrop(
      decodedImage!,
      x: rect.left.toInt() + constCropAmount,
      y: rect.top.toInt() + constCropAmount,
      width: rect.width.toInt() - constCropAmount,
      height: rect.height.toInt() - constCropAmount,
    );
    final result = Uint8List.fromList(img.encodeJpg(cropped));
    return result;
  }
}
