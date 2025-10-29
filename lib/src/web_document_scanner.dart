import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'scanner_controller.dart';
import 'resources/resources.dart';
import 'utils/document_border_painter.dart';
import 'utils/logger.dart';

class WebDocumentScanner extends StatefulWidget {
  final ScannerController scannerController;
  final bool showDocBorder;
  final Widget? child;

  const WebDocumentScanner(
    this.scannerController, {
    super.key,
    this.child,
    this.showDocBorder = false,
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
    widget.scannerController.rect.addListener(
      () {
        debugLog('Rect: ${widget.scannerController.rect.value}');
        setState(() {});
      },
    );
    if (widget.scannerController.value.isInitialized) {
      widget.scannerController.status.value = ScannerStatus.initialized;
    } else {
      widget.scannerController.status.value = ScannerStatus.error;
    }
    debugLog('isInitialized: ${widget.scannerController.value.isInitialized}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CameraPreview(widget.scannerController),
            if (widget.scannerController.rect.value != Rect.zero)
              DocumentBorderPainterWidget(widget.scannerController.rect.value!),
            // if (widget.child != null) widget.child!,
          ],
        ),
      );

  @override
  void dispose() async {
    widget.scannerController.status.value = ScannerStatus.disposing;
    await widget.scannerController.pausePreview();
    await widget.scannerController.dispose();
    widget.scannerController.status.value = ScannerStatus.closed;
    super.dispose();
  }

  void disposeError({String? message}) {
    dispose();
    throw Exception(message ?? Messages.throwError);
  }
}
