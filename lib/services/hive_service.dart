// ignore_for_file: constant_identifier_names

import 'package:hive_flutter/hive_flutter.dart';
import 'package:persistent_data/models/record.dart';

class HiveService {
  static const CATEGORIES_KEY = 'CATEGORIES';

  static initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(RecordAdapter());
  }

  static Future<Box<String>> getCategoriesBox() async =>
      await Hive.openBox(CATEGORIES_KEY);

  static Future<Box<Record>> getEntriesBox(String category) async =>
      await Hive.openBox(category);
}
