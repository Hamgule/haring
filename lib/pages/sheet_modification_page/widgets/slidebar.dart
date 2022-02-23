import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:haring/pages/_global/globals.dart';
import 'package:haring/pages/sheet_modification_page/sheet_modification_page.dart';

bool eraseMode = false;
bool tempMode = false;

class SlideBar extends StatefulWidget {
  final Axis axis;
  final void Function(int) cb;
  final bool isLeader;

  const SlideBar({
    Key? key,
    this.axis = Axis.horizontal,
    required this.cb,
    required this.isLeader,
  }) : super(key: key);

  @override
  _SlideBarState createState() => _SlideBarState();
}

class _SlideBarState extends State<SlideBar>
    with SingleTickerProviderStateMixin {

  AnimationController? _act;
  Animation<double>? _anim;

  bool check = false;

  @override
  void initState() {
    _act = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )
      ..addListener(() {
        if (!mounted) return;
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _act?.dispose();
    super.dispose();
  }

  void getEraseMode() {
    if (sheetCont.selectedNum < 0) return;
    if (Get.currentRoute == '/LeaderPage') {
      sheetCont.getDataWhere(
        sheetCont.selectedNum,
      ).paint.eraseMode;
    }
    else {
      sheetCont.getDataWhere(
        sheetCont.selectedNum,
      ).privatePaint.eraseMode;
    }
  }

  void selectColor() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Color Chooser'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: painterCont.color,
                onColorChanged: (color) => setState(() => painterCont.setColor(color)),
                pickerAreaHeightPercent: 0.8 * scale,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text("Close"),
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    SheetModificationPageState? parent = context
        .findAncestorStateOfType<SheetModificationPageState>();

    double iconSize = 35.0 * scale;

    Widget timerButton = IconButton(
      onPressed: () => setState(() {
        if (sheetCont.selectedNum < 0) return;
        sheetCont.getDataWhere(
          sheetCont.selectedNum,
        ).paint.setEraseMode(false);
        eraseMode = false;
        tempMode = !tempMode;
      }),
      icon: Icon(
        Icons.timer,
        color: tempMode ? palette.themeColor1 : Colors.white,
        size: iconSize,
      ),
    );

    Widget undoButton = IconButton(
      onPressed: () {
        parent!.setState(() {
          if (sheetCont.selectedNum < 0) return;
          if (Get.currentRoute == '/LeaderPage') {
            sheetCont.getDataWhere(
              sheetCont.selectedNum,
            ).paint.undo();
            sheetCont.updateDB();
          }
          else {
            sheetCont.getDataWhere(
              sheetCont.selectedNum,
            ).privatePaint.undo();
          }
        });
      },
      icon: Icon(
        Icons.undo,
        color: Colors.white,
        size: iconSize,
      ),
    );

    Widget redoButton = IconButton(
      onPressed: () {
        parent!.setState(() {
          if (sheetCont.selectedNum < 0) return;
          if (Get.currentRoute == '/LeaderPage') {
            sheetCont.getDataWhere(
              sheetCont.selectedNum,
            ).paint.redo();
            sheetCont.updateDB();
          }
          else {
            sheetCont.getDataWhere(
              sheetCont.selectedNum,
            ).privatePaint.redo();
          }
        });
      },
      icon: Icon(
        Icons.redo,
        color: Colors.white,
        size: iconSize,
      ),
    );

    Widget penButton = InkWell(
      onTap: () {
        parent!.setState(() {
          if (sheetCont.selectedNum < 0) return;
          if (Get.currentRoute == '/LeaderPage') {
            sheetCont.getDataWhere(
              sheetCont.selectedNum,
            ).paint.setEraseMode(false);
          }
          else {
            sheetCont.getDataWhere(
              sheetCont.selectedNum,
            ).privatePaint.setEraseMode(false);
          }
          eraseMode = false;
        });
      },
      customBorder: const CircleBorder(),
      onDoubleTap: () => selectColor(),
      child: Container(
        margin: EdgeInsets.all(5.0 * scale),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              child: Container(
                width: 66.0 * scale,
                height: 66.0 * scale,
                decoration: BoxDecoration(
                  color: eraseMode ? Colors.white : palette.themeColor1,
                  borderRadius: BorderRadius.circular(50.0 * scale),
                ),
              ),
            ),
            Positioned(
              child: Container(
                width: painterCont.size,
                height: painterCont.size,
                decoration: BoxDecoration(
                  color: painterCont.color,
                  borderRadius: BorderRadius.circular(50.0 * scale),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Widget penWidthSlider = Container(
      width: !isPad && verticalMode ? 100.0 : 180.0,
      child: SliderTheme(
        data: SliderThemeData(
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 14.0 * scale),
          trackHeight: 4 * scale,
        ),
        child: Slider(
          min: 2.0 * scale,
          max: 60.0 * scale,
          value: painterCont.size,
          inactiveColor: Colors.white,
          activeColor: palette.themeColor1,
          onChanged: (value) {
            parent!.setState(() {
              painterCont.setSize(value);
            });
          }
        ),
      ),
    );

    Widget eraserButton = InkWell(
      onTap: () {
        parent!.setState(() {
          if (sheetCont.selectedNum < 0) return;
          if (Get.currentRoute == '/LeaderPage') {
            tempMode = false;
            eraseMode = !eraseMode;
            sheetCont.getDataWhere(
              sheetCont.selectedNum,
            ).paint.setEraseMode(eraseMode);
            sheetCont.updateDB();
          }
          else {
            eraseMode = !eraseMode;
            sheetCont.getDataWhere(
              sheetCont.selectedNum,
            ).privatePaint.setEraseMode(eraseMode);
          }
        });
      },
      onLongPress: () {
        parent!.setState(() {
          if (sheetCont.selectedNum < 0) return;
          if (Get.currentRoute == '/LeaderPage') {
            sheetCont.getDataWhere(
              sheetCont.selectedNum,
            ).paint.eraseAll();
            tempMode = false;
            sheetCont.updateDB();
          }
          else {
            sheetCont.getDataWhere(
              sheetCont.selectedNum,
            ).privatePaint.eraseAll();
          }
        });
      },
      customBorder: const CircleBorder(),
      child: Container(
        margin: EdgeInsets.all(18.0 * scale),
        width: iconSize,
        height: iconSize,
        child: SvgPicture.asset(
          'assets/icons/eraser.svg',
          color: eraseMode ?
          palette.themeColor1 :
          Colors.white,
        ),
      ),
    );

    List<Widget> menus = !isPad && verticalMode ? [
      if (widget.isLeader) timerButton, undoButton, redoButton,] : [
      if (widget.isLeader) timerButton, undoButton, redoButton,
      penButton, penWidthSlider, eraserButton,
    ];

    List<Widget> menusBelow = [
      penButton, penWidthSlider, eraserButton,
    ];

    double beginPosition() =>
      isPad ? verticalMode ? 0.80 : 0.85 : verticalMode ? 0.75 : 0.85;

    _anim = Tween<double>(
      begin: MediaQuery.of(context).size.width * beginPosition(),
      end: 0,
    ).animate(_act!);

    // List<Widget> _bar() => menus.map<Widget>(
    //       (Widget item) => InkWell(
    //     onTap: () => widget.cb(menus.indexOf(item)),
    //     child: item,
    //   ),
    // ).toList();

    return Transform.translate(
      offset: Offset(_anim?.value ?? 0, 0),
      child: Card(
        margin: EdgeInsets.symmetric(
          vertical: 20.0 * scale,
          horizontal: 60.0 * scale,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0 * scale),
        ),
        color: Colors.black.withOpacity(.1),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 30.0 * scale),
          height: !isPad && verticalMode ? 200.0 * scale : 100.0 * scale,
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  check ? Icons.close : Icons.brush,
                  color: Colors.white,
                  size: iconSize,
                ),
                onPressed: () {
                  check ? _act?.reverse() : _act?.forward();
                  check = !check;
                },
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: menus,
                      ),
                      if (!isPad && verticalMode)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: menusBelow,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}