import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static openBox(String boxName) async {
    Box box = await Hive.openBox(boxName);
    return box;
  }

  static closeBox(String boxName) {
    Hive.box(boxName).close();
  }
}
