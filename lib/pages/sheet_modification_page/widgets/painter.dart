import 'package:flutter/material.dart';
import 'package:haring4/models/dot.dart';
import 'package:haring4/pages/_global/globals.dart';

class MyPainter extends CustomPainter {

  final List<List<Dot>> lines;

  MyPainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    for (var line in lines) {
      List<Offset> offsets = [];
      Path path = Path();
      Color? color;
      double? weight;

      for (var dot in line) {
        color = dot.color;
        weight = dot.size;
        offsets.add(Offset(
          dot.offset.dx * imageSize.width,
          dot.offset.dy * imageSize.height,
        ));
      }

      path.addPolygon(offsets, false);
      canvas.drawPath(path, Paint()
          ..color = color!
          ..strokeWidth = weight!
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}