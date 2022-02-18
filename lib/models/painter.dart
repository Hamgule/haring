import 'dart:math';

import 'package:flutter/material.dart';
import 'package:haring4/models/dot.dart';
import 'package:haring4/models/history.dart';
import 'package:haring4/pages/_global/globals.dart';
import 'package:haring4/pages/sheet_modification_page/widgets/slidebar.dart';

class Painter {

  // variables
  List<List<Dot>> lines = [];
  List<DateTime> genTimes = [];
  List<bool> isTemps = [];
  final histories = History();

  double _size = 2.0;
  Color _color = Colors.black;
  bool _eraseMode = false;

  // getters
  double get size => _size;
  Color get color => _color;
  bool get eraseMode => _eraseMode;

  // setters
  void setSize(double size) => _size = size;
  void setColor(Color color) => _color = color;
  void setEraseMode(bool eraseMode) => _eraseMode = eraseMode;

  // methods
  void drawStart(Offset offset) {
    List<Dot> line = [];
    line.add(Dot(
      offset: Offset(offset.dx, offset.dy),
      color: painterCont.color,
      size: painterCont.size,
    ));
    lines.add(line);
  }

  void drawing(Offset offset) {
    lines.last.add(Dot(
      offset: Offset(offset.dx, offset.dy),
      color: painterCont.color,
      size: painterCont.size,
    ));
  }

  void drawEnd() {
    if (!tempMode) histories.addHistory(lines);
    genTimes.add(DateTime.now());
    isTemps.add(tempMode);
  }

  void erase(Offset offset) {
    const eraserSize = 15.0;

    for (int i = 0; i < lines.length; i++) {
      if (isTemps[i]) continue;
      for (Dot dot in lines[i]) {
        if (sqrt(pow(offset.dx * imageWidth - dot.offset.dx * imageWidth, 2)
            + pow(offset.dy * imageHeight - dot.offset.dy * imageHeight, 2)) < eraserSize) {
          genTimes.removeAt(i);
          isTemps.removeAt(i);
          lines.removeAt(i);
          break;
        }
      }
    }
  }

  void eraseAll() {
    for (int i = lines.length; i > 0; i--) {
      if (isTemps[i - 1]) continue;
      genTimes.removeAt(i - 1);
      isTemps.removeAt(i - 1);
      lines.removeAt(i - 1);
    }
    if (!tempMode) histories.addHistory(lines);
  }

  void undo() {
    List<List<Dot>> _past = histories.getPast();
    lines = [..._past];
  }
  void redo() {
    List<List<Dot>> _future = histories.getFuture();
    lines = [..._future];
  }

  void removeOlderLine(int seconds) {
    for (int i = 0; i < genTimes.length; i++) {
      if (isTemps[i] && DateTime.now().difference(genTimes[i]).inSeconds >= seconds) {
        genTimes.removeAt(i);
        isTemps.removeAt(i);
        lines.removeAt(i);
      }
    }
  }

}