import 'package:flutter/material.dart';
import '../presentation/duas_screen/duas_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/dua_detail_screen/dua_detail_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/history_screen/history_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/tasbih_counter_screen/tasbih_counter_screen.dart';
import '../presentation/prayer_tracking_screen/prayer_tracking_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String duas = '/duas-screen';
  static const String splash = '/splash-screen';
  static const String duaDetail = '/dua-detail-screen';
  static const String settings = '/settings-screen';
  static const String history = '/history-screen';
  static const String home = '/home-screen';
  static const String profile = '/profile-screen';
  static const String login = '/login-screen';
  static const String tasbihCounter = '/tasbih-counter-screen';
  static const String prayerTracking = '/prayer-tracking-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    home: (context) => const HomeScreen(),
    duas: (context) => const DuasScreen(),
    history: (context) => const HistoryScreen(),
    settings: (context) => const SettingsScreen(),
    profile: (context) => const ProfileScreen(),
    duaDetail: (context) => const DuaDetailScreen(),
    tasbihCounter: (context) => const TasbihCounterScreen(),
    prayerTracking: (context) => const PrayerTrackingScreen(),
  };
}
