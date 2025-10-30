import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';

import '../resources/resources.dart';

extension ToXFileConvert on ScanImageFormat {
  Uint8List get toUint8List => data!.toUint8List();
  XFile get toXFile => XFile.fromData(Uint8List.fromList(img.encodeJpg(this)));
}

extension CameraImageToAppImageConvert on CameraImage {
  ScanImageFormat get toImageFormat {
    final int width = this.width;
    final int height = this.height;
    final yPlane = planes[0];
    final uPlane = planes[1];
    final vPlane = planes[2];
    final yBuffer = yPlane.bytes;
    final uBuffer = uPlane.bytes;
    final vBuffer = vPlane.bytes;
    final imgBytes = Uint8List(width * height * 3);
    int pixelIndex = 0;
    for (int y = 0; y < height; y++) {
      final uvRow = (y / 2).floor();
      for (int x = 0; x < width; x++) {
        final uvCol = (x / 2).floor();
        final uvIndex = uvRow * uPlane.bytesPerRow + uvCol;
        final Y = yBuffer[y * yPlane.bytesPerRow + x];
        final U = uBuffer[uvIndex];
        final V = vBuffer[uvIndex];
        final R = (Y + 1.370705 * (V - 128)).clamp(0, 255).toInt();
        final G = (Y - 0.337633 * (U - 128) - 0.698001 * (V - 128)).clamp(0, 255).toInt();
        final B = (Y + 1.732446 * (U - 128)).clamp(0, 255).toInt();
        imgBytes[pixelIndex++] = R;
        imgBytes[pixelIndex++] = G;
        imgBytes[pixelIndex++] = B;
      }
    }
    final ScanImageFormat result = ScanImageFormat.fromBytes(
      width: width,
      height: height,
      bytes: imgBytes.buffer,
      // order: img.ChannelOrder.rgb,
    );
    return result;
  }
}

extension CameraImageData on CameraImage {
  Uint8List readAsBytes() {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    return bytes;
  }
}