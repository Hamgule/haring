import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:haring4/painter/painter.dart';

class LineHistory {
  List<List<DrawingArea>> before = [];
  List<List<DrawingArea>> after = [];

  void syncAfter() {
    if (before.length == after.length) return;
    after.clear();
    before.forEach((e) => after.add(e));
  }
}

class Datum {
  int num = 0;
  bool isSelected = false;
  List<DrawingArea> points = [];
  LineHistory lineHistory = LineHistory();

  Datum({this.num = 0, this.isSelected = false});

  void toggleSelection() {
    isSelected = !isSelected;
  }

  void addLine(List<DrawingArea> line) {
    points.add(endOfPoint);
    line.add(endOfPoint);
    lineHistory.syncAfter();
    lineHistory.before.add(line);
    lineHistory.after.add(line);
  }

  void undo() {
    if (lineHistory.before.isEmpty) return;
    lineHistory.before.removeLast();
    syncPoints();
  }

  void redo() {
    int _pivot = lineHistory.before.length;
    if (_pivot == lineHistory.after.length) return;
    List<DrawingArea> _reDoPoint = lineHistory.after[_pivot];
    lineHistory.before.add(_reDoPoint);
    syncPoints();
  }

  void syncPoints() {
    points.clear();
    for (List<DrawingArea> line in lineHistory.before) {
      points.addAll(line);
    }
  }
}

class DataController extends GetxController {

  RxList<Datum> imageData = RxList<Datum>([]);
  RxInt selectedNum = (-1).obs;
  RxInt lastNum = (-1).obs;
  RxBool isCreateEvent = false.obs;

  void setData(RxList<Datum> imageData) {
    this.imageData(imageData);
  }
  RxList<Datum> getData() => imageData;
  Datum getDataWhere(int num) => imageData.where((d) => d.num == num).first;

  void deselectAll() {
    for (Datum datum in imageData) {
      datum.isSelected = false;
    }
    selectedNum(-1);
  }

  void toggleSelection(int num) {
    if (selectedNum.value != num) deselectAll();
    getDataWhere(num).toggleSelection();
    selectedNum(getDataWhere(num).isSelected ? num : -1);
  }

  void addDatum(Datum datum) {
    imageData.add(datum);
    lastNum(datum.num);
  }

  void delDatum(int num) {
    imageData.removeWhere((datum) => datum.num == num);
  }

  List<int> getNumberList() {
    List<int> numberList = [];
    imageData.forEach((datum) => numberList.add(datum.num));
    return numberList;
  }

// methods for Debugging

  void __printSelected() {
    final List<bool> _list = [];
    for (Datum datum in imageData) {
      _list.add(datum.isSelected);
    }

    print(_list);
  }
}
