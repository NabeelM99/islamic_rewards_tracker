import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
import '../widgets/custom_error_widget.dart';
import '../core/utils/performance_utils.dart';
import '../core/services/notification_service.dart';
import '../core/services/localization_service.dart';
import '../core/localization/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable performance optimizations
  PerformanceUtils.enablePerformanceOptimizations();

      // Initialize notification service (using AlarmManager only)
  await NotificationService().initialize();
  
  // 🚨 CRITICAL: Custom error handling - DO NOT REMOVE
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(
      errorDetails: details,
    );
  };
  
  // 🚨 CRITICAL: Device orientation lock - DO NOT REMOVE
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  ]).then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late LocalizationService _localizationService;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _localizationService = LocalizationService();
    
    // Handle any pending boot events
    _handleBootEvent();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (state == AppLifecycleState.resumed) {
      // App came back to foreground, check notification status
      _checkNotificationStatus();
    }
  }

  Future<void> _handleBootEvent() async {
    try {
      // Check if this might be a boot-triggered launch
      await NotificationService().handleBootEvent();
      
      // Use Android exact alarms for maximum reliability (Android 15 + Samsung)
      await NotificationService().scheduleAndroidExactAlarms();
      
      // Note: Test notifications will be scheduled manually from settings
      debugPrint('App initialized successfully');
    } catch (e) {
      debugPrint('Error handling boot event: $e');
    }
  }

  Future<void> _checkNotificationStatus() async {
    try {
      final isWorking = await NotificationService().checkNotificationStatus();
      if (!isWorking) {
        debugPrint('⚠️ Notifications not working properly');
      }
      
      // Don't reschedule notifications every time app comes to foreground
      // They are already scheduled and working in the background
      
    } catch (e) {
      debugPrint('Error checking notification status: $e');
    }
  }

  // Memoized theme configurations for better performance
  static final ThemeData _lightTheme = AppTheme.lightTheme.copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: SmoothPageTransitionsBuilder(),
        TargetPlatform.iOS: SmoothPageTransitionsBuilder(),
        TargetPlatform.linux: SmoothPageTransitionsBuilder(),
        TargetPlatform.macOS: SmoothPageTransitionsBuilder(),
        TargetPlatform.windows: SmoothPageTransitionsBuilder(),
      },
    ),
    // Enhanced button theme for smooth interactions
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shadowColor: AppTheme.shadowLight,
        animationDuration: AppTheme.fastAnimation,
      ),
    ),
    // Enhanced card theme for smooth animations
    cardTheme: CardTheme(
      elevation: 2,
      shadowColor: AppTheme.shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static final ThemeData _darkTheme = AppTheme.darkTheme.copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: SmoothPageTransitionsBuilder(),
        TargetPlatform.iOS: SmoothPageTransitionsBuilder(),
        TargetPlatform.linux: SmoothPageTransitionsBuilder(),
        TargetPlatform.macOS: SmoothPageTransitionsBuilder(),
        TargetPlatform.windows: SmoothPageTransitionsBuilder(),
      },
    ),
    // Enhanced button theme for smooth interactions
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shadowColor: AppTheme.shadowDark,
        animationDuration: AppTheme.fastAnimation,
      ),
    ),
    // Enhanced card theme for smooth animations
    cardTheme: CardTheme(
      elevation: 2,
      shadowColor: AppTheme.shadowDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return ListenableBuilder(
        listenable: _localizationService,
        builder: (context, _) {
          return MaterialApp(
            title: 'islamic_rewards_tracker',
            theme: _lightTheme,
            darkTheme: _darkTheme,
            themeMode: ThemeMode.light,
            locale: _localizationService.currentLocale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            // 🚨 CRITICAL: NEVER REMOVE OR MODIFY
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: ScrollConfiguration(
                  behavior: const SmoothScrollBehavior(),
                  child: child!,
                ),
              );
            },
            // 🚨 END CRITICAL SECTION
            debugShowCheckedModeBanner: false,
            routes: AppRoutes.routes,
            initialRoute: AppRoutes.initial,
          );
        },
      );
    });
  }
}

class SmoothScrollBehavior extends ScrollBehavior {
  const SmoothScrollBehavior();

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child; // remove glow
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    final platform = getPlatform(context);
    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
    }
    return const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  }
}
