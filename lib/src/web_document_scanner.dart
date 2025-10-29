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
  final Color detectionBorderColor;
  final double detectionBorderStrokeWidth;
  final PaintingStyle detectionBorderPaintingStyle;
  final BorderRadius? borderRadius;

  const WebDocumentScanner(
    this.scannerController, {
    super.key,
    this.child,
    this.showDocBorder = false,
    this.detectionBorderColor = Colors.greenAccent,
    this.detectionBorderStrokeWidth = 2,
    this.detectionBorderPaintingStyle = PaintingStyle.stroke,
    this.borderRadius,
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
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: widget.scannerController.value.aspectRatio,
            child: CameraPreview(widget.scannerController),
          ),
          DocumentBorderPainterWidget(
            rect: widget.scannerController.rect.value,
            scannerStatus: widget.scannerController.status.value,
            color: widget.detectionBorderColor,
            strokeWidth: widget.detectionBorderStrokeWidth,
            paintingStyle: widget.detectionBorderPaintingStyle,
          ),
          if (widget.child != null) widget.child!,
        ],
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
