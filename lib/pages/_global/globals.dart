import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haring4/config/palette.dart';
import 'package:haring4/controllers/painter_controller.dart';
import 'package:haring4/controllers/sheet_controller.dart';
import 'package:haring4/controllers/sidebar_controller.dart';
import 'package:haring4/models/sheet.dart';

/// variables

final painterCont = Get.put(PainterController());
final sheetCont = Get.put(SheetController());
final sidebarCont = Get.put(SidebarController());
final scrollCont = ScrollController();

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

// appbar

final PreferredSizeWidget myAppBar = AppBar(
  backgroundColor: Colors.white.withOpacity(0.0),
  elevation: 0.0,
  iconTheme: const IconThemeData(
    color: Palette.themeColor1,
  ),
  leading: IconButton(
    icon: const Icon(
      Icons.arrow_back_ios,
    ),
    onPressed: () {
      Get.back();
    },
  ),
);

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

// input form


