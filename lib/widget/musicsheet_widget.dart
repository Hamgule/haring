import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haring4/config/palette.dart';
import 'package:haring4/controller/data_controller.dart';
import 'package:haring4/painter/painter.dart';
import 'package:haring4/page/sheet_modification_page.dart';


// Global Variables

final ScrollController contScroll = ScrollController();
final List<GlobalKey> globalKeys = [];

double screenHeight = 1.0;
int currentScrollNum = 0;

// Global Methods

void _toggleSelection(int num) {
  contData.toggleSelection(num);
}

void _delImage(int num) {
  contData.delDatum(num);
}

void focusSheet(int num) {
  Scrollable.ensureVisible(
    globalKeys[num].currentContext!,
    duration: const Duration(milliseconds: 600),
    curve: Curves.easeInOut,
  );
}

// Widget List

List<Widget> musicSheets(bool isLeader) {
  final List<Widget> _list = [];

  for (int i = 0; i < (contData.getData().length - 1) / 2; i++) {
    _list.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MusicSheetWidget(
            isLeader: isLeader,
            datum: contData.getData()[2 * i],
            index: 2 * i,
          ),
          const SizedBox(width: 10.0),
          MusicSheetWidget(
            isLeader: isLeader,
            datum: contData.getData()[2 * i + 1],
            index: 2 * i + 1,
          ),
        ],
      ),
    );
  }
  if (contData.getData().length % 2 == 1) {
    _list.add(
      MusicSheetWidget(
        isLeader: isLeader,
        datum: contData.getData().last,
        index: contData.getData().length - 1,
      ),
    );
  }

  return _list;
}

// Widget

class SheetScrollView extends StatefulWidget {
  const SheetScrollView({Key? key, required this.isLeader}) : super(key: key);

  final bool isLeader;

  @override
  SheetScrollViewState createState() => SheetScrollViewState();
}

class SheetScrollViewState extends State<SheetScrollView> {

  @override
  void initState() {
    contScroll.addListener(() {
      scrollListener();
    });
    super.initState();
  }

  void scrollListener() async {
    currentScrollNum = (contScroll.offset / screenHeight).round();
    // print(currentScrollNum);
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      physics: contData.selectedNum < 0 ? null : const NeverScrollableScrollPhysics(),
      controller: contScroll,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: musicSheets(widget.isLeader),
        ),
      ),
    );
  }

}

class MusicSheetWidget extends StatefulWidget {
  const MusicSheetWidget({
    Key? key,
    required this.isLeader,
    required this.datum,
    required this.index,
  }) : super(key: key);

  final bool isLeader;
  final Datum datum;
  final int index;

  @override
  _MusicSheetWidgetState createState() => _MusicSheetWidgetState();
}

class _MusicSheetWidgetState extends State<MusicSheetWidget> {

  late List<DrawingArea> points;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => focusSheet(contData.lastNum.value));
     points = widget.datum.points;
  }


  @override
  Widget build(BuildContext context) {
    SheetScrollViewState? parent = context.findAncestorStateOfType<SheetScrollViewState>();

    Size size = MediaQuery.of(context).size;
    screenHeight = size.height - AppBar().preferredSize.height;
    double sheetWidth = size.width * 0.4;
    double sheetHeight = screenHeight * 0.9;
    double marginHeight = screenHeight * 0.05;

    return Container(
      margin: EdgeInsets.symmetric(vertical: marginHeight,),
      child: GestureDetector(
        onTap: () {
          setState(() {
            Offset noPoint = const Offset(-100.0, -100.0);
            if (widget.datum.isSelected) {
              points.add(DrawingArea(
                point: noPoint,
                areaPaint: Paint()
                  ..strokeCap = StrokeCap.round
                  ..isAntiAlias = true
                  ..color = Colors.black
                  ..strokeWidth = 2.0
                ),
              );
              widget.datum.points = points;
            }
          });
        },
        onDoubleTap: () {
          parent!.setState(() {
            _toggleSelection(widget.datum.num);
            widget.datum.points = points;
          });
        },
        onPanDown: (details) {
          parent!.setState(() {
            if (widget.datum.isSelected) {
              points.add(DrawingArea(
                point: details.localPosition,
                areaPaint: Paint()
                  ..strokeCap = StrokeCap.round
                  ..isAntiAlias = true
                  ..color = Colors.black
                  ..strokeWidth = 2.0
                )
              );
            }
          });
        },
        onPanUpdate: (details) {
          parent!.setState(() {
            if (widget.datum.isSelected) {
              points.add(DrawingArea(
                point: details.localPosition,
                areaPaint: Paint()
                  ..strokeCap = StrokeCap.round
                  ..isAntiAlias = true
                  ..color = Colors.black
                  ..strokeWidth = 2.0
                )
              );
            }
          });
        },
        onPanEnd: (details) {
          parent!.setState(() {
            Offset noPoint = const Offset(-100.0, -100.0);
            points.add(DrawingArea(
              point: noPoint,
              areaPaint: Paint()
                ..strokeCap = StrokeCap.round
                ..isAntiAlias = true
                ..color = Colors.black
                ..strokeWidth = 2.0
              ),
            );
          });
        },
        child: AnimatedContainer(
          width: sheetWidth,
          height: sheetHeight,
          key: globalKeys[widget.datum.num],
          decoration: BoxDecoration(
            color: widget.datum.isSelected ?
            Palette.themeColor1.withOpacity(.5) :
            Colors.grey.withOpacity(.5),
            border: Border.all(
              width: 3.0,
              color: widget.datum.isSelected ?
              Palette.themeColor1 : Colors.transparent,
            ),
          ),
          duration: const Duration(milliseconds: 300),
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  width: sheetWidth,
                  height: sheetHeight,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    child: CustomPaint(
                      painter: MyCustomPainter(
                        points: points,
                        color: Colors.black,
                        strokeWidth: 2.0,
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
                  onPressed: () {
                    parent!.setState(() {
                      _delImage(widget.datum.num);
                    });
                  },
                ),
              ),
              Positioned(
                child: Center(
                  child: Text(
                    '${widget.datum.num}',
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
    );
  }
}