import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haring4/config/palette.dart';
import 'package:haring4/models/sheet.dart';
import 'package:haring4/pages/_global/globals.dart';
import 'package:haring4/pages/sheet_modification_page/sheet_modification_page.dart';
import 'package:haring4/pages/sheet_modification_page/widgets/painter.dart';
import 'package:haring4/pages/sheet_modification_page/widgets/slidebar.dart';

class SheetScrollView extends StatefulWidget {
  const SheetScrollView({Key? key, required this.isLeader}) : super(key: key);

  final bool isLeader;

  @override
  SheetScrollViewState createState() => SheetScrollViewState();
}

class SheetScrollViewState extends State<SheetScrollView> {

  Future loadOnceDB(DatabaseReference f) async {
    DatabaseEvent event = await f.once();
    sheetCont.subLoadDB(event);
  }

  Future loadRealDB(DatabaseReference f) async {
    Stream<DatabaseEvent> stream = f.onValue;
    stream.listen((event) {
      setState(() {
        sheetCont.storeBeforeLoad();
        sheetCont.sheets(RxList<Sheet>([]));
        sheetCont.subLoadDB(event);
        sheetCont.restoreAfterLoad();
      });
    });
  }

  @override
  void initState() {
    super.initState();

    final f = FirebaseDatabase.instance.ref('pins/${pin.pin}/sheets');
    widget.isLeader ? loadOnceDB(f) : loadRealDB(f);

    scrollCont.addListener(() => scrollListener());
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> musicSheets(bool isLeader) {
    final List<Widget> _list = [];

    for (int i = 0; i < (sheetCont.sheets.length - 1) / 2; i++) {
      _list.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MusicSheetWidget(
              isLeader: isLeader,
              sheet: sheetCont.sheets[2 * i],
              index: 2 * i,
            ),
            const SizedBox(width: 10.0),
            MusicSheetWidget(
              isLeader: isLeader,
              sheet: sheetCont.sheets[2 * i + 1],
              index: 2 * i + 1,
            ),
          ],
        ),
      );
    }
    if (sheetCont.sheets.length % 2 == 1) {
      _list.add(
        MusicSheetWidget(
          isLeader: isLeader,
          sheet: sheetCont.sheets.last,
          index: sheetCont.sheets.length - 1,
        ),
      );
    }

    return _list;
  }

  void scrollListener() async {
    double _screenHeight = screenSize.height - appbarSize.height;
    currentScrollNum = (scrollCont.offset / _screenHeight).round();
  }

  @override
  Widget build(BuildContext context) {

    screenSize = MediaQuery.of(context).size;
    appbarSize = AppBar().preferredSize;

    return SizedBox(
      height: screenSize.height - appbarSize.height,
      child: SingleChildScrollView(
        physics: sheetCont.selectedNum < 0 ?
          null : const NeverScrollableScrollPhysics(),
        controller: scrollCont,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: musicSheets(widget.isLeader),
          ),
        ),
      ),
    );
  }

}

class MusicSheetWidget extends StatefulWidget {
  const MusicSheetWidget({
    Key? key,
    required this.isLeader,
    required this.sheet,
    required this.index,
  }) : super(key: key);

  final bool isLeader;
  final Sheet sheet;
  final int index;

  @override
  _MusicSheetWidgetState createState() => _MusicSheetWidgetState();
}

class _MusicSheetWidgetState extends State<MusicSheetWidget> {

  @override
  void initState() {
    super.initState();

    if (sheetCont.isCreate) {
      WidgetsBinding.instance!
        .addPostFrameCallback((_) => focusSheet(sheetCont.maxNum));
      sheetCont.setIsCreate(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    SheetModificationPageState? parent = context
        .findAncestorStateOfType<SheetModificationPageState>();
    final Sheet sheet = widget.sheet;

    screenSize = MediaQuery.of(context).size;
    appbarSize = AppBar().preferredSize;
    bool good = true;

    double screenHeight = screenSize.height - appbarSize.height;
    double sheetWidth = screenSize.width * 0.4;
    double sheetHeight = screenHeight * 0.9;
    double marginHeight = screenHeight * 0.04;
    double titleHeight = screenHeight * 0.040;

    void tapStart(Offset offset) {
      if (!sheet.isSelected) return;

      if (widget.isLeader) {
        if (sheet.paint.eraseMode) {
          sheet.paint.erase(offset);
          return;
        }
        sheet.paint.drawStart(offset);
      }
      else {
        if (sheet.privatePaint.eraseMode) {
          sheet.privatePaint.erase(offset);
          return;
        }
        sheet.privatePaint.drawStart(offset);
      }
    }

    void tapUpdate(Offset offset) {
      if (!sheet.isSelected) return;

      if (widget.isLeader && sheet.isSelected) {
        if (sheet.paint.eraseMode) {
          sheet.paint.erase(offset);
          return;
        }
        sheet.paint.drawing(offset);
        // sheetCont.updateDB();
      }
      else {
        if (sheet.privatePaint.eraseMode) {
          sheet.privatePaint.erase(offset);
          return;
        }
        sheet.privatePaint.drawing(offset);
      }
    }

    void tapEnd() {
      if (widget.isLeader && sheet.isSelected && !eraseMode) {
        sheet.paint.drawEnd();
        sheetCont.updateDB();

        Timer(
          const Duration(seconds: removeSec),
          () => setState(() {
            sheet.paint.removeOlderLine(removeSec);
            sheetCont.updateDB();
          }),
        );
        return;
      }
      sheet.privatePaint.drawEnd();
    }
    return Column(
      children: [
        Container(
          child: GestureDetector(
            onDoubleTap: () => parent!.setState(() {
              toggleSelection(sheet.num);
              if (widget.isLeader) { sheet.paint.setEraseMode(eraseMode); }
              else { sheet.privatePaint.setEraseMode(eraseMode); }
            }),
            onPanStart: (details) => parent!.setState(() => tapStart(details.localPosition)),
            onPanUpdate: (details) => parent!.setState(() => tapUpdate(details.localPosition)),
            onPanEnd: (details) => parent!.setState(() => tapEnd()),
            child: AnimatedContainer(
              margin: EdgeInsets.fromLTRB(0, 0, 0, marginHeight),
              duration: const Duration(milliseconds: 250),
              width: sheetWidth,
              height: sheetHeight,
              key: sheet.globalKey,
              decoration: BoxDecoration(
                color: sheet.isSelected ?
                Palette.themeColor1.withOpacity(.3) :
                Colors.grey.withOpacity(.3),
                border: Border.all(
                  width: 3.0,
                  color: sheet.isSelected ?
                  Palette.themeColor1 : Colors.transparent,
                ),
              ),
              child: Stack(
                children: [
                  if (widget.isLeader && sheet.image != null)
                  Positioned(
                    child: Center(
                      child: Image.file(
                        sheet.image!,
                        width: sheetWidth,
                        height: sheetHeight,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  if (!widget.isLeader && sheet.imageUrl != null)
                  Positioned(
                    child: Center(
                      child: Image.network(
                        sheet.imageUrl!,
                        width: sheetWidth,
                        height: sheetHeight,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    child: SizedBox(
                      width: sheetWidth,
                      height: sheetHeight,
                      child: ClipRRect(
                        child: Stack(
                          children: [
                            Positioned(
                              child: CustomPaint(
                                painter: MyPainter(sheet.paint.lines,),
                              ),
                            ),
                            if (!widget.isLeader)
                            Positioned(
                              child: CustomPaint(
                                painter: MyPainter(sheet.privatePaint.lines,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: GestureDetector(
                      onTap: () {
                        titleController.text = sheet.title;
                        titlePopUp(() {
                          Get.back();
                          setState(() => sheet.title = titleController.text);
                          sheetCont.updateDB();
                          titleController.text = '';
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: sheetWidth,
                        height: titleHeight,
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          child: Text(sheet.title,),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                            color: sheet.isSelected ? Palette.themeColor2 : Colors.black45,
                            fontFamily: 'MontserratBold',
                            fontFamilyFallback: const ['OneMobileTitle',],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (widget.isLeader)
                  Positioned(
                    right: 0.0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () => parent!.setState(() => delImage(sheet.num)),
                    ),
                  ),
                  if((sheet.image == null && widget.isLeader) || (sheet.imageUrl == null && !widget.isLeader))
                  Positioned(
                    child: Center(
                      child: Text(
                        '${sheet.num + 1}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(.5),
                          fontSize: 180.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}