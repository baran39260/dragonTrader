import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../painters/vertical_axis_painter.dart';

class RightAxisBar extends StatelessWidget {
  final List<double> prices;
  final double scaleY;
  final double offsetY;
  final Function(PointerSignalEvent) onVerticalScale;

  RightAxisBar({
    required this.prices,
    required this.scaleY,
    required this.offsetY,
    required this.onVerticalScale,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: onVerticalScale,
      child: Container(
        width: 60,
        color: Colors.grey[200],
        child: CustomPaint(
          size: Size(double.infinity, double.infinity),
          painter: VerticalAxisPainter(prices, scaleY, offsetY),
        ),
      ),
    );
  }
}
