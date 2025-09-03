import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dhikr_model.dart';

class DhikrStorageService {
  static const String _dhikrKey = 'dhikr_list';
  static const String _sessionsKey = 'tasbih_sessions';
  static const String _dailyTargetsKey = 'daily_targets';

  // Get all dhikr
  Future<List<DhikrModel>> getAllDhikr() async {
    final prefs = await SharedPreferences.getInstance();
    final dhikrList = prefs.getStringList(_dhikrKey) ?? [];
    
    if (dhikrList.isEmpty) {
      // Initialize with default dhikr
      return _getDefaultDhikr();
    }
    
    return dhikrList
        .map((json) => DhikrModel.fromJson(jsonDecode(json)))
        .toList();
  }

  // Save dhikr
  Future<void> saveDhikr(DhikrModel dhikr) async {
    final prefs = await SharedPreferences.getInstance();
    final dhikrList = await getAllDhikr();
    
    final existingIndex = dhikrList.indexWhere((d) => d.id == dhikr.id);
    if (existingIndex >= 0) {
      dhikrList[existingIndex] = dhikr;
    } else {
      dhikrList.add(dhikr);
    }
    
    final jsonList = dhikrList
        .map((d) => jsonEncode(d.toJson()))
        .toList();
    
    await prefs.setStringList(_dhikrKey, jsonList);
  }

  // Delete dhikr
  Future<void> deleteDhikr(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final dhikrList = await getAllDhikr();
    
    dhikrList.removeWhere((d) => d.id == id);
    
    final jsonList = dhikrList
        .map((d) => jsonEncode(d.toJson()))
        .toList();
    
    await prefs.setStringList(_dhikrKey, jsonList);
  }

  // Update dhikr count
  Future<void> updateDhikrCount(String id, int newCount) async {
    final dhikrList = await getAllDhikr();
    final dhikrIndex = dhikrList.indexWhere((d) => d.id == id);
    
    if (dhikrIndex >= 0) {
      final updatedDhikr = dhikrList[dhikrIndex].copyWith(
        currentCount: newCount,
        lastUpdated: DateTime.now(),
      );
      dhikrList[dhikrIndex] = updatedDhikr;
      await _saveAllDhikr(dhikrList);
    }
  }

  // Update dhikr target count
  Future<void> updateDhikrTarget(String id, int newTarget) async {
    final dhikrList = await getAllDhikr();
    final dhikrIndex = dhikrList.indexWhere((d) => d.id == id);
    
    if (dhikrIndex >= 0) {
      final updatedDhikr = dhikrList[dhikrIndex].copyWith(
        targetCount: newTarget,
        lastUpdated: DateTime.now(),
      );
      dhikrList[dhikrIndex] = updatedDhikr;
      await _saveAllDhikr(dhikrList);
    }
  }

  // Reset daily counts
  Future<void> resetDailyCounts() async {
    final dhikrList = await getAllDhikr();
    final updatedList = dhikrList.map((d) => d.copyWith(currentCount: 0)).toList();
    await _saveAllDhikr(updatedList);
  }

  // Save tasbih session
  Future<void> saveTasbihSession(TasbihSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsList = prefs.getStringList(_sessionsKey) ?? [];
    
    sessionsList.add(jsonEncode(session.toJson()));
    
    // Keep only last 100 sessions to avoid memory issues
    if (sessionsList.length > 100) {
      sessionsList.removeRange(0, sessionsList.length - 100);
    }
    
    await prefs.setStringList(_sessionsKey, sessionsList);
  }

  // Get tasbih sessions
  Future<List<TasbihSession>> getTasbihSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsList = prefs.getStringList(_sessionsKey) ?? [];
    
    return sessionsList
        .map((json) => TasbihSession.fromJson(jsonDecode(json)))
        .toList();
  }

  // Get daily targets
  Future<Map<String, int>> getDailyTargets() async {
    final prefs = await SharedPreferences.getInstance();
    final targetsJson = prefs.getString(_dailyTargetsKey);
    
    if (targetsJson != null) {
      final Map<String, dynamic> targets = jsonDecode(targetsJson) as Map<String, dynamic>;
      return targets.map((key, value) => MapEntry(key, value as int));
    }
    
    return {};
  }

  // Save daily targets
  Future<void> saveDailyTargets(Map<String, int> targets) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dailyTargetsKey, jsonEncode(targets));
  }

  // Helper method to save all dhikr
  Future<void> _saveAllDhikr(List<DhikrModel> dhikrList) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = dhikrList
        .map((d) => jsonEncode(d.toJson()))
        .toList();
    
    await prefs.setStringList(_dhikrKey, jsonList);
  }

  // Get default dhikr list
  List<DhikrModel> _getDefaultDhikr() {
    return [
      DhikrModel(
        id: '1',
        title: 'Subhanallah',
        arabicText: 'سُبْحَانَ اللَّهِ',
        transliteration: 'Subhanallah',
        translation: 'Glory be to Allah',
        targetCount: 33,
        category: 'Morning & Evening',
      ),
      DhikrModel(
        id: '2',
        title: 'Alhamdulillah',
        arabicText: 'الْحَمْدُ لِلَّهِ',
        transliteration: 'Alhamdulillah',
        translation: 'All praise is for Allah',
        targetCount: 33,
        category: 'Morning & Evening',
      ),
      DhikrModel(
        id: '3',
        title: 'Allahu Akbar',
        arabicText: 'اللَّهُ أَكْبَرُ',
        transliteration: 'Allahu Akbar',
        translation: 'Allah is the Greatest',
        targetCount: 33,
        category: 'Morning & Evening',
      ),
      DhikrModel(
        id: '4',
        title: 'La ilaha illallah',
        arabicText: 'لَا إِلَهَ إِلَّا اللَّهُ',
        transliteration: 'La ilaha illallah',
        translation: 'There is no god but Allah',
        targetCount: 100,
        category: 'General',
      ),
      DhikrModel(
        id: '5',
        title: 'Astaghfirullah',
        arabicText: 'أَسْتَغْفِرُ اللَّهَ',
        transliteration: 'Astaghfirullah',
        translation: 'I seek forgiveness from Allah',
        targetCount: 100,
        category: 'General',
      ),
    ];
  }
}
