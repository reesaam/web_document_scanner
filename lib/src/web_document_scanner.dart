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
  final Size? size;
  final Color detectionBorderColor;
  final double detectionBorderStrokeWidth;
  final PaintingStyle detectionBorderPaintingStyle;

  const WebDocumentScanner(
    this.scannerController, {
    super.key,
    this.child,
    this.showDocBorder = false,
    this.size,
    this.detectionBorderColor = Colors.greenAccent,
    this.detectionBorderStrokeWidth = 2,
    this.detectionBorderPaintingStyle = PaintingStyle.stroke,
  });

  @override
  State<WebDocumentScanner> createState() => _WebDocumentScannerState();
}

class _WebDocumentScannerState extends State<WebDocumentScanner> {
  @override
  void initState() {
    widget.scannerController.status.value = ScannerStatus.initializing;
    if (!kIsWeb || !widget.scannerController.value.isInitialized) {
      throwError();
    } else {
      widget.scannerController.status.value = ScannerStatus.initialized;
      widget.scannerController.status.addListener(() {
        debugLog('Scanner Status: ${widget.scannerController.status.value.name}');
        (widget.scannerController.status.value.dispose ?? false) ? throwError() : null;
      });
      widget.scannerController.rect
          .addListener(() => setState(() => debugLog('Rect: ${widget.scannerController.rect.value}')));
      debugLog('isInitialized: ${widget.scannerController.value.isInitialized}');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        height: widget.size?.height,
        width: widget.size?.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CameraPreview(widget.scannerController),
            if (widget.scannerController.status.value == ScannerStatus.scanning)
              DocumentBorderPainterWidget(
                rect: widget.scannerController.rect.value,
                color: widget.detectionBorderColor,
                strokeWidth: widget.detectionBorderStrokeWidth,
                paintingStyle: widget.detectionBorderPaintingStyle,
              ),
            if (widget.child != null) widget.child!,
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

  void throwError({String? message}) {
    widget.scannerController.status.value = ScannerStatus.error;
    throw Exception(message ?? Messages.throwError);
  }
}
