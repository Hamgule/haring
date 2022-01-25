import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haring4/config/palette.dart';

Widget appBar = AppBar(
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