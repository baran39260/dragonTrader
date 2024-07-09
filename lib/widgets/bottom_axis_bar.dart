import 'package:flutter/material.dart';
import '../painters/horizontal_axis_painter.dart';

class BottomAxisBar extends StatelessWidget {
  final List<double> prices;
  final double scaleX;
  final double offsetX;

  BottomAxisBar({
    required this.prices,
    required this.scaleX,
    required this.offsetX,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: Colors.grey[200],
      child: CustomPaint(
        size: Size(double.infinity, double.infinity),
        painter: HorizontalAxisPainter(prices, scaleX, offsetX),
      ),
    );
  }
}
