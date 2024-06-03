import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  TextStyles._();

  static TextStyle get primary => GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.blueGrey.shade900,
        fontWeight: FontWeight.normal,
      );

  static TextTheme get primaryTextTheme => GoogleFonts.poppinsTextTheme();
}
