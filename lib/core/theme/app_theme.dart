import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData();
  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Aclonica',
  );

  static TextStyle albertFont(TextStyle? style) {
    return TextStyle(
      fontFamily: 'sans-serif',
      fontSize: style?.fontSize,
      fontWeight: style?.fontWeight,
      color: style?.color,
      height: style?.height,
    ).merge(style);
  }
}
