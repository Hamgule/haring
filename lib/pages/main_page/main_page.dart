import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:haring/models/pin.dart';
import 'package:haring/pages/_global/globals.dart';
import 'package:haring/pages/join_page/join_page.dart';
import 'package:haring/pages/sheet_modification_page/leader_page.dart';
import 'package:haring/pages/sheet_modification_page/sheet_modification_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  Widget mainButton(String text, VoidCallback? onPressed) => SizedBox(
    width: 200.0 * scale,
    height: 50.0 * scale,
    child: OutlinedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: text == 'create' ? palette.themeColor2 : palette.themeColor1,
          fontFamily: 'MontserratRegular',
          fontSize: 20.0 * scale,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: text == 'create' ? palette.themeColor2 : palette.themeColor1,
          style: BorderStyle.solid,
          width: 2.0 * scale,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    ),
  );

  Future whenCreatePressed() async {
    await pin.generatePin();
    popUp('방 입장', 'PIN: ${pin.pin}\n정말 입장하시겠습니까?', () {
      pin.savePinDB();
      Get.back();
      Get.to(() => const LeaderPage());
      displayCenterUploadButton = sheetCont.sheets.isEmpty;
      setState(() { if (pin.pin == Pin.luckyPin) palette.changeTheme('green'); });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    appbarSize = AppBar().preferredSize;

    isPad = max(screenSize.width, screenSize.height) > 1000.0;
    scale = isPad ? 1.0 : 0.5;

    return OrientationBuilder(
      builder: (context, orientation) {
        verticalMode = Orientation.portrait == orientation;
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () =>
                      setState(() {
                        clicks = 1 + clicks % redCount;
                        String theme = clicks == 10 ? 'red' : 'blue';
                        palette.changeTheme(theme);
                      }),
                  child: Logo('ha', 'ring'),
                ),
                SizedBox(height: 30.0 * scale,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    mainButton('create', whenCreatePressed),
                    SizedBox(width: 20.0 * scale,),
                    mainButton('join', () => Get.to(() => const JoinPage())),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
