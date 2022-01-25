import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:haring4/config/palette.dart';
import 'package:haring4/pages/create_page/create_page.dart';
import 'package:haring4/pages/join_page/join_page.dart';

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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'ha',
                  style: TextStyle(
                    color: Palette.themeColor2,
                    fontFamily: 'MontserratBold',
                    fontSize: 150.0,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(5.0, 5.0),
                        blurRadius: 10.0,
                        color: Colors.black38,
                      ),
                    ],
                  ),
                ),
                Text(
                  'ring',
                  style: TextStyle(
                    color: Palette.themeColor1,
                    fontFamily: 'MontserratBold',
                    fontSize: 150.0,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(5.0, 5.0),
                        blurRadius: 10.0,
                        color: Colors.black38,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 200.0,
                  height: 50.0,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.to(const CreatePage());
                    },
                    child: const Text(
                      'create',
                      style: TextStyle(
                        color: Palette.themeColor2,
                        fontFamily: 'MontserratRegular',
                        fontSize: 20.0,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Palette.themeColor2,
                        style: BorderStyle.solid,
                        width: 2.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 200.0,
                  height: 50.0,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.to(const JoinPage());
                    },
                    child: const Text(
                      'join',
                      style: TextStyle(
                        color: Palette.themeColor1,
                        fontFamily: 'MontserratRegular',
                        fontSize: 20.0,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Palette.themeColor1,
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
