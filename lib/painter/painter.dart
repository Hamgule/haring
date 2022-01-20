import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:haring4/controller/data_controller.dart';
import 'package:haring4/page/sheet_modification_page.dart';
import 'package:haring4/widget/musicsheet_widget.dart';


class DrawingArea {
  late Offset point;
  late Paint areaPaint;

  DrawingArea({required this.point, required this.areaPaint});
}

class MyCustomPainter extends CustomPainter {
  List<DrawingArea> points;
  Color color;
  double strokeWidth;
  Offset noPoint = const Offset(-100.0, -100.0);

  MyCustomPainter(
      {required this.points, required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.transparent;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);

    for (int x = 0; x < points.length - 1; x++) {
      if (points[x].point != noPoint && points[x + 1].point != noPoint) {
        Paint paint = points[x].areaPaint;
        canvas.drawLine(points[x].point, points[x + 1].point, paint);
      } else if (points[x].point != noPoint && points[x + 1].point == noPoint) {
        Paint paint = points[x].areaPaint;
        canvas.drawPoints(PointMode.points, [points[x].point], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}