import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/database/app_database.dart';
import 'features/settings/domain/app_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  final preferences = AppPreferences(await SharedPreferences.getInstance());
  runApp(ZenSatoriApp(database: database, preferences: preferences));
}
