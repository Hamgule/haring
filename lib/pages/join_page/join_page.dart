import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haring4/config/palette.dart';
import 'package:haring4/pages/_global/globals.dart';
import 'package:haring4/pages/sheet_modification_page/user_page.dart';

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

    return Scaffold(
      appBar: myAppBar,
      body: Column(
        children: [
          const Logo('ha', 'ring'),
          const SizedBox(
            height: 20.0,
          ),
          InputForm(
            controller: pinController,
            hintText: 'PIN',
            onButtonPressed: () {
              Get.to(const UserPage());
            }
          ),
        ],
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
    fontSize: 20.0, fontFamily: fontFamily, color: color,
  );

  OutlineInputBorder getInputBorder(Color color) => OutlineInputBorder(
    borderSide: BorderSide(width: 2.0, color: color,),
  );

  TextFormField getInputArea() => TextFormField(
    controller: controller,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.7),
      enabledBorder: getInputBorder(Palette.deactiveColor),
      focusedBorder: getInputBorder(Palette.themeColor1),
      hintText: hintText,
      hintStyle: getTextStyle(Palette.deactiveColor),
      contentPadding: const EdgeInsets.all(15.0),
    ),
    style: getTextStyle(Palette.themeColor1),
  );

  OutlinedButton getButton() => OutlinedButton(
    onPressed: onButtonPressed,
    child: const Icon(
      Icons.arrow_forward_ios,
      color: Palette.themeColor1,
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
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          child: SizedBox(width: 400.0, child: getInputArea(),),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0,),
          width: 50.0,
          height: 50.0,
          child: getButton(),
        ),
      ],
    );
  }
}

