import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

import '../resources/resources.dart';

extension CameraXFileToAppImageConvert on XFile {
  Future<ScanImageFormat?> get toImageFormat async {
    final imageData = await readAsBytes();
    final image = img.decodeImage(imageData);
    return image;
  }
}