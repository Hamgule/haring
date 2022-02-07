import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haring4/config/palette.dart';
import 'package:haring4/pages/_global/globals.dart';
import 'package:haring4/pages/sheet_modification_page/widgets/sidebar.dart';
import 'package:haring4/pages/sheet_modification_page/widgets/sheet_scroll_view.dart';
import 'package:haring4/pages/sheet_modification_page/widgets/slidebar.dart';

class SheetModificationPage extends StatefulWidget {
  const SheetModificationPage({Key? key, required this.isLeader})
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

    return Scaffold(
      key: sidebarCont.scaffoldKey,
      endDrawerEnableOpenDragGesture: false,
      appBar: ModificationPageAppBar(
        isLeader: widget.isLeader,
      ),
      body: Stack(
        children: [
          SheetScrollView(isLeader: widget.isLeader),
          const SideButton(direction: 'left'),
          const SideButton(direction: 'right'),
          Positioned(
            right: 0,
            left: 0,
            bottom: 20.0,
            child: SlideBar(
              cb: (int i) => print(i),
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

  void uploadImage() {
    addImage(sheetCont.maxNum + 1);
    sheetCont.setIsCreate(true);
  }
  void downloadImage() {}

  @override
  Widget build(BuildContext context) {

    SheetModificationPageState? parent = context
        .findAncestorStateOfType<SheetModificationPageState>();

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
        onPressed: () { Get.back(); },
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
          onPressed: () => parent!.setState(() => uploadImage()),
        ),
        IconButton(
          icon: const Icon(Icons.download,),
          onPressed: () => parent!.setState(() => downloadImage()),
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
    if (widget.direction == 'left' && currentScrollNum > 0) {
      focusSheet(sheetCont.getNumbers()[(currentScrollNum - 1) * 2]);
    }
    if (widget.direction == 'right' && sheetCont.getNumbers().length > 1 &&
        sheetCont.getNumbers()[currentScrollNum + 1]
            <= sheetCont.maxNum / 2) {
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
