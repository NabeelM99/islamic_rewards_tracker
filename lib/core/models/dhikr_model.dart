class DhikrModel {
  final String id;
  final String title;
  final String? arabicText;
  final String? transliteration;
  final String? translation;
  final int targetCount;
  final int currentCount;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final bool isCustom;
  final String? category;

  DhikrModel({
    required this.id,
    required this.title,
    this.arabicText,
    this.transliteration,
    this.translation,
    required this.targetCount,
    this.currentCount = 0,
    DateTime? createdAt,
    DateTime? lastUpdated,
    this.isCustom = false,
    this.category,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastUpdated = lastUpdated ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'arabicText': arabicText,
        'transliteration': transliteration,
        'translation': translation,
        'targetCount': targetCount,
        'currentCount': currentCount,
        'createdAt': createdAt.toIso8601String(),
        'lastUpdated': lastUpdated.toIso8601String(),
        'isCustom': isCustom,
        'category': category,
      };

  factory DhikrModel.fromJson(Map<String, dynamic> json) => DhikrModel(
        id: json['id'],
        title: json['title'],
        arabicText: json['arabicText'],
        transliteration: json['transliteration'],
        translation: json['translation'],
        targetCount: json['targetCount'],
        currentCount: json['currentCount'] ?? 0,
        createdAt: DateTime.parse(json['createdAt']),
        lastUpdated: DateTime.parse(json['lastUpdated']),
        isCustom: json['isCustom'] ?? false,
        category: json['category'],
      );

  DhikrModel copyWith({
    String? title,
    String? arabicText,
    String? transliteration,
    String? translation,
    int? targetCount,
    int? currentCount,
    DateTime? lastUpdated,
    String? category,
  }) {
    return DhikrModel(
      id: id,
      title: title ?? this.title,
      arabicText: arabicText ?? this.arabicText,
      transliteration: transliteration ?? this.transliteration,
      translation: translation ?? this.translation,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
      createdAt: createdAt,
      lastUpdated: lastUpdated ?? DateTime.now(),
      isCustom: isCustom,
      category: category ?? this.category,
    );
  }
}

class TasbihSession {
  final String id;
  final String dhikrId;
  final int count;
  final DateTime startTime;
  final DateTime endTime;
  final int duration; // in seconds

  TasbihSession({
    required this.id,
    required this.dhikrId,
    required this.count,
    required this.startTime,
    required this.endTime,
    required this.duration,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'dhikrId': dhikrId,
        'count': count,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'duration': duration,
      };

  factory TasbihSession.fromJson(Map<String, dynamic> json) => TasbihSession(
        id: json['id'],
        dhikrId: json['dhikrId'],
        count: json['count'],
        startTime: DateTime.parse(json['startTime']),
        endTime: DateTime.parse(json['endTime']),
        duration: json['duration'],
      );
} 