import 'package:flutter/material.dart';

class VerticalAxisPainter extends CustomPainter {
  final List<double> prices;
  final double scale;
  final double offsetY;

  VerticalAxisPainter(this.prices, this.scale, this.offsetY);

  @override
  void paint(Canvas canvas, Size size) {
    if (prices.isEmpty) return;

    final double minY = prices.reduce((a, b) => a < b ? a : b);
    final double maxY = prices.reduce((a, b) => a > b ? a : b);
    final double range = maxY - minY;
    final double scaledRange = range * scale;
    final double scaledMinY = minY - scaledRange * 0.1;
    final double scaledMaxY = maxY + scaledRange * 0.1;
    final double step = (scaledMaxY - scaledMinY) / 10;

    final textPainter = TextPainter(
      textAlign: TextAlign.right,
      textDirection: TextDirection.ltr,
    );

    for (double i = scaledMinY; i <= scaledMaxY; i += step) {
      double y = size.height - (i - scaledMinY) * size.height / (scaledMaxY - scaledMinY) + offsetY;
      textPainter.text = TextSpan(
        text: i.toStringAsFixed(2),
        style: TextStyle(color: Colors.black, fontSize: 10),
      );
      textPainter.layout(minWidth: 0, maxWidth: size.width);
      textPainter.paint(canvas, Offset(size.width - 40, y - 6));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
