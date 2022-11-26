import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';

abstract class CustomFonts {
  static TextStyle defaultField(Color color) =>
      GoogleFonts.inder(fontSize: 12.sp, color: color);
  static TextStyle bigButton(Color color) =>
      GoogleFonts.inder(fontSize: 20.sp, color: color);

  static TextStyle appBar =
      GoogleFonts.inder(fontSize: 20.sp, color: CustomColors.primaryText);

  static TextStyle bodyText1(Color color) =>
      GoogleFonts.inder(fontSize: 18.sp, color: color);
  static TextStyle bodyText2(Color color) =>
      GoogleFonts.inder(fontSize: 16.sp, color: color);
  static TextStyle bodyText3(Color color) =>
      GoogleFonts.inder(fontSize: 14.sp, color: color);
  static TextStyle bodyText4(Color color) =>
      GoogleFonts.inder(fontSize: 12.sp, color: color);
  static TextStyle bodyText5(Color color) =>
      GoogleFonts.inder(fontSize: 10.sp, color: color);
  static TextStyle bodyText6(Color color) =>
      GoogleFonts.inder(fontSize: 8.sp, color: color);
}
