import 'package:flutter/painting.dart';
import 'package:haring/pages/_global/globals.dart';

class Palette {
  static const Color deactiveColor = Color(0xffaaaaaa);
  static const Color blueThemeColor1 = Color(0xff4a8cff);
  static const Color blueThemeColor2 = Color(0xff003ba3);
  static const Color redThemeColor1 = Color(0xffff8c4a);
  static const Color redThemeColor2 = Color(0xffa33400);
  static const Color greenThemeColor1 = Color(0xff59d14b);
  static const Color greenThemeColor2 = Color(0xff00a33c);

  Color themeColor1 = clicks < isRed ? blueThemeColor1 : redThemeColor1;
  Color themeColor2 = clicks < isRed ? blueThemeColor2 : redThemeColor2;

}