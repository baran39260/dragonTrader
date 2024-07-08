import 'package:flutter/material.dart';
import 'chart_painter.dart';

class ChartArea extends StatelessWidget {
  final List<double> prices;
  final double scaleY;
  final double scaleX;
  final double offsetX;
  final double offsetY;
  final Function(ScaleStartDetails) onScaleStart;
  final Function(ScaleUpdateDetails) onScaleUpdate;

  ChartArea({
    required this.prices,
    required this.scaleY,
    required this.scaleX,
    required this.offsetX,
    required this.offsetY,
    required this.onScaleStart,
    required this.onScaleUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: onScaleStart,
      onScaleUpdate: onScaleUpdate,
      child: Container(
        color: Colors.white,
        child: CustomPaint(
          size: Size(double.infinity, double.infinity),
          painter: ChartPainter(prices, scaleY, scaleX, offsetX, offsetY),
        ),
      ),
    );
  }
}
