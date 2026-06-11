import 'dart:ui';

import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 40);

    path.cubicTo(
      size.width * 0.75,
      size.height - 70, // control 1
      size.width * 0.75,
      size.height - 70, // control 2
      size.width * 0.6,
      size.height - 60, // mid point
    );

    path.cubicTo(
      size.width * 0.40,
      size.height - 50, // control 1
      size.width * 0.25,
      size.height, // control 2
      0,
      size.height - 60, // end point
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
