import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/app_data.dart';

class DataService {
  const DataService();

  static const String _assetPath = 'assets/data/placeholder_data.json';

  Future<AppData> loadAppData() async {
    final rawJson = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
    return AppData.fromJson(decoded);
  }
}
