import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:seva_meal/core/app_colors.dart';

Widget coloredButton(
  String text,
  Color containerColor,
  Color textColor,
  EdgeInsetsGeometry? padding,
) {
  return Container(
    padding: padding ?? EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: containerColor),
    child: Text(text, style: TextStyle(color: textColor, fontSize: 12)),
  );
}
