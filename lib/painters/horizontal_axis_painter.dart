import 'package:flutter/material.dart';

class HorizontalAxisPainter extends CustomPainter {
  final List<double> prices;
  final double scale;
  final double offsetX;

  HorizontalAxisPainter(this.prices, this.scale, this.offsetX);

  @override
  void paint(Canvas canvas, Size size) {
    if (prices.isEmpty) return;

    final double stepX = size.width / (prices.length - 1) * scale;
    final double offsetXAdjusted = offsetX % stepX;
    final int firstIndex = (offsetX / stepX).floor().abs();

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int i = firstIndex; i < prices.length; i += (prices.length / 10).ceil()) {
      double x = offsetXAdjusted + (i - firstIndex) * stepX;
      if (x > size.width) break;
      textPainter.text = TextSpan(
        text: 'Day ${i + 1}',
        style: TextStyle(color: Colors.black, fontSize: 10),
      );
      textPainter.layout(minWidth: 0, maxWidth: 60);
      textPainter.paint(canvas, Offset(x - 30, 0));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
