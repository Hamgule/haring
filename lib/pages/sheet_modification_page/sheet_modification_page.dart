import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:haring/pages/_global/globals.dart';
import 'package:haring/pages/sheet_modification_page/widgets/sidebar.dart';
import 'package:haring/pages/sheet_modification_page/widgets/sheet_scroll_view.dart';
import 'package:haring/pages/sheet_modification_page/widgets/slidebar.dart';
import 'package:image_picker/image_picker.dart';

bool displayCenterUploadButton = true;

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

    Future<XFile?> pickImage() async {
      try {
        return await ImagePicker().pickImage(source: ImageSource.gallery);
      } on PlatformException catch (e) {
        print("Failed to pick image: $e");
      }
    }

    return OrientationBuilder(
      builder: (context, orientation) {
        verticalMode = Orientation.portrait == orientation;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: sidebarCont.scaffoldKey,
          endDrawerEnableOpenDragGesture: false,
          appBar: ModificationPageAppBar(
            isLeader: widget.isLeader,
          ),
          body: Stack(
            children: [
              SheetScrollView(isLeader: widget.isLeader),
              PinWidget(pin.pin),
              if (sheetCont.sheets.isNotEmpty)
              const SideButton(direction: 'left'),
              if (sheetCont.sheets.isNotEmpty)
              const SideButton(direction: 'right'),
              Positioned(
                right: 0,
                left: 0,
                bottom: 20.0 * scale,
                child: SlideBar(
                  cb: (int i) => print(i),
                  isLeader: widget.isLeader,
                ),
              ),
              if (widget.isLeader && displayCenterUploadButton)
              Positioned(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '사진을 추가하세요',
                        style: TextStyle(
                          fontSize: 30.0 * scale,
                          fontFamily: 'NanumGothicRegular',
                          color: palette.themeColor1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0 * scale,),
                      SizedBox(
                        width: 300.0 * scale,
                        height: 300.0 * scale,
                        child: OutlinedButton(
                          onPressed: () async {
                            titleController.text = 'sheet ${sheetCont.maxNum + 2}';
                            XFile? image = await pickImage();

                            if (image == null) return;
                            titlePopUp(() async {
                              setState(() => displayCenterUploadButton = false);
                              Get.back();
                              uploadImage(titleController.text);
                              await sheetCont.uploadFile(image, sheetCont.sheets.length - 1);
                              setState(() => titleController.text = '');
                            });
                          },
                          child: Icon(
                            Icons.upload,
                            size: 60.0 * scale,
                            color: palette.themeColor1,
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              width: 5.0 * scale,
                              color: palette.themeColor1,
                              style: BorderStyle.solid,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0 * scale),
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
          endDrawer: OrientationBuilder(
            builder: (context, orientation) {
              verticalMode = Orientation.portrait == orientation;
              return Sidebar(isLeader: widget.isLeader);
            }
          ),
        );
      }
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

    Future<XFile?> pickImage() async {
      try {
        return await ImagePicker().pickImage(source: ImageSource.gallery);
        // sheetCont.uploadFile(image);
      } on PlatformException catch (e) {
        print("Failed to pick image: $e");
      }
    }

    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.0),
      elevation: 0.0,
      iconTheme: IconThemeData(
        color: palette.themeColor1,
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
                sheetCont.deleteAllImagesDB();
              }
              sheetCont.clearSheetData();
              Get.back();
              Get.back();
            }
          );
        },
      ),
      title: Text(
        widget.isLeader ? 'LEADER' : 'TEAM',
        style: TextStyle(
          color: palette.themeColor1,
          fontFamily: 'MontserratBold',
        ),
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
          onPressed: () async {
            titleController.text = 'sheet ${sheetCont.maxNum + 2}';
            XFile? image = await pickImage();

            if (image == null) return;
            titlePopUp(() async {
              parent!.setState(() => displayCenterUploadButton = false);
              Get.back();
              uploadImage(titleController.text);
              await sheetCont.uploadFile(image, sheetCont.sheets.length - 1);
              parent.setState(() => titleController.text = '');
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
    int _index = 0;

    if (widget.direction == 'left') {
      if (currentScrollNum < 1) return;
      _index = verticalMode ? currentScrollNum - 1 : (currentScrollNum - 1) * 2;
    }

    else if (widget.direction == 'right') {
      int times = verticalMode ? 1 : 2;
      if (_numbers.length <= (currentScrollNum + 1) * times) return;
      _index = (currentScrollNum + 1) * times;
    }

    focusSheet(_numbers[_index]);
  }

  @override
  Widget build(BuildContext context) {
    SheetModificationPageState? parent = context
        .findAncestorStateOfType<SheetModificationPageState>();

    setVariables();
    screenSize = MediaQuery.of(context).size;
    final sideButtonSize = Size(screenSize.width * 0.1, screenHeightWithoutAppbar);

    return Positioned(
      left: widget.direction == 'left' ? 0 : null,
      right: widget.direction == 'right' ? 0 : null,
      bottom: 0,
      width: sideButtonSize.width,
      height: sideButtonSize.height,
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
