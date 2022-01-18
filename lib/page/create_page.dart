import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haring4/config/palette.dart';
import 'package:haring4/page/leader_page.dart';


class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: const Text(
                '사진을 추가하세요',
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'NanumGothicRegular',
                  color: Palette.themeColor1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              width: 300.0,
              height: 300.0,
              child: OutlinedButton(
                onPressed: () {
                  Get.to(() => LeaderPage());
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
