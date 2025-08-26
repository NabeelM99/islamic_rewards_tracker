import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class TaskStorage {
  static String _todayKey(DateTime date) => 'tasks_today';
  static String _historyKey(DateTime date) =>
      'history_${date.year.toString().padLeft(4, '0')}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';

  static Future<void> saveTodayTasks(List<Map<String, dynamic>> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_todayKey(DateTime.now()), jsonEncode(tasks));
  }

  static Future<List<Map<String, dynamic>>> loadTodayTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_todayKey(DateTime.now()));
    if (data == null) return [];
    try {
      final List<dynamic> list = jsonDecode(data) as List<dynamic>;
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveHistorySnapshot(
      DateTime date, List<Map<String, dynamic>> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_historyKey(date), jsonEncode(tasks));
  }

  static Future<List<DateTime>> loadHistoryDates() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final dates = <DateTime>[];
    for (final key in keys) {
      if (key.startsWith('history_') && key.length == 'history_'.length + 8) {
        final y = int.tryParse(key.substring(8, 12));
        final m = int.tryParse(key.substring(12, 14));
        final d = int.tryParse(key.substring(14, 16));
        if (y != null && m != null && d != null) {
          dates.add(DateTime(y, m, d));
        }
      }
    }
    dates.sort((a, b) => b.compareTo(a));
    return dates;
  }

  static Future<List<Map<String, dynamic>>> loadDayTasks(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_historyKey(date));
    if (data == null) return [];
    try {
      final List<dynamic> list = jsonDecode(data) as List<dynamic>;
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  static Map<String, int> summarizeTasks(List<Map<String, dynamic>> tasks) {
    final total = tasks.length;
    final completed = tasks.where((t) => (t['isCompleted'] ?? false) == true).length;
    return {'total': total, 'completed': completed};
  }
}


