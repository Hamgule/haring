import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haring4/config/palette.dart';
import 'package:haring4/controller/data_controller.dart';
import 'package:haring4/controller/sidebar_controller.dart';
import 'package:haring4/page/sidebar.dart';
import 'package:haring4/widget/musicsheet_widget.dart';

final DataController contData = Get.put(DataController());
final SidebarController contSidebar = Get.put(SidebarController());

void _addImage(int num) {
  globalKeys.add(GlobalKey());
  contData.addDatum(Datum(num: num));
}

class SheetModificationPage extends StatefulWidget {
  const SheetModificationPage({Key? key, required this.isLeader}) : super(key: key);

  final bool isLeader;

  @override
  SheetModificationPageState createState() => SheetModificationPageState();
}

class SheetModificationPageState extends State<SheetModificationPage> {

  bool leftButtonDown = false;
  bool rightButtonDown = false;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    final sideButtonWidth = size.width * 0.1;
    final sideButtonHeight = size.height * 0.9;

    return Scaffold(
      key: contSidebar.scaffoldKey,
      endDrawerEnableOpenDragGesture: false,
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
        actions: [
          if (widget.isLeader)
            IconButton(
              icon: const Icon(
                Icons.upload,
              ),
              onPressed: () {
                setState(() {
                  _addImage(contData.lastNum.value + 1);
                });
              },
            ),
          IconButton(
            icon: const Icon(
              Icons.download,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.view_sidebar,
            ),
            onPressed: () {
              contSidebar.openDrawer();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SheetScrollView(isLeader: widget.isLeader),
          Positioned(
            left: 0,
            bottom: 0,
            width: sideButtonWidth,
            height: sideButtonHeight,
            child: GestureDetector(
              onTap: () {
                if (currentScrollNum > 0) {
                  focusSheet((currentScrollNum - 1) * 2);
                }
              },
              onTapDown: (value) {
                setState(() {
                  leftButtonDown = true;
                });
              },
              onTapUp: (value) {
                setState(() {
                  leftButtonDown = false;
                });
              },
              child: AnimatedOpacity(
                opacity: leftButtonDown ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black.withOpacity(.3),
                        Colors.black.withOpacity(0),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black.withOpacity(.2),
                    size: 50.0,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            width: sideButtonWidth,
            height: sideButtonHeight,
            child: GestureDetector(
              onTap: () {
                if (currentScrollNum + 1 <= contData.lastNum.value / 2) {
                  focusSheet((currentScrollNum + 1) * 2);
                }
              },
              onTapDown: (value) {
                setState(() {
                  rightButtonDown = true;
                });
              },
              onTapUp: (value) {
                setState(() {
                  rightButtonDown = false;
                });
              },
              child: AnimatedOpacity(
                opacity: rightButtonDown ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        Colors.black.withOpacity(.3),
                        Colors.black.withOpacity(0),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black.withOpacity(.2),
                    size: 50.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
          });
        },
        child: const Icon(
          Icons.brush,
        ),
        backgroundColor: Palette.themeColor1,
      ),
      endDrawer: Sidebar(isLeader: widget.isLeader),
    );
  }
}