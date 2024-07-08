import 'package:flutter/material.dart';

class ChartPainter extends CustomPainter {
  final List<double> prices;
  final double scaleY;
  final double scaleX;
  final double offsetX;
  final double offsetY;

  ChartPainter(this.prices, this.scaleY, this.scaleX, this.offsetX, this.offsetY);

  @override
  void paint(Canvas canvas, Size size) {
    if (prices.isEmpty) return;

    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final double minY = prices.reduce((a, b) => a < b ? a : b);
    final double maxY = prices.reduce((a, b) => a > b ? a : b);
    final double range = maxY - minY;
    final double scaleYAdjusted = size.height / range * scaleY;

    final double stepX = size.width / (prices.length - 1) * scaleX;
    final double offsetXAdjusted = offsetX % stepX;
    final int firstIndex = (offsetX / stepX).floor().abs();

    if (firstIndex < prices.length) {
      path.moveTo(offsetXAdjusted, size.height - (prices[firstIndex] - minY) * scaleYAdjusted + offsetY);
      for (int i = firstIndex + 1; i < prices.length; i++) {
        path.lineTo(offsetXAdjusted + (i - firstIndex) * stepX, size.height - (prices[i] - minY) * scaleYAdjusted + offsetY);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
