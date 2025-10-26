import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

import 'document_scanner.dart';
import 'extensions/extensions.dart';
import 'models/detection_arguments.dart';
import 'models/detection_model.dart';
import 'resources/resources.dart';
import 'utils/logger.dart';

class ScannerController extends CameraController {
  final DetectionArguments? detectionArguments;
  ValueNotifier<ScannerStatus> status = ValueNotifier(ScannerStatus.closed);

  ScannerController(
    this.description,
    this.resolutionPreset,
    this.detectionArguments,
  ) : super(description, resolutionPreset);

  @override
  CameraDescription description;

  @override
  ResolutionPreset resolutionPreset;

  Future<Uint8List?> startAutoScan() async {
    DetectionModel? detectionResponse;
    DetectionArguments arguments = detectionArguments ?? DetectionArguments();
    Future.doWhile(
      () async {
        final capturedImage = await takePicture();
        final convertedImage = await capturedImage.toImageFormat;
        if (convertedImage != null) {
          Future.delayed(Duration(seconds: arguments.streamCaptureDelay), () {
            detectionResponse = analyze(
              detectionArguments: arguments,
              image: convertedImage,
              file: capturedImage,
            );
            if (detectionResponse?.isFound ?? false) {
              releaseLog('Document Found');
              releaseLog('Changing Scanner Status');
              status.value = ScannerStatus.scanned;
            }
          });
        }
        return status.value == ScannerStatus.scanning;
      },
    );
    return detectionResponse?.originalImageData;
  }

  void stopAutoScan() {
    status.value = ScannerStatus.closed;
  }
}
