import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:haring/config/palette.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => setState(() => clicks = 1 + clicks % isRed),
              child: Logo('ha', 'ring'),
            ),
            const SizedBox(height: 30.0,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 200.0,
                  height: 50.0,
                  child: OutlinedButton(
                    onPressed: () {
                      pin.generatePin();
                      popUp('방 입장', 'PIN: ${pin.pin}\n정말 입장하시겠습니까?', () {
                        pin.savePinDB();
                        Get.back();
                        Get.to(() => const LeaderPage());
                        displayCenterUploadButton = sheetCont.sheets.isEmpty;
                      });
                    },
                    child: Text(
                      'create',
                      style: TextStyle(
                        color: Palette().themeColor2,
                        fontFamily: 'MontserratRegular',
                        fontSize: 20.0,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Palette().themeColor2,
                        style: BorderStyle.solid,
                        width: 2.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 30,),
                SizedBox(
                  width: 200.0,
                  height: 50.0,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.to(() => const JoinPage());
                    },
                    child: Text(
                      'join',
                      style: TextStyle(
                        color: Palette().themeColor1,
                        fontFamily: 'MontserratRegular',
                        fontSize: 20.0,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Palette().themeColor1,
                        style: BorderStyle.solid,
                        width: 2.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
