import 'dart:math';

import 'package:haring4/models/dot.dart';

class History {

  static const int stackLimit = 100;
  static const List<dynamic> noHistory = [];

  List<List<dynamic>> stack = [[]];
  int pivot = 0;

  void increasePivot() => pivot = min(stack.length - 1, pivot + 1);
  void decreasePivot() => pivot = max(0, pivot - 1);

  void addHistory(List<dynamic> state) {
    if (pivot + 1 < stack.length) {
      stack.removeRange(pivot + 1, stack.length);
    }
    stack.add([...state]);

    if (stack.length > stackLimit) {
      stack.removeAt(0);
      stack.removeAt(0);
      return;
    }

    pivot++;
  }

  List<dynamic> getPast() {
    decreasePivot();
    return stack[pivot];
  }

  List<dynamic> getFuture() {
    increasePivot();
    return stack[pivot];
  }

}