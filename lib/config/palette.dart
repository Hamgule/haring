import 'package:flutter/painting.dart';

class Palette {
  static const Color deactiveColor = Color(0xffaaaaaa);
  static const Map<String, List<Color>> colorMap = {
    'blue': [Color(0xff4a8cff), Color(0xff003ba3)],
    'red': [Color(0xffff8c4a), Color(0xffa33400)],
    'green': [Color(0xff59d14b), Color(0xff00a33c)],
  };

  String theme = 'blue';
  Color themeColor1 = colorMap['blue']![0];
  Color themeColor2 = colorMap['blue']![1];

  void changeTheme(String theme) {
    this.theme = theme;

    themeColor1 = colorMap[theme]![0];
    themeColor2 = colorMap[theme]![1];

  }
}