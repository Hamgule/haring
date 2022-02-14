import 'package:flutter/material.dart';

class Dot {
  late Offset offset;
  final double size;
  final Color color;

  Dot({
    required this.offset,
    this.size = 2.0,
    this.color = Colors.black,
  });

  static dynamic stringToValue(String type, String text) {
    RegExp exp;
    RegExpMatch? matches;

    if (type == 'offset') {
      exp = RegExp(r'(\d+.\d+), (\d+.\d+)');
      matches = exp.firstMatch(text);
      List<String> offset = matches!.group(0)!.split(', ');
      return Offset(double.parse(offset[0]), double.parse(offset[1]));
    }

    else if (type == 'color') {
      exp = RegExp(r'(0x\w+)');
      matches = exp.firstMatch(text);
      return Color(int.parse(matches!.group(0).toString()));
    }
  }
}