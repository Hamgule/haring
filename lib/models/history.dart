import 'dart:math';

import 'package:haring4/models/dot.dart';

class History {

  static const int stackLimit = 100;
  static const List<List<Dot>> noHistory = [];

  List<List<List<Dot>>> lineStack = [[]];
  int pivot = 0;

  void increasePivot() => pivot = min(lineStack.length - 1, pivot + 1);

  void decreasePivot() => pivot = max(0, pivot - 1);

  void addHistory(List<List<Dot>> state) {
    if (pivot + 1 < lineStack.length) {
      lineStack.removeRange(pivot + 1, lineStack.length);
    }
    lineStack.add([...state]);

    if (lineStack.length > stackLimit) {
      lineStack.removeAt(0);
      return;
    }

    pivot++;
  }

  List<List<Dot>> getPast() {
    decreasePivot();
    return lineStack[pivot];
  }

  List<List<Dot>> getFuture() {
    increasePivot();
    return lineStack[pivot];
  }

}