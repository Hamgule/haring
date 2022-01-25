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

}