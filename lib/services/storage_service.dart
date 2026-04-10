import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  const StorageService();

  static const String _storageKey = 'medibook_appointment_draft';

  Future<Map<String, dynamic>?> loadDraft() async {
    final preferences = await SharedPreferences.getInstance();
    final rawDraft = preferences.getString(_storageKey);
    if (rawDraft == null || rawDraft.isEmpty) {
      return null;
    }

    return jsonDecode(rawDraft) as Map<String, dynamic>;
  }

  Future<void> saveDraft(Map<String, dynamic> data) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_storageKey, jsonEncode(data));
  }

  Future<void> clearDraft() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_storageKey);
  }
}
