import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  // final barrierWidth; // out of 2, where 2 is the width of the screen
  // final barrierHeight; // proportion of the screenheight
  // final barrierX;
  // final bool isThisBottomBarrier;
  final size;

  MyBarrier({this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: size,
      decoration: BoxDecoration(
        color: Colors.green,
      ),
    );
  }
}
