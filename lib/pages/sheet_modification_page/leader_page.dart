import 'package:flutter/material.dart';
import 'package:haring/pages/sheet_modification_page/sheet_modification_page.dart';

class LeaderPage extends StatefulWidget {
  const LeaderPage({Key? key}) : super(key: key);

  @override
  State<LeaderPage> createState() => LeaderPageState();
}

class LeaderPageState extends State<LeaderPage> {
  final bool isLeader = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SheetModificationPage(isLeader: isLeader,);
  }
}