import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haring4/config/palette.dart';
import 'package:haring4/controllers/painter_controller.dart';
import 'package:haring4/controllers/sheet_controller.dart';
import 'package:haring4/controllers/sidebar_controller.dart';
import 'package:haring4/models/pin.dart';
import 'package:haring4/models/sheet.dart';

/// variables

final painterCont = Get.put(PainterController());
final sheetCont = Get.put(SheetController());
final sidebarCont = Get.put(SidebarController());
final scrollCont = ScrollController();
final pin = Pin();

const imagePermission = false;

late int currentScrollNum;
late Size screenSize;
late Size appbarSize;

/// methods

void deselectAll() => sheetCont.deselectAll();
void toggleSelection(int num) => sheetCont.toggleSelection(num);

void addImage(int num) => sheetCont.addSheet(Sheet(num: num, globalKey: GlobalKey(),),);
void delImage(int num) => sheetCont.delSheet(num);

void focusSheet(int num) {
  Scrollable.ensureVisible(
    sheetCont.getDataWhere(num).globalKey!.currentContext!,
    duration: const Duration(milliseconds: 600),
    curve: Curves.easeInOut,
  );
}

/// widgets

// logo

class Logo extends StatelessWidget {
  const Logo(
    this.firstText,
    this.secondText, {
    Key? key,
    this.shadowing = true,
  }) : super(key: key) ;

  final String firstText;
  final String secondText;
  final bool shadowing;

  static const Color firstColor = Palette.themeColor1;
  static const Color secondColor = Palette.themeColor2;

  List<Shadow>? getShadow() => shadowing ? [
    const Shadow(
      offset: Offset(5.0, 5.0),
      blurRadius: 10.0,
      color: Colors.black38,
    ),
  ] : null;

  Widget logo(String text, Color color) => Text(
    text,
    style: TextStyle(
      color: color,
      fontFamily: 'MontserratBold',
      fontSize: 150.0,
      fontWeight: FontWeight.bold,
      shadows: getShadow(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        logo(firstText, firstColor),
        logo(secondText, secondColor),
      ],
    );
  }
}

// pin

class PinWidget extends StatelessWidget {
  const PinWidget(this.pin, {Key? key}) : super(key: key) ;

  final String pin;

  static const Color firstColor = Palette.themeColor2;
  static const Color secondColor = Palette.themeColor1;

  Widget pinWidget(String text, Color color) => Text(
    text,
    style: TextStyle(
      color: color,
      fontFamily: 'MontserratBold',
      fontSize: 40.0,
      fontWeight: FontWeight.bold,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      bottom: 0,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 20.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            pinWidget('PIN ', firstColor),
            pinWidget(pin, secondColor),
          ],
        ),
      ),
    );
  }
}

// dialog
void popUp(String title, String content, VoidCallback onConfirm) {
  Get.defaultDialog(
    title: title,
    titleStyle: const TextStyle(fontWeight: FontWeight.bold,),
    titlePadding: const EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 5.0),
    content: Column(
      children: [
        Container(
          height: 80.0,
          decoration: BoxDecoration(
            color: Palette.themeColor1.withOpacity(.1),
          ),
          child: Center(
              child: Text(content, textAlign: TextAlign.center,),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: TextButton(
                onPressed: onConfirm,
                child: const Text('확인',),
              ),
            ),
          ],
        )
      ],
    ),
  );
}

