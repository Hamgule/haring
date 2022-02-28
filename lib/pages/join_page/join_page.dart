import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haring/config/palette.dart';
import 'package:haring/pages/_global/globals.dart';
import 'package:haring/pages/sheet_modification_page/user_page.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({Key? key}) : super(key: key);

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {

  late TextEditingController pinController;

  @override
  void initState() {
    pinController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOn = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      appBar: myAppBar(() => Get.back()),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Logo('ha', 'ring', isSmall: isKeyboardOn,),
            SizedBox(height: 20.0 * scale,),
            InputForm(
              controller: pinController,
              hintText: 'PIN',
              onButtonPressed: () async {
                String text = pinController.text;
                String msg = '';
                if (text == '') { msg = 'PIN 을 입력하세요.'; }
                else if (await pin.isIn(text)) {
                  setState(() {
                    pin.pin = text;
                    Get.to(() => const UserPage());
                  });
                  return;
                }
                else {
                  if (double.tryParse(text) == null) { msg = '숫자만 사용하여 입력하세요.'; }
                  else if (text.length != 6) { msg = '6자의 PIN을 입력하세요.'; }
                  else { msg = "'$text' 방이 존재하지 않습니다."; }
                }
                popUp('PIN 오류', msg, () => Get.back());
              }
            ),
            SizedBox(height: appbarSize.height),
          ],
        ),
      ),
    );
  }
}

class InputForm extends StatelessWidget {
  const InputForm({
    Key? key,
    required this.controller,
    this.hintText = '',
    this.onButtonPressed,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onButtonPressed;

  static const String fontFamily = 'MontserratRegular';

  TextStyle getTextStyle(Color color) => TextStyle(
    fontSize: 20.0 * scale, fontFamily: fontFamily, color: color,
  );

  OutlineInputBorder getInputBorder(Color color) => OutlineInputBorder(
    borderSide: BorderSide(width: 2.0 * scale, color: color,),
  );

  Widget getInputArea() => Center(
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.7),
        enabledBorder: getInputBorder(Palette.deactiveColor),
        focusedBorder: getInputBorder(palette.themeColor1),
        hintText: hintText,
        hintStyle: getTextStyle(Palette.deactiveColor),
        contentPadding: EdgeInsets.all(15.0 * scale),
      ),
      style: getTextStyle(palette.themeColor1),
    ),
  );

  Widget getButton() => Center(
    child: Container(
      width: 60.0 * scale,
      height: 60.0 * scale,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: palette.themeColor2,
          style: BorderStyle.solid,
          width: 2.0 * scale,
        ),
      ),
      child: IconButton(
        onPressed: onButtonPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: Icon(
          Icons.arrow_forward_ios,
          color: palette.themeColor2,
          size: 28.0 * scale,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          child: SizedBox(
            width: 400.0 * scale,
            height: 60.0 * scale,
            child: getInputArea(),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0 * scale,),
          width: 50.0 * scale,
          height: 50.0 * scale,
          child: getButton(),
        ),
      ],
    );
  }
}

