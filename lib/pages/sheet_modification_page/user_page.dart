import 'package:flutter/material.dart';
import 'package:haring4/pages/sheet_modification_page/sheet_modification_page.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  final bool isLeader = false;

  @override
  Widget build(BuildContext context) {

    return SheetModificationPage(isLeader: isLeader);
  }
}