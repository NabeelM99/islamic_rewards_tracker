import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prayer_model.dart';

class PrayerStorageService {
  static const String _prayersKey = 'prayers_list';
  static const String _sunnahPrayersKey = 'sunnah_prayers_list';
  static const String _qazaPrayersKey = 'qaza_prayers_list';

  // Get all prayers for a specific date
  Future<List<PrayerModel>> getPrayersForDate(DateTime date) async {
    final allPrayers = await getAllPrayers();
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    var prayersForDate = allPrayers.where((prayer) => 
      prayer.date.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
      prayer.date.isBefore(endOfDay)
    ).toList();
    
    // If no prayers exist for this date, create them
    if (prayersForDate.isEmpty) {
      prayersForDate = _createPrayersForDate(date);
      // Save all new prayers at once to avoid infinite loops
      allPrayers.addAll(prayersForDate);
      await _saveAllPrayers(allPrayers);
    }
    
    return prayersForDate;
  }

  // Get all prayers
  Future<List<PrayerModel>> getAllPrayers() async {
    final prefs = await SharedPreferences.getInstance();
    final prayersList = prefs.getStringList(_prayersKey) ?? [];
    
    if (prayersList.isEmpty) {
      // Initialize with today's prayers
      return _initializeDailyPrayers();
    }
    
    return prayersList
        .map((json) => PrayerModel.fromJson(jsonDecode(json)))
        .toList();
  }

  // Save prayer
  Future<void> savePrayer(PrayerModel prayer) async {
    final prefs = await SharedPreferences.getInstance();
    final prayersList = await getAllPrayers();
    
    final existingIndex = prayersList.indexWhere((p) => p.id == prayer.id);
    if (existingIndex >= 0) {
      prayersList[existingIndex] = prayer;
    } else {
      prayersList.add(prayer);
    }
    
    final jsonList = prayersList
        .map((p) => jsonEncode(p.toJson()))
        .toList();
    
    await prefs.setStringList(_prayersKey, jsonList);
  }

  // Update prayer status
  Future<void> updatePrayerStatus(String prayerId, PrayerStatus status, {String? notes}) async {
    print('Updating prayer $prayerId to status: $status');
    final prayersList = await getAllPrayers();
    final prayerIndex = prayersList.indexWhere((p) => p.id == prayerId);
    
    print('Found prayer at index: $prayerIndex');
    print('Total prayers: ${prayersList.length}');
    
    if (prayerIndex >= 0) {
      final prayer = prayersList[prayerIndex];
      print('Original prayer: ${prayer.type.name} - ${prayer.status}');
      
      final updatedPrayer = prayer.copyWith(
        status: status,
        completedAt: status == PrayerStatus.completed ? DateTime.now() : prayer.completedAt,
        missedAt: status == PrayerStatus.missed ? DateTime.now() : prayer.missedAt,
        notes: notes ?? prayer.notes,
      );
      
      print('Updated prayer: ${updatedPrayer.type.name} - ${updatedPrayer.status}');
      
      prayersList[prayerIndex] = updatedPrayer;
      await _saveAllPrayers(prayersList);
      print('Prayer status updated successfully');
    } else {
      print('Prayer not found with ID: $prayerId');
    }
  }

  // Mark prayer as qaza
  Future<void> markPrayerAsQaza(String prayerId) async {
    final prayersList = await getAllPrayers();
    final prayerIndex = prayersList.indexWhere((p) => p.id == prayerId);
    
    if (prayerIndex >= 0) {
      final prayer = prayersList[prayerIndex];
      final updatedPrayer = prayer.copyWith(
        isQaza: true,
        status: PrayerStatus.qaza,
      );
      
      prayersList[prayerIndex] = updatedPrayer;
      await _saveAllPrayers(prayersList);
    }
  }

  // Complete qaza prayer
  Future<void> completeQazaPrayer(String prayerId) async {
    final prayersList = await getAllPrayers();
    final prayerIndex = prayersList.indexWhere((p) => p.id == prayerId);
    
    if (prayerIndex >= 0) {
      final prayer = prayersList[prayerIndex];
      final updatedPrayer = prayer.copyWith(
        status: PrayerStatus.completed,
        qazaCompletedAt: DateTime.now(),
      );
      
      prayersList[prayerIndex] = updatedPrayer;
      await _saveAllPrayers(prayersList);
    }
  }

  // Get qaza prayers
  Future<List<PrayerModel>> getQazaPrayers() async {
    final allPrayers = await getAllPrayers();
    return allPrayers.where((p) => p.isQaza && p.status != PrayerStatus.completed).toList();
  }

  // Get sunnah prayers for today
  Future<List<SunnahPrayerModel>> getSunnahPrayers() async {
    final prefs = await SharedPreferences.getInstance();
    final sunnahList = prefs.getStringList(_sunnahPrayersKey) ?? [];
    
    List<SunnahPrayerModel> prayers;
    if (sunnahList.isEmpty) {
      // Initialize with default sunnah prayers
      prayers = _getDefaultSunnahPrayers();
      // Save all default prayers at once to avoid infinite loops
      await _saveAllSunnahPrayers(prayers);
    } else {
      prayers = sunnahList
          .map((json) => SunnahPrayerModel.fromJson(jsonDecode(json)))
          .toList();
    }
    
    return prayers;
  }

  // Get sunnah prayers for a specific date
  Future<List<SunnahPrayerModel>> getSunnahPrayersForDate(DateTime date) async {
    final allSunnahPrayers = await getSunnahPrayers();
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    var prayersForDate = allSunnahPrayers.where((prayer) => 
      prayer.date.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
      prayer.date.isBefore(endOfDay)
    ).toList();
    
    // If no prayers exist for this date, create them
    if (prayersForDate.isEmpty) {
      prayersForDate = _createSunnahPrayersForDate(date);
      // Save all new prayers at once to avoid infinite loops
      allSunnahPrayers.addAll(prayersForDate);
      await _saveAllSunnahPrayers(allSunnahPrayers);
    }
    
    return prayersForDate;
  }

  // Save sunnah prayer
  Future<void> saveSunnahPrayer(SunnahPrayerModel sunnahPrayer) async {
    final prefs = await SharedPreferences.getInstance();
    final sunnahList = await getSunnahPrayers();
    
    final existingIndex = sunnahList.indexWhere((s) => s.id == sunnahPrayer.id);
    if (existingIndex >= 0) {
      sunnahList[existingIndex] = sunnahPrayer;
    } else {
      sunnahList.add(sunnahPrayer);
    }
    
    final jsonList = sunnahList
        .map((s) => jsonEncode(s.toJson()))
        .toList();
    
    await prefs.setStringList(_sunnahPrayersKey, jsonList);
  }

  // Update sunnah prayer
  Future<void> updateSunnahPrayer(String sunnahId, int completedRakats, {String? notes}) async {
    final sunnahList = await getSunnahPrayers();
    final sunnahIndex = sunnahList.indexWhere((s) => s.id == sunnahId);
    
    if (sunnahIndex >= 0) {
      final sunnah = sunnahList[sunnahIndex];
      final updatedSunnah = sunnah.copyWith(
        completedRakats: completedRakats,
        isCompleted: completedRakats >= (sunnah.targetRakats ?? 0),
        completedAt: completedRakats >= (sunnah.targetRakats ?? 0) ? DateTime.now() : null,
        notes: notes ?? sunnah.notes,
      );
      
      sunnahList[sunnahIndex] = updatedSunnah;
      await _saveAllSunnahPrayers(sunnahList);
    }
  }

  // Get prayer statistics
  Future<PrayerStatistics> getPrayerStatistics() async {
    final prayers = await getAllPrayers();
    return PrayerStatistics.fromPrayers(prayers);
  }

  // Reset daily prayers
  Future<void> resetDailyPrayers() async {
    final today = DateTime.now();
    final todayPrayers = await getPrayersForDate(today);
    
    for (final prayer in todayPrayers) {
      if (prayer.status == PrayerStatus.pending) {
        await updatePrayerStatus(prayer.id, PrayerStatus.missed);
      }
    }
  }

  // Helper method to save all prayers
  Future<void> _saveAllPrayers(List<PrayerModel> prayersList) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prayersList
        .map((p) => jsonEncode(p.toJson()))
        .toList();
    
    await prefs.setStringList(_prayersKey, jsonList);
  }

  // Helper method to save all sunnah prayers
  Future<void> _saveAllSunnahPrayers(List<SunnahPrayerModel> sunnahList) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = sunnahList
        .map((s) => jsonEncode(s.toJson()))
        .toList();
    
    await prefs.setStringList(_sunnahPrayersKey, jsonList);
  }

  // Initialize daily prayers for a specific date
  List<PrayerModel> _initializeDailyPrayers() {
    final today = DateTime.now();
    return _createPrayersForDate(today);
  }

  // Create prayers for a specific date
  List<PrayerModel> _createPrayersForDate(DateTime date) {
    final prayers = <PrayerModel>[];
    
    for (final type in PrayerType.values) {
      prayers.add(PrayerModel(
        id: '${type.name}_${date.millisecondsSinceEpoch}_${type.name}',
        type: type,
        date: date,
        status: PrayerStatus.pending,
      ));
    }
    
    return prayers;
  }

  // Get default sunnah prayers
  List<SunnahPrayerModel> _getDefaultSunnahPrayers() {
    final today = DateTime.now();
    return _createSunnahPrayersForDate(today);
  }

  // Create sunnah prayers for a specific date
  List<SunnahPrayerModel> _createSunnahPrayersForDate(DateTime date) {
    return [
      SunnahPrayerModel(
        id: 'tahajjud_${date.millisecondsSinceEpoch}_tahajjud',
        type: SunnahType.tahajjud,
        title: 'Tahajjud',
        arabicText: 'تهجد',
        transliteration: 'Tahajjud',
        translation: 'Night prayer',
        targetRakats: 8,
        date: date,
      ),
      SunnahPrayerModel(
        id: 'duha_${date.millisecondsSinceEpoch}_duha',
        type: SunnahType.duha,
        title: 'Duha',
        arabicText: 'ضحى',
        transliteration: 'Duha',
        translation: 'Forenoon prayer',
        targetRakats: 2,
        date: date,
      ),
      SunnahPrayerModel(
        id: 'witr_${date.millisecondsSinceEpoch}_witr',
        type: SunnahType.witr,
        title: 'Witr',
        arabicText: 'وتر',
        transliteration: 'Witr',
        translation: 'Odd-numbered prayer',
        targetRakats: 3,
        date: date,
      ),
    ];
  }
} 