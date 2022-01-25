import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haring4/models/sheet.dart';

class SheetController extends GetxController {

  // variables
  final sheets = RxList<Sheet>([]);

  final RxInt _selectedNum = (-1).obs;
  final RxInt _maxNum = (-1).obs;
  final RxBool _isCreate = false.obs;

  // getters
  Sheet getDataWhere(int num) => sheets.where((sheet) => sheet.num == num).first;
  int get selectedNum => _selectedNum.value;
  int get maxNum => _maxNum.value;
  bool get isCreate => _isCreate.value;

  // setters
  void setSelectedNum(int selectedNum) => _selectedNum(selectedNum);
  void setMaxNum(int maxNum) => _selectedNum(maxNum);
  void setIsCreate(bool isCreate) => _isCreate(isCreate);

  // methods
  void deselectAll() {
    for (Sheet sheet in sheets) { sheet.isSelected = false; }
    _selectedNum(-1);
  }

  void toggleSelection(int num) {
    if (_selectedNum.value != num) deselectAll();
    getDataWhere(num).toggleSelection();
    _selectedNum(getDataWhere(num).isSelected ? num : -1);
  }

  void addSheet(Sheet sheet) { sheets.add(sheet); _maxNum(sheet.num); }
  void delSheet(int num) => sheets.removeWhere((sheet) => sheet.num == num);

  List<int> getNumbers() {
    List<int> _numbers = [];
    sheets.forEach((sheet) => _numbers.add(sheet.num));
    return _numbers;
  }

  List<GlobalKey?> getGlobalKeys() {
    List<GlobalKey?> _globalKeys = [];
    sheets.forEach((sheet) => _globalKeys.add(sheet.globalKey));
    return _globalKeys;
  }

}

