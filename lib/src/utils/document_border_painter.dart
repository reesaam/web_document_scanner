import 'package:flutter/material.dart';

class DocumentBorderPainterWidget extends StatelessWidget {
  final Rect rect;
  const DocumentBorderPainterWidget(this.rect, {super.key});

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: DocumentBorderPainter(rect),
        child: Container(),
      );
}

class DocumentBorderPainter extends CustomPainter {
  final Rect rect;
  const DocumentBorderPainter(this.rect);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

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
