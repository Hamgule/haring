import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haring4/config/palette.dart';
import 'package:haring4/pages/_global/globals.dart';
import 'package:haring4/pages/sheet_modification_page/leader_page.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: myAppBar,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '사진을 추가하세요',
              style: TextStyle(
                fontSize: 30.0,
                fontFamily: 'NanumGothicRegular',
                color: Palette.themeColor1,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: 300.0,
              height: 300.0,
              child: OutlinedButton(
                onPressed: () {
                  Get.to(const LeaderPage());
                },
                child: const Icon(
                  Icons.add,
                  size: 100.0,
                  color: Palette.themeColor1,
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    width: 5.0,
                    color: Palette.themeColor1,
                    style: BorderStyle.solid,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
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
