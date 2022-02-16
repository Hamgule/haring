import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:haring4/config/palette.dart';
import 'package:haring4/models/sheet.dart';
import 'package:haring4/pages/_global/globals.dart';
import 'package:haring4/pages/sheet_modification_page/widgets/sidebar.dart';
import 'package:haring4/pages/sheet_modification_page/widgets/sheet_scroll_view.dart';
import 'package:haring4/pages/sheet_modification_page/widgets/slidebar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


void uploadImage(String title) {
  int num = sheetCont.maxNum + 1;
  addImage(num, title);
  sheetCont.setIsCreate(true);
}

void downloadImage(int num) {
  if (num < 0) return;
  sheetCont.downloadFile(num);
}


class SheetModificationPage extends StatefulWidget {
  const SheetModificationPage({
    Key? key, required this.isLeader,})
      : super(key: key);

  final bool isLeader;

  @override
  SheetModificationPageState createState() => SheetModificationPageState();
}

class SheetModificationPageState extends State<SheetModificationPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Future pickImage() async {
      try {
        XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image == null) return;

        Sheet _sheet = sheetCont.getDataWhere(sheetCont.maxNum);
        setState(() => _sheet.image = File(image.path));
        sheetCont.uploadFile(image);

      } on PlatformException catch (e) {
        print("Failed to pick image: $e");
      }
    }

    void subUploadImage(String title) async {
      uploadImage(title);
      pickImage();
    }

    return Scaffold(
      key: sidebarCont.scaffoldKey,
      endDrawerEnableOpenDragGesture: false,
      appBar: ModificationPageAppBar(
        isLeader: widget.isLeader,
      ),
      body: Stack(
        children: [
          SheetScrollView(isLeader: widget.isLeader),
          PinWidget(pin.pin),
          const SideButton(direction: 'left'),
          const SideButton(direction: 'right'),
          Positioned(
            right: 0,
            left: 0,
            bottom: 20.0,
            child: SlideBar(
              cb: (int i) => print(i),
              isLeader: widget.isLeader,
            ),
          ),
          if (widget.isLeader && sheetCont.sheets.isEmpty)
          Positioned(
            child: Center(
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
                  const SizedBox(height: 10.0,),
                  SizedBox(
                    width: 300.0,
                    height: 300.0,
                    child: OutlinedButton(
                      onPressed: () {
                        titleController.text = 'sheet ${sheetCont.maxNum + 2}';
                        titlePopUp(() {
                          Get.back();
                          subUploadImage(titleController.text);
                          titleController.text = '';
                        });
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
          ),
        ],
      ),
      endDrawer: Sidebar(isLeader: widget.isLeader),
    );
  }
}

class ModificationPageAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ModificationPageAppBar({Key? key, required this.isLeader}) : super(key: key);

  final bool isLeader;

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  State<ModificationPageAppBar> createState() => _ModificationPageAppBarState();
}

class _ModificationPageAppBarState extends State<ModificationPageAppBar> {

  @override
  Widget build(BuildContext context) {

    SheetModificationPageState? parent = context
        .findAncestorStateOfType<SheetModificationPageState>();

    Future pickImage() async {
      try {
        final image = await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image == null) return;

        parent!.setState(() {
          sheetCont.getDataWhere(sheetCont.maxNum).image = File(image.path);
        });

      } on PlatformException catch (e) {
        print("Failed to pick image: $e");
      }
    }

    void subUploadImage(String title) {
      uploadImage(title);
      pickImage();
    }

    return AppBar(
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
          String msg = '';
          msg = widget.isLeader ? '모든 시트 정보가 초기화 됩니다.\n' : '';
          msg += '정말로 방을 나가시겠습니까?';
          popUp(
            '주의', msg, () {
              if (widget.isLeader) {
                pin.removePin();
              }
              sheetCont.clearSheetData();
              Get.back();
              Get.back();
            }
          );
        },
      ),
      actions: [
        IconButton(
          icon: Icon(
            sheetCont.selectedNum < 0
                ? Icons.check_box_outline_blank
                : Icons.check_box,
          ),
          onPressed: () => parent!.setState(() => deselectAll()),
        ),
        if (widget.isLeader)
        IconButton(
          icon: const Icon(Icons.upload,),
          onPressed: () {
            titleController.text = 'sheet ${sheetCont.maxNum + 2}';
            titlePopUp(() {
              Get.back();
              parent!.setState(() => subUploadImage(titleController.text));
              titleController.text = '';
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.download,),
          onPressed: () => parent!.setState(() => downloadImage(sheetCont.selectedNum)),
        ),
        IconButton(
          icon: const Icon(Icons.view_sidebar,),
          onPressed: () => sidebarCont.openDrawer(),
        ),
      ],
    );
  }
}

class SideButton extends StatefulWidget {
  const SideButton({
    Key? key,
    required this.direction,
  }) : super(key: key);

  final String direction;

  @override
  _SideButtonState createState() => _SideButtonState();
}

class _SideButtonState extends State<SideButton> {
  bool buttonDown = false;

  void buttonPressed() {
    List<int> _numbers = sheetCont.getNumbers();

    if (widget.direction == 'left' && currentScrollNum > 0) {
      focusSheet(_numbers[(currentScrollNum - 1) * 2]);
    }

    if (widget.direction == 'right' && _numbers.length > 1 &&
        _numbers[currentScrollNum + 1] < _numbers.length / 2) {
      focusSheet(sheetCont.getNumbers()[(currentScrollNum + 1) * 2]);
    }
  }

  @override
  Widget build(BuildContext context) {

    SheetModificationPageState? parent = context
        .findAncestorStateOfType<SheetModificationPageState>();

    screenSize = MediaQuery.of(context).size;
    final sideButtonWidth = screenSize.width * 0.1;
    final sideButtonHeight = screenSize.height * 0.9;

    return Positioned(
      left: widget.direction == 'left' ? 0 : null,
      right: widget.direction == 'right' ? 0 : null,
      bottom: 0,
      width: sideButtonWidth,
      height: sideButtonHeight,
      child: GestureDetector(
        onTap: () => parent!.setState(() => buttonPressed()),
        onTapDown: (details) => setState(() => buttonDown = true),
        onTapUp: (details) => setState(() => buttonDown = false),
        child: AnimatedOpacity(
          opacity: buttonDown ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withOpacity(
                    widget.direction == 'left' ? .3 : 0,
                  ),
                  Colors.black.withOpacity(
                    widget.direction == 'right' ? .3 : 0,
                  ),
                ],
              ),
            ),
            child: Icon(
              widget.direction == 'left' ?
                Icons.arrow_back_ios :
                Icons.arrow_forward_ios,
              color: Colors.black.withOpacity(.2),
              size: 50.0,
            ),
          ),
        ),
      ),
    );
  }
}
