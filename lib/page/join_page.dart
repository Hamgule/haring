import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haring4/config/palette.dart';
import 'user_page.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({Key? key}) : super(key: key);

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {

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
      body: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  // key: _formKey,
                  child: Container(
                    width: 400.0,
                    child: TextFormField(
                    // controller: addController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.7),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                            color: Palette.deactiveColor,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                            color: Palette.themeColor1,
                          ),
                        ),
                        hintText: 'PIN',
                        hintStyle: const TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'MontserratRegular',
                          color: Palette.deactiveColor,
                        ),
                        contentPadding: const EdgeInsets.all(15.0),
                      ),
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'MontserratRegular',
                        color: Palette.themeColor1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: 50.0,
                  height: 50.0,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.to(() => const UserPage());
                    },
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
