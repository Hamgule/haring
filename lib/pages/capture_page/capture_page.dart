import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:haring/models/sheet.dart';
import 'package:haring/pages/_global/globals.dart';
import 'package:haring/pages/sheet_modification_page/widgets/painter.dart';
import 'package:haring/pages/sheet_modification_page/widgets/sheet_scroll_view.dart';

class CapturePage extends StatefulWidget {
  const CapturePage({
    Key? key,
    required this.isLeader,
    required this.sheet,
  }) : super(key: key);

  final bool isLeader;
  final Sheet sheet;

  @override
  State<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,]);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([]);
  }

  @override
  Widget build(BuildContext context) {

    Size tempImageSize = imageSize;
    double longSide = max(screenSize.width, screenSize.height);
    imageSize = Size(longSide * 0.7 * containerRatio, longSide * 0.7);

    return Scaffold(
      appBar: myAppBar(() {
        Get.back();
        imageSize = tempImageSize;
      }),
      body: Container(
        child: Stack(
          children: [
            if (widget.isLeader && widget.sheet.image != null)
            Positioned(child: imageFile(widget.sheet.image!),),
            if (!widget.isLeader && widget.sheet.imageUrl != null)
            Positioned(child: imageNetwork(widget.sheet.imageUrl!),),
            Positioned(
              child: Center(
                child: Container(
                  width: imageSize.width,
                  height: imageSize.height,
                  child: ClipRRect(
                    child: Stack(
                      children: [
                        Positioned(
                          child: CustomPaint(
                            painter: MyPainter(widget.sheet.paint.allLines,),
                          ),
                        ),
                        if (!widget.isLeader)
                        Positioned(
                          child: CustomPaint(
                            painter: MyPainter(widget.sheet.privatePaint.allLines,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
