import 'dart:math';

import 'package:flutter/material.dart';
import 'package:haring/models/dot.dart';
import 'package:haring/models/history.dart';
import 'package:haring/pages/_global/globals.dart';
import 'package:haring/pages/sheet_modification_page/widgets/slidebar.dart';

class LineInfo {
 List<Dot> tempLine;
 DateTime genTime = DateTime.now();

 LineInfo({required this.tempLine,});
}

class Painter {

  // variables
  List<LineInfo> lineInfos = [];
  List<List<Dot>> lines = [];
  final histories = History();

  double _size = 2.0;
  Color _color = Colors.black;
  bool _eraseMode = false;

  // getters
  List<List<Dot>> get allLines {
    List<List<Dot>> _lines = [];
    for (List<Dot> line in lines) {
      _lines.add(line);
    }
    for (LineInfo lineInfo in lineInfos) {
      _lines.add(lineInfo.tempLine);
    }
    return _lines;
  }
  double get size => _size;
  Color get color => _color;
  bool get eraseMode => _eraseMode;

  // setters
  void setSize(double size) => _size = size;
  void setColor(Color color) => _color = color;
  void setEraseMode(bool eraseMode) => _eraseMode = eraseMode;

  // methods
  void drawStart(Offset offset) {
    List<Dot> _line = [];
    _line.add(Dot(
      offset: Offset(offset.dx, offset.dy),
      color: painterCont.color,
      size: painterCont.size,
    ));

    tempMode ? lineInfos.add(LineInfo(tempLine: _line)) :
    lines.add(_line);
  }

  void drawing(Offset offset) {
    Dot _dot = Dot(
      offset: Offset(offset.dx, offset.dy),
      color: painterCont.color,
      size: painterCont.size,
    );
    tempMode ? lineInfos.last.tempLine.add(_dot) :
    lines.last.add(_dot);
  }

  void drawEnd() {
    !tempMode ? histories.addHistory(lines) :
    lineInfos.last.genTime = DateTime.now();
  }

  void erase(Offset offset) {
    const eraserSize = 15.0;

    for (int i = lines.length; i > 0; i--) {
      for (Dot dot in lines[i - 1]) {
        if (sqrt(pow(offset.dx * imageSize.width - dot.offset.dx * imageSize.width, 2)
            + pow(offset.dy * imageSize.height - dot.offset.dy * imageSize.height, 2)) < eraserSize) {
          lines.remove(lines[i - 1]);
          histories.addHistory(lines);
          break;
        }
      }
    }
  }

  void eraseAll() {
    lines = [];
    if (!tempMode) histories.addHistory(lines);
  }

  void undo() {
    List<dynamic> _past = histories.getPast();
    lines = [..._past];
  }
  void redo() {
    List<dynamic> _future = histories.getFuture();
    lines = [..._future];
  }

  void removeOlderLine(int seconds) {
    for (int i = lineInfos.length; i > 0; i--) {
      if (DateTime.now()
          .difference(lineInfos[i - 1].genTime)
          .inSeconds >= seconds) lineInfos.remove(lineInfos[i - 1]);
    }
  }

}