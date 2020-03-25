//Flutter
import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {

  final List<Color> colors;
  const GradientBackground({ this.colors = 
    const [
      Color.fromARGB(255, 130, 118, 211),
      Color.fromARGB(255,253, 181, 168)
    ]});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
        )
      ),
    );
  }
}