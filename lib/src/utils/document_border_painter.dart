import 'package:flutter/material.dart';

import 'package_defaults.dart';

class DocumentBorderPainterWidget extends StatefulWidget {
  final Rect rect;
  final Color color;
  final double strokeWidth;
  final PaintingStyle paintingStyle;
  const DocumentBorderPainterWidget({
    super.key,
    required this.rect,
    required this.color,
    required this.strokeWidth,
    required this.paintingStyle,
  });

  @override
  State<DocumentBorderPainterWidget> createState() => _DocumentBorderPainterWidgetState();
}

class _DocumentBorderPainterWidgetState extends State<DocumentBorderPainterWidget> {
  @override
  Widget build(BuildContext context) => _isDrawing(widget.rect)
      ? CustomPaint(
          painter: DocumentBorderPainter(
            widget.rect,
            widget.color,
            widget.strokeWidth,
            widget.paintingStyle,
          ),
          child: Container(),
        )
      : _notAvailable;
}

class DocumentBorderPainter extends CustomPainter {
  final Rect rect;
  final Color color;
  final double strokeWidth;
  final PaintingStyle paintingStyle;
  const DocumentBorderPainter(
    this.rect,
    this.color,
    this.strokeWidth,
    this.paintingStyle,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    Path path = Path()
      ..moveTo(rect.topLeft.dx, rect.topLeft.dy)
      ..lineTo(rect.topRight.dx, rect.topRight.dy)
      ..lineTo(rect.bottomRight.dx, rect.bottomRight.dy)
      ..lineTo(rect.bottomLeft.dx, rect.bottomLeft.dy)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

bool _isDrawing(Rect rect) => PackageDefaults.drawDocumentBorder && rect != Rect.zero;
Widget get _notAvailable => const SizedBox.shrink();
