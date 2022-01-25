import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:haring4/config/palette.dart';
import 'package:haring4/page/sheet_modification_page.dart';
import 'package:haring4/painter/painter.dart';

class SlideBar extends StatefulWidget {
  final Axis axis;
  final void Function(int) cb;

  const SlideBar({
    Key? key,
    this.axis = Axis.horizontal,
    required this.cb,
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
        duration: const Duration(milliseconds: 300),
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

  void selectColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Color Chooser'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: chosen.selectedColor,
              onColorChanged: (color) {
                setState(() {
                  chosen.selectedColor = color;
                });
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
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

    double iconSize = 35.0;

    List<Widget> menus = [
      IconButton(
        onPressed: () {
          parent!.setState(() {
            if (contData.selectedNum < 0) return;
            contData.getDataWhere(
                contData.selectedNum.value,
            ).undo();
          });
        },
        icon: Icon(
          Icons.undo,
          color: Colors.white,
          size: iconSize,
        ),
      ),
      IconButton(
        onPressed: () {
          parent!.setState(() {
            if (contData.selectedNum < 0) return;
            contData.getDataWhere(
                contData.selectedNum.value,
            ).redo();
          });
        },
        icon: Icon(
          Icons.redo,
          color: Colors.white,
          size: iconSize,
        ),
      ),
      GestureDetector(
        onTap: () {
          selectColor();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              child: Container(
                width: 66.0,
                height: 66.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
            Positioned(
              child: Container(
                width: chosen.strokeWidth,
                height: chosen.strokeWidth,
                decoration: BoxDecoration(
                  color: chosen.selectedColor,
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
          ],
        ),
      ),
      Slider(
        min: 2.0,
        max: 60.0,
        value: chosen.strokeWidth,
        inactiveColor: Colors.white,
        activeColor: Palette.themeColor1,
        onChanged: (value) {
          parent!.setState(() {
            chosen.strokeWidth = value;
          });
        }
      ),
      IconButton(
        onPressed: () {
          parent!.setState(() {
            if (contData.selectedNum.value < 0) return;
            contData.getDataWhere(
              contData.selectedNum.value,
            ).points.clear();
          });
        },
        icon: Container(
          width: iconSize,
          height: iconSize,
          child: SvgPicture.asset(
            'assets/icons/eraser.svg',
            color: Colors.white,
          ),
        ),
      ),
    ];

    _anim = Tween<double>(
      begin: MediaQuery.of(context).size.width * 0.885,
      end: 0,
    ).animate(_act!);

    List<Widget> _bar() => menus.map<Widget>(
      (Widget item) => InkWell(
        onTap: () => widget.cb(menus.indexOf(item)),
        child: item,
      ),
    ).toList();

    return Transform.translate(
      offset: Offset(_anim?.value ?? 0, 0),
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 60.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.black.withOpacity(.3),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          height: 100.0,
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  check ? Icons.close : Icons.brush,
                  color: Palette.white,
                  size: iconSize,
                ),
                onPressed: () {
                  if (!check) { _act?.forward(); }
                  else { _act?.reverse(); }
                  check = !check;
                },
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [..._bar()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}