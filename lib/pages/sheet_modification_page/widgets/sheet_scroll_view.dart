import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haring/models/sheet.dart';
import 'package:haring/pages/_global/globals.dart';
import 'package:haring/pages/sheet_modification_page/sheet_modification_page.dart';
import 'package:haring/pages/sheet_modification_page/widgets/painter.dart';
import 'package:haring/pages/sheet_modification_page/widgets/slidebar.dart';

class SheetScrollView extends StatefulWidget {
  const SheetScrollView({Key? key, required this.isLeader}) : super(key: key);

  final bool isLeader;

  @override
  SheetScrollViewState createState() => SheetScrollViewState();
}

class SheetScrollViewState extends State<SheetScrollView> {
  late DatabaseReference f;

  Future loadOnceDB() async {
    DatabaseEvent event = await f.child('/sheets/').once();
    sheetCont.subLoadDB(event);
  }

  Future loadRealDB() async {
    Stream<DatabaseEvent> stream = f.child('/sheets/').onValue;

    stream.listen((event) {
      setState(() {
        sheetCont.storeBeforeLoad();
        sheetCont.sheets(RxList<Sheet>([]));
        sheetCont.subLoadDB(event);
        sheetCont.restoreAfterLoad();
      });
    });

    whenPinDeleted();
  }

  void whenPinDeleted() {
    Stream<DatabaseEvent> stream = f.onValue;
    stream.listen((event) {
      if (event.snapshot.value == null) {
        setState(() {
          popUp(
            '경고', '리더가 방을 닫았습니다.\n메인 화면으로 이동합니다.',
            () { Get.back(); Get.back(); Get.back(); }
          );
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    f = FirebaseDatabase.instance.ref('pins/${pin.pin}');
    widget.isLeader ? loadOnceDB() : loadRealDB();
    scrollCont.addListener(() => scrollListener());
  }

  List<Widget> musicSheets(bool isLeader) {
    final List<Widget> _list = [];

    if (verticalMode) {
      for (int i = 0; i < sheetCont.sheets.length; i++) {
        _list.add(
          MusicSheetWidget(
            isLeader: isLeader,
            sheet: sheetCont.sheets[i],
            index: i,
          ),
        );
      }
    }
    else {
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
    }

    return _list;
  }

  void scrollListener() async =>
      currentScrollNum = (scrollCont.offset / screenHeightWithoutAppbar).round();

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        verticalMode = Orientation.portrait == orientation;
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
    );
  }

}


Widget imageFile(File image) => Center(
  child: Container(
    margin: EdgeInsets.all(15.0 * scale),
    width: imageSize.width,
    height: imageSize.height,
    decoration: const BoxDecoration(
      color: Colors.white,
    ),
    child: Image.file(
      image,
      fit: BoxFit.contain,
    ),
  ),
);

Widget imageNetwork(String imageUrl) => Center(
  child: Container(
    margin: EdgeInsets.all(15.0 * scale),
    width: imageSize.width,
    height: imageSize.height,
    decoration: const BoxDecoration(
      color: Colors.white,
    ),
    child: Image.network(
      imageUrl,
      fit: BoxFit.contain,
    ),
  ),
);

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

    setVariables();

    imageSize = !isPad && !verticalMode ?
    Size(sheetSize.height * containerRatio, sheetSize.height - 20.0) :
    Size(sheetSize.width - 20.0, sheetSize.width / containerRatio);

    Offset correction = !isPad && !verticalMode ?
    Offset((sheetSize.width - imageSize.width) / 2, 10.0) :
    Offset(10.0, (sheetSize.height - imageSize.height) / 2);

    double marginHeight = screenHeightWithoutAppbar * 0.04;
    double titleHeight = screenHeightWithoutAppbar * 0.040;

    void tapEnd() {
      if (!sheet.isSelected) return;
      if (widget.isLeader) {
        if (!eraseMode) sheet.paint.drawEnd();
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
      }
      else {
        if (sheet.privatePaint.eraseMode) {
          sheet.privatePaint.erase(offset);
          return;
        }
        sheet.privatePaint.drawing(offset);
      }
    }

    Offset translateOffset(double dx, double dy) {
      double _tdx = dx, _tdy = dy;
      _tdx -= correction.dx;
      _tdy -= correction.dy;
      _tdx /= imageSize.width;
      _tdy /= imageSize.height;

      return Offset(_tdx, _tdy);
    }

    return Column(
      children: [
        GestureDetector(
          onPanDown: (details) => parent!.setState(() => tapStart(
            translateOffset(details.localPosition.dx, details.localPosition.dy),
          )),
          onPanUpdate: (details) => parent!.setState(() => tapUpdate(
            translateOffset(details.localPosition.dx, details.localPosition.dy),
          )),
          onPanEnd: (details) => parent!.setState(() => tapEnd()),
          child: AnimatedContainer(
            margin: EdgeInsets.fromLTRB(0, 0, 0, marginHeight),
            duration: const Duration(milliseconds: 250),
            width: sheetSize.width,
            height: sheetSize.height,
            key: sheet.globalKey,
            decoration: BoxDecoration(
              color: sheet.isSelected ?
              palette.themeColor1.withOpacity(.3) :
              Colors.grey.withOpacity(.3),
              border: Border.all(
                width: 3.0 * scale,
                color: sheet.isSelected ?
                palette.themeColor1 : Colors.transparent,
              ),
            ),
            child: Stack(
              children: [
                if (widget.isLeader && sheet.image != null)
                Positioned(child: imageFile(sheet.image!),),
                if (!widget.isLeader && sheet.imageUrl != null)
                Positioned(child: imageNetwork(sheet.imageUrl!),),
                Positioned(
                  child: Center(
                    child: SizedBox(
                      width: imageSize.width,
                      height: imageSize.height,
                      child: ClipRRect(
                        child: Stack(
                          children: [
                            Positioned(
                              child: CustomPaint(
                                painter: MyPainter(sheet.paint.allLines,),
                              ),
                            ),
                            if (!widget.isLeader)
                            Positioned(
                              child: CustomPaint(
                                painter: MyPainter(sheet.privatePaint.allLines,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  top: sheet.isSelected ? 0 : -50 * scale,
                  duration: const Duration(milliseconds: 250),
                  child: GestureDetector(
                    onTap: () {
                      titleCont.text = sheet.title;
                      titlePopUp(() {
                        Get.back();
                        setState(() => sheet.title = titleCont.text);
                        sheetCont.updateDB();
                        titleCont.text = '';
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: sheetSize.width,
                      height: titleHeight,
                      padding: EdgeInsets.symmetric(horizontal: 15.0 * scale),
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        child: Text(
                          sheet.title,
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0 * scale,
                          color: sheet.isSelected ? palette.themeColor2 : Colors.black45,
                          fontFamily: 'MontserratBold',
                          fontFamilyFallback: const ['OneMobileTitle',],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: sheet.isSelected ?
                          palette.themeColor1 :
                          Colors.grey,
                        ),
                        onPressed: () {
                          parent!.setState(() {
                            toggleSelection(sheet.num);
                            widget.isLeader ? sheet.paint.setEraseMode(eraseMode) :
                            sheet.privatePaint.setEraseMode(eraseMode);
                          });
                        }
                      ),
                      if (widget.isLeader)
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: sheet.isSelected ?
                          palette.themeColor1 :
                          Colors.grey,
                        ),
                        onPressed: () {
                          popUp('주의', "정말 '${sheet.title}' 악보를\n삭제하시겠습니까?", () {
                            Get.back();
                            parent!.setState(() => delImage(sheet.num));
                          });
                        }
                      ),
                    ],
                  ),
                ),
                if ((sheet.image == null && widget.isLeader)
                    || (sheet.imageUrl == null && !widget.isLeader))
                Positioned(
                  child: Builder(
                    builder: (context) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: palette.themeColor1,
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}