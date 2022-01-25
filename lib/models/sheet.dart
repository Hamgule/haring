import 'package:flutter/material.dart';
import 'package:haring4/models/painter.dart';


class Sheet {
  int num;
  bool isSelected;
  GlobalKey? globalKey;
  Painter paint = Painter();

  Sheet({
    this.num = 0,
    this.isSelected = false,
    this.globalKey,
  });

  void toggleSelection() {
    isSelected = !isSelected;
  }
}
