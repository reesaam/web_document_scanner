import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

import 'document_scanner.dart';
import 'extensions/extensions.dart';
import 'models/detection_arguments.dart';
import 'models/detection_model.dart';
import 'models/scanner_response.dart';
import 'resources/resources.dart';
import 'utils/logger.dart';

class ScannerController extends CameraController {
  final DetectionArguments? detectionArguments;
  ValueNotifier<ScannerStatus> status = ValueNotifier(ScannerStatus.closed);

  ScannerController({
    required this.description,
    this.resolutionPreset = ResolutionPreset.low,
    this.detectionArguments,
  }) : super(description, resolutionPreset);

  @override
  CameraDescription description;

  @override
  ResolutionPreset resolutionPreset;

  @override
  Future<void> initialize() async {
    status.value = ScannerStatus.cameraInitializing;
    return super.initialize();
  }

  Future<ScannerResponse?> startAutoScan() async {
    releaseLog('AutoScan Started ...');
    status.value = ScannerStatus.scanning;
    DetectionModel? detectionResponse;
    DetectionArguments arguments = detectionArguments ?? DetectionArguments();
    await Future.doWhile(
      () async {
        final capturedImage = await takePicture();
        final convertedImage = await capturedImage.toImageFormat;
        releaseLog('Picture Taken ${DateTime.now().toLocal()}');
        if (convertedImage != null) {
          Future.delayed(Duration(seconds: arguments.streamCaptureDelay), () {});
          detectionResponse = analyze(
            detectionArguments: arguments,
            image: convertedImage,
            file: capturedImage,
          );
          if (detectionResponse?.isFound ?? false) {
            releaseLog('Document Found');
            releaseLog('Changing Scanner Status');
            final imageData = await capturedImage.readAsBytes();
            final imageFile = XFile.fromData(imageData);
            debugLog('response name: ${detectionResponse?.name}');
            debugLog('response path: ${detectionResponse?.path}');
            debugLog('response length: ${await detectionResponse?.originalImageFile?.length()}');
            detectionResponse = detectionResponse?.copyWith(
              // name: imageFile.name,
              // path: imageFile.path,
              // originalImageFile: imageFile,
              originalImageData: imageData,
            );
            status.value = ScannerStatus.scanned;
          }
        }
        releaseLog('status: ${status.value}');
        return status.value == ScannerStatus.scanning;
      },
    );
    final ScannerResponse scannerResponse = ScannerResponse(
      path: detectionResponse?.path,
      imageFile: detectionResponse?.originalImageFile,
      imageData: detectionResponse?.originalImageData,
    );
    return scannerResponse;
  }

  void stopAutoScan() {
    status.value = ScannerStatus.closed;
  }
}
