import 'dart:convert';

import 'package:flutter/services.dart';

class MockDataService {
  const MockDataService();

  Future<Map<String, dynamic>> loadMockData() async {
    final rawJson = await rootBundle.loadString('assets/data/mock_data.json');
    return jsonDecode(rawJson) as Map<String, dynamic>;
  }
}
