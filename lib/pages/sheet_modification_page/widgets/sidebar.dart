import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haring4/config/palette.dart';
import 'package:haring4/models/sheet.dart';
import 'package:haring4/pages/_global/globals.dart';
import 'package:haring4/pages/sheet_modification_page/sheet_modification_page.dart';
import 'package:reorderables/reorderables.dart';

// Global Variables

const double _fontSize = 30.0;
const double _sheetWidth = 100.0;
const double _sheetHeight = 130.0;

void _toggleSelection(int num) {
  sheetCont.toggleSelection(num);
}

class Sidebar extends StatefulWidget {
  const Sidebar({Key? key, required this.isLeader}) : super(key: key);

  final bool isLeader;

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  List<Widget> _tiles = [];
  List<int> orderList = [];
  double marginHorizontal = 10.0;

  void dataReorder(List<int> orderList) {
    List<Sheet> _orderData = [];

    for (int order in orderList) {
      _orderData.add(sheetCont.sheets.where((d) => (d.num == order)).first);
    }

    sheetCont.sheets(_orderData);
  }

  @override
  Widget build(BuildContext context) {
    SheetModificationPageState? parent = context
        .findAncestorStateOfType<SheetModificationPageState>();

    _tiles = [
      for (Sheet sheet in sheetCont.sheets)
      GestureDetector(
        key: ValueKey('${sheet.num}'),
        onTap: () {
          focusSheet(sheet.num);
          Get.back();
        },
        onDoubleTap: () {
          parent!.setState(() {
            _toggleSelection(sheet.num);
          });
        },
        child: AnimatedContainer(
          width: _sheetWidth,
          height: _sheetHeight,
          decoration: BoxDecoration(
            color: sheet.isSelected ?
            Palette.themeColor1.withOpacity(.5) :
            Colors.grey.withOpacity(.5),
          ),
          duration: const Duration(milliseconds: 300),
          child: Center(
            child: Text(
              '${sheet.num}',
              style: TextStyle(
                fontSize: _fontSize,
                color: Colors.black.withOpacity(.5),
              ),
            ),
          ),
        ),
      ),
    ];

    void _onReorder(int oldIndex, int newIndex) {
      Widget row = _tiles.removeAt(oldIndex);
      _tiles.insert(newIndex, row);
      orderList = [];

      for (Widget tile in _tiles) {
        orderList.add(int.parse((tile.key as ValueKey).value));
      }

      parent!.setState(() {
        dataReorder(orderList);
      });
    }

    final leaderWrap = ReorderableWrap(
      spacing: 8.0,
      runSpacing: 4.0,
      padding: const EdgeInsets.all(8),
      children: _tiles,
      onReorder: _onReorder,
      alignment: WrapAlignment.center,
    );

    final userWrap = Wrap(
      children: sidebarMusicSheets(),
    );

    return Drawer(
      child: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 40.0),
        child: SingleChildScrollView(
          child: widget.isLeader ? leaderWrap : userWrap,
        ),
      ),
    );
  }

}

List<Widget> sidebarMusicSheets() {
  final List<Widget> _list = [];

  for (int i = 0; i < (sheetCont.sheets.length - 1) / 2; i++) {
    _list.add(
      ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SidebarMusicSheetWidget(sheet: sheetCont.sheets[2 * i]),
            const SizedBox(width: 10.0),
            SidebarMusicSheetWidget(sheet: sheetCont.sheets[2 * i + 1]),
          ],
        ),
      ),
    );
  }
  if (sheetCont.sheets.length % 2 == 1) {
    _list.add(
      ListTile(
        title: SidebarMusicSheetWidget(
          sheet: sheetCont.sheets.last,
        ),
      ),
    );
  }

  return _list;
}

class SidebarMusicSheetWidget extends StatefulWidget {
  const SidebarMusicSheetWidget({Key? key, required this.sheet}) : super(key: key);
  final Sheet sheet;

  @override
  _SidebarMusicSheetWidgetState createState() => _SidebarMusicSheetWidgetState();
}

class _SidebarMusicSheetWidgetState extends State<SidebarMusicSheetWidget> {

  @override
  Widget build(BuildContext context) {
    _SidebarState? parent = context.findAncestorStateOfType<_SidebarState>();
    final Sheet sheet = widget.sheet;

    return GestureDetector(
      onTap: () {
        focusSheet(sheet.num);
        Get.back();
      },
      onDoubleTap: () {
        parent!.setState(() {
          sheetCont.toggleSelection(sheet.num);
        });
      },
      child: Center(
        child: AnimatedContainer(
          width: _sheetWidth,
          height: _sheetHeight,
          decoration: BoxDecoration(
            color: sheet.isSelected ?
              Palette.themeColor1.withOpacity(.5) :
              Colors.grey.withOpacity(.5),
          ),
          duration: const Duration(milliseconds: 300),
          child: Center(
            child: Text(
              '${sheet.num}',
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.black.withOpacity(.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
