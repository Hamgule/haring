import 'package:flutter/material.dart';
import 'package:haring/pages/sheet_modification_page/sheet_modification_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  final bool isLeader = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SheetModificationPage(isLeader: isLeader,);
  }
}