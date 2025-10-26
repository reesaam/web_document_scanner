import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'camera_controller.dart';
import 'resources/resources.dart';

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
    if (!kIsWeb) disposeError();
    widget.scannerController
        .addListener(() => (widget.scannerController.status.value.dispose ?? false) ? dispose() : null);
    super.initState();
  }

  @override
  void dispose() {
    widget.scannerController.dispose();
    widget.scannerController.status.value = ScannerStatus.closed;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          CameraPreview(widget.scannerController),
          if (widget.child != null) widget.child!,
        ],
      );

  void disposeError({String? message}) {
    dispose();
    throw Exception(message ?? Messages.throwError);
  }
}
