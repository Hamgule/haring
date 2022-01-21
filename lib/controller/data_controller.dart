import 'package:get/get.dart';
import 'package:haring4/painter/painter.dart';

class Datum {
  int num = 0;
  bool isSelected = false;
  List<DrawingArea> points = [];
  Datum({this.num = 0, this.isSelected = false});

  void toggleSelection() {
    isSelected = !isSelected;
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
