import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class TaskStorage {
  static String _todayKey(DateTime date) => 
      'tasks_${date.year.toString().padLeft(4, '0')}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
  static String _historyKey(DateTime date) =>
      'history_${date.year.toString().padLeft(4, '0')}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
  static const String _lastResetDateKey = 'last_reset_date';

  // Check if we need to reset for a new day
  static Future<bool> _isNewDay() async {
    final prefs = await SharedPreferences.getInstance();
    final lastResetDateString = prefs.getString(_lastResetDateKey);
    
    if (lastResetDateString == null) {
      // First time using the app
      await prefs.setString(_lastResetDateKey, DateTime.now().toIso8601String());
      return true;
    }
    
    final lastResetDate = DateTime.parse(lastResetDateString);
    final now = DateTime.now();
    
    // Check if it's a new day (after midnight)
    final isNewDay = now.year != lastResetDate.year || 
                     now.month != lastResetDate.month || 
                     now.day != lastResetDate.day;
    
    if (isNewDay) {
      // Update the last reset date
      await prefs.setString(_lastResetDateKey, now.toIso8601String());
    }
    
    return isNewDay;
  }

  // Reset tasks for a new day
  static Future<void> _resetForNewDay(List<Map<String, dynamic>> defaultTasks) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    
    // Clear any existing tasks for today
    await prefs.remove(_todayKey(today));
    
    // Initialize with fresh tasks
    final freshTasks = defaultTasks.map((task) {
      return {
        ...task,
        'currentCount': 0,
        'isCompleted': false,
        'dateCreated': today.toIso8601String(),
      };
    }).toList();
    
    await saveTodayTasks(freshTasks);
  }

  static Future<void> saveTodayTasks(List<Map<String, dynamic>> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_todayKey(DateTime.now()), jsonEncode(tasks));
  }

  static Future<List<Map<String, dynamic>>> loadTodayTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final data = prefs.getString(_todayKey(today));
    
    if (data == null) return [];
    
    try {
      final List<dynamic> list = jsonDecode(data) as List<dynamic>;
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  // Load tasks with daily reset check
  static Future<List<Map<String, dynamic>>> loadTodayTasksWithReset(List<Map<String, dynamic>> defaultTasks) async {
    final isNewDay = await _isNewDay();
    
    if (isNewDay) {
      // Reset for new day
      await _resetForNewDay(defaultTasks);
    }
    
    return loadTodayTasks();
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

  // Force reset for testing or manual reset
  static Future<void> forceResetForToday(List<Map<String, dynamic>> defaultTasks) async {
    await _resetForNewDay(defaultTasks);
  }

  // Clean up old history data (keep last 90 days)
  static Future<void> cleanupOldHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final now = DateTime.now();
    final cutoffDate = now.subtract(Duration(days: 90));
    
    for (final key in keys) {
      if (key.startsWith('history_') && key.length == 'history_'.length + 8) {
        final y = int.tryParse(key.substring(8, 12));
        final m = int.tryParse(key.substring(12, 14));
        final d = int.tryParse(key.substring(14, 16));
        
        if (y != null && m != null && d != null) {
          final date = DateTime(y, m, d);
          if (date.isBefore(cutoffDate)) {
            await prefs.remove(key);
          }
        }
      }
    }
  }
}


