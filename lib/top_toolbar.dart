import 'package:flutter/material.dart';

class TopToolbar extends StatelessWidget {
  final Function(String) onTimeFrameSelected;
  final String selectedTimeFrame;

  TopToolbar({required this.onTimeFrameSelected, required this.selectedTimeFrame});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: Colors.transparent,
      child: Row(
        children: [
          // Logo with Colored Background
          Container(
            width: 60,
            alignment: Alignment.center,
            color: Colors.blueAccent,
            child: Icon(Icons.insert_chart, color: Colors.white),
          ),
          // Time Frame Buttons
          Row(
            children: [
              _buildTimeFrameButton('1', '1D'),
              _buildTimeFrameButton('7', '1W'),
              _buildTimeFrameButton('30', '1M'),
              _buildTimeFrameButton('90', '3M'),
              _buildTimeFrameButton('180', '6M'),
              _buildTimeFrameButton('365', '1Y'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFrameButton(String days, String label) {
    final isSelected = selectedTimeFrame == days;
    return GestureDetector(
      onTap: () {
        onTimeFrameSelected(days);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        margin: EdgeInsets.symmetric(horizontal: 2.0), // Closer spacing
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black, // Change color if selected
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
