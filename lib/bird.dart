import 'package:flutter/material.dart';

class BlueBird extends StatelessWidget {
  final birdY;
  final double birdWidth;
  final double birdHeight;

  BlueBird({this.birdY, required this.birdHeight, required this.birdWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment(0, birdY),
        child: Image.asset(
          'lib/images/BlueFlappy.png',
          width: 50,
          height: 50,
        ));
  }
}
