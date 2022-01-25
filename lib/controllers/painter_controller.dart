import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PainterController extends GetxController {

  // variables
  final Rx<Color> _color = Colors.black.obs;
  final RxDouble _size = 2.0.obs;

  // getter
  Color get color => _color.value;
  double get size => _size.value;

  // setter
  void setColor(Color color) => _color(color);
  void setSize(double size) => _size(size);

}