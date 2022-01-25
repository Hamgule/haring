import 'dart:math';

import 'package:flutter/material.dart';
import 'package:haring4/models/dot.dart';
import 'package:haring4/models/history.dart';
import 'package:haring4/pages/_global/globals.dart';

class Painter {

  // variables
  List<List<Dot>> lines = [];
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
      offset: offset,
      color: painterCont.color,
      size: painterCont.size,
    ));
    lines.add(line);
  }

  void drawing(Offset offset) => lines.last.add(Dot(
    offset: offset,
    color: painterCont.color,
    size: painterCont.size,
  ));

  void drawEnd() => histories.addHistory(lines);

  void erase(Offset offset) {
    const eraserSize = 15.0;

    for (List<Dot> line in List<List<Dot>>.from(lines)) {
      for (Dot dot in line) {
        if (sqrt(pow(offset.dx - dot.offset.dx, 2)
            + pow(offset.dy - dot.offset.dy, 2)) < eraserSize) {
          lines.remove(line);
          break;
        }
      }
    }
  }

  void eraseAll() {
    lines = [];
    histories.addHistory(lines);
  }

  void undo() {
    List<List<Dot>> _past = histories.getPast();
    lines = [..._past];
  }
  void redo() {
    List<List<Dot>> _future = histories.getFuture();
    lines = [..._future];
  }

}