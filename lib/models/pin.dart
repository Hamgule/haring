import 'dart:math';

import 'package:firebase_database/firebase_database.dart';

class Pin {
  static const int max = 999999;
  static const int min = 000000;

  String pin = '000000';
  DateTime genTime = DateTime.now();

  Map<String, Object?> toJson() => {
    pin: {
      'genTime': genTime.toString(),
    }
  };

  void savePinDB() async {
    final f = FirebaseDatabase.instance.ref('pins');
    DatabaseEvent event = await f.child(pin).once();

    if (!event.snapshot.exists) {
      f.update(toJson());
    }
  }

  void generatePin() async {
    do {
      pin = (
          min + Random().nextInt(max - min)
      ).toString().padLeft(6, '0');
    } while (await isIn(pin));


  }

  void removePin() async {
    final f = FirebaseDatabase.instance.ref('pins');
    DatabaseEvent event = await f.child(pin).once();

    if (event.snapshot.exists) {
      f.child(pin).remove();
    }
  }

  Future<bool> isIn(String pin) async {
    final f = FirebaseDatabase.instance.ref('pins');
    DatabaseEvent event = await f.child(pin).once();
    return event.snapshot.exists;
  }
}