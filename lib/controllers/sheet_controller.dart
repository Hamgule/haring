import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haring/models/data_storage.dart';
import 'package:haring/models/dot.dart';
import 'package:haring/models/sheet.dart';
import 'package:haring/pages/_global/globals.dart';
import 'package:image_picker/image_picker.dart';

class SheetController extends GetxController {

  // variables
  final sheets = RxList<Sheet>([]);
  final storages = RxList<DataStorage>([]);

  final RxInt _selectedNum = (-1).obs;
  final RxInt _maxNum = (-1).obs;
  final RxBool _isCreate = false.obs;
  final RxBool _addCompleted = true.obs;

  // getters
  Sheet getDataWhere(int num) => sheets.where((sheet) => sheet.num == num).first;
  int get selectedNum => _selectedNum.value;
  int get maxNum => _maxNum.value;
  bool get isCreate => _isCreate.value;
  bool get addCompleted => _addCompleted.value;

  // setters
  void setSelectedNum(int selectedNum) => _selectedNum(selectedNum);
  void setMaxNum(int maxNum) => _selectedNum(maxNum);
  void setIsCreate(bool isCreate) => _isCreate(isCreate);
  void setAddCompleted(bool addCompleted) => _addCompleted(addCompleted);

  // json
  Map<String, Object?> toJson() {
    List<Object?> sheetList = [];

    for (Sheet sheet in sheets) {
      List<Object?> lineList = [];

      for (List<Dot> line in sheet.paint.allLines) {
        List<Object?> dotList = [];

        for (Dot dot in line) {
          dotList.add({
            'offset': dot.offsetToString(),
            'color': dot.color.toString(),
            'size': dot.size,
          });
        }

        lineList.add({'line': dotList,});
      }

      sheetList.add({
        'num': sheet.num,
        'title': sheet.title,
        'imageUrl': sheet.imageUrl,
        'lines': lineList,
      });
    }
    return {'sheets': sheetList};
  }

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

  bool isExist(int num) {
    return sheets.where((sheet) => sheet.num == num).isNotEmpty;
  }

  void addSheet(Sheet sheet) {
    sheets.add(sheet);
    _maxNum(sheet.num);
    updateDB();
  }
  void delSheet(int num) {
    if (num == selectedNum) setSelectedNum(-1);
    sheets.removeWhere((sheet) => sheet.num == num);
    updateDB();
  }

  void clearSheetData() {
    sheets.clear();
    _selectedNum(-1);
    _maxNum(-1);
    _isCreate(false);
  }

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

  // database painter
  Future updateDB() async {
    final f = FirebaseDatabase.instance.ref('pins/${pin.pin}');
    await f.update(toJson());
  }

  void storeBeforeLoad() {
    for (Sheet sheet in sheets) {
      storages.add(
        DataStorage(
          num: sheet.num,
          isSelected: sheet.isSelected,
          paint: sheet.privatePaint,
        ),
      );
    }
  }

  void restoreAfterLoad() {
    for (DataStorage storage in storages) {
      if (isExist(storage.num)) {
        getDataWhere(storage.num).isSelected = storage.isSelected;
        getDataWhere(storage.num).privatePaint = storage.paint;
      }
    }
  }

  void subLoadDB(DatabaseEvent event) {
    if (event.snapshot.value == null) return;
    List<Object?> loadedSheets = event.snapshot.value as List;

    for (var loadedSheet in loadedSheets) {
      Sheet sheet = Sheet(globalKey: GlobalKey(),);
      loadedSheet as Map;
      sheet.num = loadedSheet['num'];
      sheet.title = loadedSheet['title'];
      sheet.imageUrl = loadedSheet['imageUrl'];
      var loadedLines = loadedSheet['lines'];

      if (loadedLines == null) {
        sheets.add(sheet);
        continue;
      }

      for (var loadedLine in loadedLines) {
        List<Dot> dotList = [];
        var loadedDots = (loadedLine as Map)['line'];
        if (loadedDots == null) break;

        for (var loadedDot in loadedDots) {
          dotList.add(Dot(
            offset: Dot.stringToValue('offset', loadedDot['offset']),
            size: double.parse(loadedDot['size'].toString()),
            color: Dot.stringToValue('color', loadedDot['color']),
          ));
        }
        sheet.paint.lines.add(dotList);
      }
      sheets.add(sheet);
    }
  }

  void deleteAllImagesDB() =>
      sheets.forEach((sheet) =>
          FirebaseStorage.instance.refFromURL(sheet.imageUrl!).delete());

  Future uploadFile(XFile? image, int index) async {
    Reference ref = FirebaseStorage.instance
      .ref('pins/${pin.pin}/sheets/${index.toString().padLeft(3, '0')}');

    TaskSnapshot task = await ref.putFile(File(image!.path));
    sheets[index].image = File(image.path);
    sheets[index].imageUrl = await task.ref.getDownloadURL();
    updateDB();
  }

  void downloadFile(int num) {
    Sheet sheet = getDataWhere(num);

  }
}

