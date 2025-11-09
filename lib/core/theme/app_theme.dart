import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData();
  static final ThemeData darkTheme = ThemeData(
    fontFamily: GoogleFonts.aclonica().fontFamily,
  );

  static TextStyle albertFont(TextStyle? style) {
    return GoogleFonts.albertSans(textStyle: style);
  }
}
