enum PrayerType {
  fajr,
  dhuhr,
  asr,
  maghrib,
  isha,
}

enum PrayerStatus {
  pending,
  completed,
  missed,
  qaza,
}

enum SunnahType {
  tahajjud,
  duha,
  witr,
  nafl,
  other,
}

class PrayerModel {
  final String id;
  final PrayerType type;
  final DateTime date;
  final PrayerStatus status;
  final DateTime? completedAt;
  final DateTime? missedAt;
  final String? notes;
  final bool isQaza;
  final DateTime? qazaCompletedAt;

  PrayerModel({
    required this.id,
    required this.type,
    required this.date,
    this.status = PrayerStatus.pending,
    this.completedAt,
    this.missedAt,
    this.notes,
    this.isQaza = false,
    this.qazaCompletedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'date': date.toIso8601String(),
        'status': status.name,
        'completedAt': completedAt?.toIso8601String(),
        'missedAt': missedAt?.toIso8601String(),
        'notes': notes,
        'isQaza': isQaza,
        'qazaCompletedAt': qazaCompletedAt?.toIso8601String(),
      };

  factory PrayerModel.fromJson(Map<String, dynamic> json) => PrayerModel(
        id: json['id'],
        type: PrayerType.values.firstWhere((e) => e.name == json['type']),
        date: DateTime.parse(json['date']),
        status: PrayerStatus.values.firstWhere((e) => e.name == json['status']),
        completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
        missedAt: json['missedAt'] != null ? DateTime.parse(json['missedAt']) : null,
        notes: json['notes'],
        isQaza: json['isQaza'] ?? false,
        qazaCompletedAt: json['qazaCompletedAt'] != null ? DateTime.parse(json['qazaCompletedAt']) : null,
      );

  PrayerModel copyWith({
    PrayerStatus? status,
    DateTime? completedAt,
    DateTime? missedAt,
    String? notes,
    bool? isQaza,
    DateTime? qazaCompletedAt,
  }) {
    return PrayerModel(
      id: id,
      type: type,
      date: date,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      missedAt: missedAt ?? this.missedAt,
      notes: notes ?? this.notes,
      isQaza: isQaza ?? this.isQaza,
      qazaCompletedAt: qazaCompletedAt ?? this.qazaCompletedAt,
    );
  }

  String get displayName {
    switch (type) {
      case PrayerType.fajr:
        return 'Fajr';
      case PrayerType.dhuhr:
        return 'Dhuhr';
      case PrayerType.asr:
        return 'Asr';
      case PrayerType.maghrib:
        return 'Maghrib';
      case PrayerType.isha:
        return 'Isha';
    }
  }

  String get arabicName {
    switch (type) {
      case PrayerType.fajr:
        return 'الفجر';
      case PrayerType.dhuhr:
        return 'الظهر';
      case PrayerType.asr:
        return 'العصر';
      case PrayerType.maghrib:
        return 'المغرب';
      case PrayerType.isha:
        return 'العشاء';
    }
  }

  String get transliteration {
    switch (type) {
      case PrayerType.fajr:
        return 'Fajr';
      case PrayerType.dhuhr:
        return 'Dhuhr';
      case PrayerType.asr:
        return 'Asr';
      case PrayerType.maghrib:
        return 'Maghrib';
      case PrayerType.isha:
        return 'Isha';
    }
  }
}

class SunnahPrayerModel {
  final String id;
  final SunnahType type;
  final String title;
  final String? arabicText;
  final String? transliteration;
  final String? translation;
  final int? targetRakats;
  final int completedRakats;
  final DateTime date;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? notes;

  SunnahPrayerModel({
    required this.id,
    required this.type,
    required this.title,
    this.arabicText,
    this.transliteration,
    this.translation,
    this.targetRakats,
    this.completedRakats = 0,
    required this.date,
    this.isCompleted = false,
    this.completedAt,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'title': title,
        'arabicText': arabicText,
        'transliteration': transliteration,
        'translation': translation,
        'targetRakats': targetRakats,
        'completedRakats': completedRakats,
        'date': date.toIso8601String(),
        'isCompleted': isCompleted,
        'completedAt': completedAt?.toIso8601String(),
        'notes': notes,
      };

  factory SunnahPrayerModel.fromJson(Map<String, dynamic> json) => SunnahPrayerModel(
        id: json['id'],
        type: SunnahType.values.firstWhere((e) => e.name == json['type']),
        title: json['title'],
        arabicText: json['arabicText'],
        transliteration: json['transliteration'],
        translation: json['translation'],
        targetRakats: json['targetRakats'],
        completedRakats: json['completedRakats'] ?? 0,
        date: DateTime.parse(json['date']),
        isCompleted: json['isCompleted'] ?? false,
        completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
        notes: json['notes'],
      );

  SunnahPrayerModel copyWith({
    int? completedRakats,
    bool? isCompleted,
    DateTime? completedAt,
    String? notes,
  }) {
    return SunnahPrayerModel(
      id: id,
      type: type,
      title: title,
      arabicText: arabicText,
      transliteration: transliteration,
      translation: translation,
      targetRakats: targetRakats,
      completedRakats: completedRakats ?? this.completedRakats,
      date: date,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
    );
  }
}

class PrayerStatistics {
  final int totalPrayers;
  final int completedPrayers;
  final int missedPrayers;
  final int qazaPrayers;
  final double completionRate;
  final Map<PrayerType, int> prayerTypeStats;
  final Map<String, int> monthlyStats;

  PrayerStatistics({
    required this.totalPrayers,
    required this.completedPrayers,
    required this.missedPrayers,
    required this.qazaPrayers,
    required this.completionRate,
    required this.prayerTypeStats,
    required this.monthlyStats,
  });

  factory PrayerStatistics.fromPrayers(List<PrayerModel> prayers) {
    final totalPrayers = prayers.length;
    final completedPrayers = prayers.where((p) => p.status == PrayerStatus.completed).length;
    final missedPrayers = prayers.where((p) => p.status == PrayerStatus.missed).length;
    final qazaPrayers = prayers.where((p) => p.isQaza).length;
    final completionRate = totalPrayers > 0 ? (completedPrayers / totalPrayers) * 100 : 0.0;

    final prayerTypeStats = <PrayerType, int>{};
    for (final type in PrayerType.values) {
      prayerTypeStats[type] = prayers.where((p) => p.type == type && p.status == PrayerStatus.completed).length;
    }

    final monthlyStats = <String, int>{};
    for (final prayer in prayers) {
      final monthKey = '${prayer.date.year}-${prayer.date.month.toString().padLeft(2, '0')}';
      monthlyStats[monthKey] = (monthlyStats[monthKey] ?? 0) + 1;
    }

    return PrayerStatistics(
      totalPrayers: totalPrayers,
      completedPrayers: completedPrayers,
      missedPrayers: missedPrayers,
      qazaPrayers: qazaPrayers,
      completionRate: completionRate,
      prayerTypeStats: prayerTypeStats,
      monthlyStats: monthlyStats,
    );
  }
} 