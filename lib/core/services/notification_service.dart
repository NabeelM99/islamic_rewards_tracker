import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'dart:convert';
import 'android_exact_alarm_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static const String _channelId = 'islamic_rewards_channel';
  static const String _channelName = 'Islamic Rewards Notifications';
  static const String _channelDescription = 'Notifications for Islamic tasks and reminders';

  // Notification IDs
  static const int _taskReminderId = 1000;
  static const int _dhikrReminderId = 2000;
  static const int _duaReminderId = 3000;
  static const int _dailyResetId = 4000;

  // Shared preferences keys
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _taskRemindersEnabledKey = 'task_reminders_enabled';
  static const String _dhikrRemindersEnabledKey = 'dhikr_reminders_enabled';
  static const String _duaRemindersEnabledKey = 'dua_reminders_enabled';
  static const String _lastNotificationTimeKey = 'last_notification_time';

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone
    tz.initializeTimeZones();
    
    // Set Bahrain timezone (GMT+3) for accurate scheduling
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Bahrain'));
      debugPrint('✅ Bahrain timezone set: Asia/Bahrain (GMT+3)');
    } catch (e) {
      debugPrint('⚠️ Could not set Bahrain timezone, using device default: $e');
      tz.setLocalLocation(tz.local);
    }
    
    final String timeZoneName = DateTime.now().timeZoneName;
    debugPrint('Device timezone: $timeZoneName');
    
    // Request notification permissions
    await _requestPermissions();

    // Initialize Android settings
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize iOS settings
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Initialize settings
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize the plugin
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    await _createNotificationChannel();

    // Only schedule notifications if enabled AND not already scheduled today
    if (await areNotificationsEnabled()) {
      // Check if we already scheduled for today to prevent duplicates
      final prefs = await SharedPreferences.getInstance();
      final lastScheduledDate = prefs.getString('last_notifications_scheduled');
      final today = DateTime.now();
      final todayString = DateTime(today.year, today.month, today.day).toIso8601String();
      
      if (lastScheduledDate != todayString) {
        await scheduleAllNotifications();
        // Save the scheduled date to prevent duplicate scheduling
        await prefs.setString('last_notifications_scheduled', todayString);
        debugPrint('✅ Notifications scheduled for today: $todayString');
      } else {
        debugPrint('✅ Notifications already scheduled for today, skipping duplicate scheduling');
      }
    }

    _isInitialized = true;
  }

  Future<void> _requestPermissions() async {
    try {
      // Request notification permission
      final status = await Permission.notification.request();
      debugPrint('Notification permission status: $status');
      
      if (status.isDenied) {
        debugPrint('Notification permission denied');
      } else if (status.isPermanentlyDenied) {
        debugPrint('Notification permission permanently denied');
      } else if (status.isGranted) {
        debugPrint('Notification permission granted');
      }
      
      // Note: Exact alarm permission checking is not available in current flutter_local_notifications version
      // The app will use exact alarm scheduling which should work on most devices
      debugPrint('Using exact alarm scheduling for reliable notifications');
    } catch (e) {
      debugPrint('Error requesting notification permission: $e');
    }
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      showBadge: true,
    );

    await _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - navigate to appropriate screen
    debugPrint('Notification tapped: ${response.payload}');
    
    try {
      if (response.payload != null) {
        final Map<String, dynamic> payload = Map<String, dynamic>.from(jsonDecode(response.payload!));
        final String type = payload['type'] as String;
        final int id = payload['id'] as int;
        
        debugPrint('Notification type: $type, ID: $id');
        
        // TODO: Implement navigation logic based on notification type
        switch (type) {
          case 'daily_reminder':
            // Navigate to home screen or specific task
            break;
          case 'task_reminder':
            // Navigate to task screen
            break;
          case 'dhikr_reminder':
            // Navigate to dhikr screen
            break;
          case 'dua_reminder':
            // Navigate to dua screen
            break;
          default:
            // Default navigation
            break;
        }
      }
    } catch (e) {
      debugPrint('Error parsing notification payload: $e');
    }
  }

  // Core daily scheduling method for reliable notifications
  Future<void> _scheduleDaily(int id, String title, String body, int hour, int minute) async {
    try {
      // Get current time with fallback timezone handling
      tz.TZDateTime now;
      tz.TZDateTime scheduled;
      
      try {
        // Try to get timezone-specific time
        now = tz.TZDateTime.now(tz.getLocation('Asia/Bahrain'));
        scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
        debugPrint('✅ Timezone time retrieved successfully: $now');
      } catch (e) {
        debugPrint('⚠️ Timezone time failed, using system time: $e');
        // Create TZDateTime from system time as fallback
        final systemNow = DateTime.now();
        now = tz.TZDateTime.from(systemNow, tz.local);
        scheduled = tz.TZDateTime.from(DateTime(systemNow.year, systemNow.month, systemNow.day, hour, minute), tz.local);
      }
      
      // If time has passed today, schedule for tomorrow
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }
      
      debugPrint('⏰ Scheduling daily notification for ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
      
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduled,
        _getTaskReminderNotificationDetails(),
        androidAllowWhileIdle: true,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // This makes it repeat daily
        payload: jsonEncode({
          'type': 'daily_reminder',
          'id': id,
          'title': title,
          'body': body,
          'hour': hour,
          'minute': minute,
        }),
      );
      
      debugPrint('✅ Daily notification scheduled for ${scheduled.hour}:${scheduled.minute.toString().padLeft(2, '0')}');
      
    } catch (e) {
      debugPrint('❌ Error scheduling daily notification: $e');
    }
  }

  // Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? true;
  }

  // Enable/disable all notifications
  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);
    
    if (enabled) {
      await scheduleAllNotifications();
    } else {
      await cancelAllNotifications();
    }
  }

  // Task reminder notifications (every 6 hours)
  Future<void> scheduleTaskReminders() async {
    if (!await areNotificationsEnabled()) return;

    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_taskRemindersEnabledKey) == false) return;

    // Cancel existing task reminders
    await _notifications.cancel(_taskReminderId);

    // Schedule task reminders every 6 hours using daily scheduling
    await _scheduleDaily(_taskReminderId, 'Islamic Tasks Reminder', 'Complete your daily Islamic tasks and earn rewards!', 6, 0);
    await _scheduleDaily(_taskReminderId + 1, 'Islamic Tasks Reminder', 'Complete your daily Islamic tasks and earn rewards!', 12, 0);
    await _scheduleDaily(_taskReminderId + 2, 'Islamic Tasks Reminder', 'Complete your daily Islamic tasks and earn rewards!', 18, 0);
    await _scheduleDaily(_taskReminderId + 3, 'Islamic Tasks Reminder', 'Complete your daily Islamic tasks and earn rewards!', 0, 0);
    
    debugPrint('✅ Task reminders scheduled for daily repetition');
  }

  // Dhikr reminder notifications
  Future<void> scheduleDhikrReminders() async {
    if (!await areNotificationsEnabled()) return;

    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_dhikrRemindersEnabledKey) == false) return;

    // Cancel existing dhikr reminders
    await _notifications.cancel(_dhikrReminderId);

    // Schedule dhikr reminders using daily scheduling
    await _scheduleDaily(_dhikrReminderId, 'Dhikr Reminder', 'Time for dhikr and remembrance of Allah', 5, 30); // Fajr
    await _scheduleDaily(_dhikrReminderId + 1, 'Dhikr Reminder', 'Time for dhikr and remembrance of Allah', 13, 0); // Dhuhr
    await _scheduleDaily(_dhikrReminderId + 2, 'Dhikr Reminder', 'Time for dhikr and remembrance of Allah', 16, 30); // Asr
    await _scheduleDaily(_dhikrReminderId + 3, 'Dhikr Reminder', 'Time for dhikr and remembrance of Allah', 19, 0); // Maghrib
    await _scheduleDaily(_dhikrReminderId + 4, 'Dhikr Reminder', 'Time for dhikr and remembrance of Allah', 20, 30); // Isha
    
    debugPrint('✅ Dhikr reminders scheduled for daily repetition');
  }

  // Dua reminder notifications
  Future<void> scheduleDuaReminders() async {
    if (!await areNotificationsEnabled()) return;

    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_duaRemindersEnabledKey) == false) return;

    // Cancel existing dua reminders
    await _notifications.cancel(_duaReminderId);

    // Schedule dua reminders using daily scheduling
    await _scheduleDaily(_duaReminderId, 'Dua Reminder', 'Recite your daily duas and supplications', 7, 0); // Morning
    await _scheduleDaily(_duaReminderId + 1, 'Dua Reminder', 'Recite your daily duas and supplications', 18, 30); // Evening
    
    debugPrint('✅ Dua reminders scheduled for daily repetition');
  }

  // Remove all test notification methods - they are not needed for production
  // Only automated daily reminders should work

  // Schedule all notifications
  Future<void> scheduleAllNotifications() async {
    try {
      await scheduleTaskReminders();
      await scheduleDhikrReminders();
      await scheduleDuaReminders();
      
      debugPrint('✅ All notifications scheduled successfully');
    } catch (e) {
      debugPrint('❌ Error scheduling notifications: $e');
    }
  }

  // Handle boot events - called when device reboots
  Future<void> handleBootEvent() async {
    debugPrint('🔄 Handling boot event - rescheduling notifications');
    
    // Wait a bit for the system to be ready
    await Future.delayed(const Duration(seconds: 5));
    
    // Re-initialize if needed
    if (!_isInitialized) {
      await initialize();
    }
    
    // Reschedule all notifications
    await scheduleAllNotifications();
    
    debugPrint('✅ Boot event handled - notifications rescheduled');
  }

  // Check if notifications are actually working
  Future<bool> checkNotificationStatus() async {
    try {
      final status = await Permission.notification.status;
      final enabled = await areNotificationsEnabled();
      
      debugPrint('Notification status: $status, Enabled: $enabled');
      
      // Note: Exact alarm permission checking is not available in current version
      // We'll assume it's granted and focus on notification permissions
      debugPrint('Notification permissions: $status, App enabled: $enabled');
      
      return status.isGranted && enabled;
    } catch (e) {
      debugPrint('Error checking notification status: $e');
      return false;
    }
  }

  // WorkManager removed - using AlarmManager only
  
  // Request exact alarm permission for Android 12+
  Future<bool> requestExactAlarmPermission() async {
    try {
      if (await Permission.scheduleExactAlarm.isDenied) {
        final intent = AndroidIntent(action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM');
        await intent.launch();
        return false; // Will need to check again after user returns
      }
      return true;
    } catch (e) {
      debugPrint('Error requesting exact alarm permission: $e');
      return false;
    }
  }

  // Ensure notifications are scheduled for background operation
  Future<void> ensureBackgroundNotifications() async {
    try {
      debugPrint('🔄 Ensuring background notifications are scheduled...');
      
      // Check if notifications are enabled
      if (!await areNotificationsEnabled()) {
        debugPrint('Notifications are disabled, skipping background scheduling');
        return;
      }
      
      // Schedule all notifications using AlarmManager
      await AndroidExactAlarmService.scheduleAllReminders();
      
      debugPrint('✅ Background notifications ensured with AlarmManager');
    } catch (e) {
      debugPrint('❌ Error ensuring background notifications: $e');
    }
  }

  // Force reschedule notifications (for troubleshooting)
  Future<void> forceRescheduleNotifications() async {
    try {
      debugPrint('🔄 Force rescheduling notifications...');
      
      // Cancel all existing notifications
      await cancelAllNotifications();
      
      // Schedule all notifications using AlarmManager
      await AndroidExactAlarmService.scheduleAllReminders();
      
      debugPrint('✅ Notifications force rescheduled with AlarmManager');
    } catch (e) {
      debugPrint('❌ Error force rescheduling notifications: $e');
    }
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // NUCLEAR OPTION: Maximum aggressive notification strategy for bypassing Android blocking
  Future<void> scheduleNuclearNotification() async {
    try {
      debugPrint('🚨 NUCLEAR OPTION: Scheduling maximum aggressive notification');
      
      // Use AlarmManager nuclear method
      await AndroidExactAlarmService.scheduleAllReminders();
      
      debugPrint('🚨 NUCLEAR OPTION: Deployed using AlarmManager. Close app and wait 1 minute.');
      
    } catch (e) {
      debugPrint('❌ Error in nuclear option: $e');
    }
  }

  // ANDROID EXACT ALARM METHOD: Use native Android AlarmManager for maximum reliability
  Future<void> scheduleAndroidExactAlarms() async {
    try {
      debugPrint('🚀 ANDROID EXACT ALARM: Using native Android AlarmManager for maximum reliability');
      
      // Check exact alarm permission first
      if (!await AndroidExactAlarmService.canScheduleExactAlarms()) {
        debugPrint('⚠️ Exact alarm permission not granted, requesting...');
        final granted = await AndroidExactAlarmService.requestExactAlarmPermission();
        if (!granted) {
          debugPrint('❌ Exact alarm permission denied, cannot use Android exact alarms');
          return;
        }
      }
      
      // Check battery optimization
      if (!await AndroidExactAlarmService.isIgnoringBatteryOptimizations()) {
        debugPrint('⚠️ Battery optimization not disabled, requesting...');
        final disabled = await AndroidExactAlarmService.requestIgnoreBatteryOptimizations();
        if (!disabled) {
          debugPrint('⚠️ Battery optimization not disabled, notifications may be delayed');
        }
      }
      
      // Start the Android alarm scheduler
      final started = await AndroidExactAlarmService.startAlarmScheduler();
      if (started) {
        debugPrint('✅ Android alarm scheduler started successfully');
        
        // Schedule all reminders using exact alarms
        final scheduled = await AndroidExactAlarmService.scheduleAllReminders();
        if (scheduled) {
          debugPrint('✅ All reminders scheduled using Android exact alarms');
          
          // Get scheduled alarms for verification
          final alarms = await AndroidExactAlarmService.getScheduledAlarms();
          debugPrint('📋 Scheduled alarms: ${alarms.length}');
          for (final alarm in alarms) {
            debugPrint('   - ${alarm['type']} at ${alarm['hour']}:${alarm['minute']} (ID: ${alarm['id']})');
          }
        } else {
          debugPrint('❌ Failed to schedule reminders using Android exact alarms');
        }
      } else {
        debugPrint('❌ Failed to start Android alarm scheduler');
      }
      
    } catch (e) {
      debugPrint('❌ Error using Android exact alarms: $e');
    }
  }

  // Show notification with custom details
  Future<void> show(int id, String title, String body, NotificationDetails? notificationDetails) async {
    await _notifications.show(
      id,
      title,
      body,
      notificationDetails ?? _getTaskReminderNotificationDetails(),
    );
  }

  // Notification details for task reminders
  NotificationDetails _getTaskReminderNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: Color(0xFF4CAF50),
        enableVibration: true,
        enableLights: true,
        playSound: true,
        category: AndroidNotificationCategory.reminder,
        actions: [],
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        categoryIdentifier: 'task_reminder',
      ),
    );
  }

  // Notification details for dhikr reminders
  NotificationDetails _getDhikrReminderNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: Color(0xFF2196F3),
        enableVibration: true,
        enableLights: true,
        playSound: true,
        category: AndroidNotificationCategory.reminder,
        actions: [],
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        categoryIdentifier: 'dhikr_reminder',
      ),
    );
  }

  // Notification details for dua reminders
  NotificationDetails _getDuaReminderNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: Color(0xFFFF9800),
        enableVibration: true,
        enableLights: true,
        playSound: true,
        category: AndroidNotificationCategory.reminder,
        actions: [],
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        categoryIdentifier: 'dua_reminder',
      ),
    );
  }

  // Settings methods
  Future<void> setTaskRemindersEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_taskRemindersEnabledKey, enabled);
    
    if (enabled) {
      await scheduleTaskReminders();
    } else {
      await _notifications.cancel(_taskReminderId);
    }
  }

  Future<void> setDhikrRemindersEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dhikrRemindersEnabledKey, enabled);
    
    if (enabled) {
      await scheduleDhikrReminders();
    } else {
      await _notifications.cancel(_dhikrReminderId);
    }
  }

  Future<void> setDuaRemindersEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_duaRemindersEnabledKey, enabled);
    
    if (enabled) {
      await scheduleDuaReminders();
    } else {
      await _notifications.cancel(_duaReminderId);
    }
  }

  Future<bool> areTaskRemindersEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_taskRemindersEnabledKey) ?? true;
  }

  Future<bool> areDhikrRemindersEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_dhikrRemindersEnabledKey) ?? true;
  }

  Future<bool> areDuaRemindersEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_duaRemindersEnabledKey) ?? true;
  }
} 
