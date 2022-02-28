import 'dart:math';

import 'package:firebase_database/firebase_database.dart';

class Pin {
  static const double lucky = 10000;
  static const int max = 999999;
  static const int min = 000000;
  static const String luckyPin = '777777';

  String pin = '000000';

  Map<String, Object?> toJson() => {
    pin: {'genTime': DateTime.now().toString(),}
  };

  Future savePinDB() async {
    final f = FirebaseDatabase.instance.ref('pins');
    DatabaseEvent event = await f.child(pin).once();

    if (!event.snapshot.exists) {
      f.update(toJson());
    }
  }

  Future generatePin() async {
    do {
      int _range = max - min;
      int _randPin = min + Random().nextInt((_range + lucky).round());
      pin = (
        _randPin > _range ? luckyPin : _randPin
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