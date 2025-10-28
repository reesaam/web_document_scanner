import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'scanner_controller.dart';
import 'resources/resources.dart';
import 'utils/logger.dart';

class WebDocumentScanner extends StatefulWidget {
  final ScannerController scannerController;
  final Widget? child;

  const WebDocumentScanner(
    this.scannerController, {
    super.key,
    this.child,
  });

  @override
  State<WebDocumentScanner> createState() => _WebDocumentScannerState();
}

class _WebDocumentScannerState extends State<WebDocumentScanner> {
  @override
  void initState() {
    widget.scannerController.status.value = ScannerStatus.initializing;
    if (!kIsWeb) disposeError();
    widget.scannerController.status.addListener(() {
      debugLog('Scanner Status: ${widget.scannerController.status.value.name}');
      (widget.scannerController.status.value.dispose ?? false) ? disposeError() : null;
    });
    if (widget.scannerController.value.isInitialized) {
      widget.scannerController.status.value = ScannerStatus.initialized;
    } else {
      widget.scannerController.status.value = ScannerStatus.error;
    }
    debugLog('isInitialized: ${widget.scannerController.value.isInitialized}');
    super.initState();
  }

  @override
  void dispose() async {
    widget.scannerController.status.value = ScannerStatus.disposing;
    await widget.scannerController.pausePreview();
    await widget.scannerController.dispose();
    widget.scannerController.status.value = ScannerStatus.closed;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CameraPreview(widget.scannerController),
            if (widget.child != null) widget.child!,
          ],
        ),
      );

  void disposeError({String? message}) {
    dispose();
    throw Exception(message ?? Messages.throwError);
  }
}
