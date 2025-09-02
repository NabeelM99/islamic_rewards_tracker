import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class LocalizationService extends ChangeNotifier {
  static const String _languageKey = 'selectedLanguage';
  static const String _localeKey = 'selectedLocale';
  
  static const Locale _defaultLocale = Locale('en', 'US');
  static const String _defaultLanguage = 'English';
  
  static final Map<String, Locale> _supportedLocales = {
    'English': const Locale('en', 'US'),
    'العربية': const Locale('ar', 'SA'),
    'বাংলা': const Locale('bn', 'BD'),
  };
  
  static final Map<String, String> _languageNames = {
    'en': 'English',
    'ar': 'العربية',
    'bn': 'বাংলা',
  };
  
  static final Map<String, String> _languageNamesInEnglish = {
    'en': 'English',
    'ar': 'Arabic',
    'bn': 'Bangla',
  };

  Locale _currentLocale = _defaultLocale;
  String _currentLanguage = _defaultLanguage;
  
  Locale get currentLocale => _currentLocale;
  String get currentLanguage => _currentLanguage;
  
  static List<Locale> get supportedLocales => _supportedLocales.values.toList();
  static Map<String, Locale> get supportedLanguages => _supportedLocales;
  static Map<String, String> get languageNames => _languageNames;
  static Map<String, String> get languageNamesInEnglish => _languageNamesInEnglish;

  LocalizationService() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey) ?? _defaultLanguage;
    final savedLocale = prefs.getString(_localeKey);
    
    if (savedLocale != null) {
      try {
        final parts = savedLocale.split('_');
        if (parts.length == 2) {
          _currentLocale = Locale(parts[0], parts[1]);
        }
      } catch (_) {
        _currentLocale = _defaultLocale;
      }
    }
    
    _currentLanguage = savedLanguage;
    
    // Ensure locale matches language
    if (_supportedLocales.containsKey(_currentLanguage)) {
      _currentLocale = _supportedLocales[_currentLanguage]!;
    }
    
    notifyListeners();
  }

  Future<void> changeLanguage(String language) async {
    if (!_supportedLocales.containsKey(language)) return;
    
    _currentLanguage = language;
    _currentLocale = _supportedLocales[language]!;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
    await prefs.setString(_localeKey, '${_currentLocale.languageCode}_${_currentLocale.countryCode}');
    
    notifyListeners();
  }

  Future<void> resetToDefault() async {
    _currentLanguage = _defaultLanguage;
    _currentLocale = _defaultLocale;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, _defaultLanguage);
    await prefs.setString(_localeKey, '${_defaultLocale.languageCode}_${_defaultLocale.countryCode}');
    
    notifyListeners();
  }

  bool isRTL() {
    return _currentLocale.languageCode == 'ar';
  }

  bool isBangla() {
    return _currentLocale.languageCode == 'bn';
  }

  bool isArabic() {
    return _currentLocale.languageCode == 'ar';
  }

  bool isEnglish() {
    return _currentLocale.languageCode == 'en';
  }

  String getLanguageDisplayName(String languageCode) {
    return _languageNames[languageCode] ?? languageCode;
  }

  String getLanguageDisplayNameInEnglish(String languageCode) {
    return _languageNamesInEnglish[languageCode] ?? languageCode;
  }
} 