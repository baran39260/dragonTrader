import 'package:flutter/material.dart';

class LeftToolbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      color: Colors.grey[200],
      child: Column(
        children: [
          IconButton(
            icon: Icon(Icons.insert_chart),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.show_chart),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
