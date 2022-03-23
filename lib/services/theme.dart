import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color yelloClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primryClr = bluishClr;
const Color darkGrayClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class Themes {
  static final light = ThemeData(
      primaryColor: primryClr,
      brightness: Brightness.light,
      backgroundColor: white);

  static final dark = ThemeData(
      primaryColor: darkGrayClr,
      brightness: Brightness.dark,
      backgroundColor: darkGrayClr);
}

Color get backgroundColor {
  return Get.isDarkMode ? darkGrayClr : white;
}

Color get avatorBackgroundColor {
  return Get.isDarkMode ? darkHeaderClr : const Color(0xffd4d0c5);
}

Color get avatorGrowColor {
  return Get.isDarkMode ? white : darkHeaderClr;
}

List<Color> get linerGradientColors {
  return Get.isDarkMode
      ? [
          Colors.black,
          darkGrayClr,
          Colors.black,
        ]
      : [darkHeaderClr, bluishClr];
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.grey[400] : Colors.grey));
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.white : Colors.black));
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Get.isDarkMode ? Colors.white : Colors.black));
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600]));
}
