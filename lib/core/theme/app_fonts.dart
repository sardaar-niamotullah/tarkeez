import 'package:flutter/material.dart';

enum AppFontFamily { poppins, sourceSans, arialRounded }

class AppFonts {
  static const _familyNames = {
    AppFontFamily.sourceSans: 'SourceSans3',
    AppFontFamily.poppins: 'Poppins',
    AppFontFamily.arialRounded: 'ArialRounded',
  };

  static TextStyle font({
    required double size,
    required FontWeight weight,
    required Color color,
    double? height,
    AppFontFamily fontFamily = AppFontFamily.sourceSans,
  }) {
    return TextStyle(
      fontFamily: _familyNames[fontFamily],
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }
}
