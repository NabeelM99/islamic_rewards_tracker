import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_intent_plus/android_intent.dart';

class WorkManagerNotificationService {
  static const String _taskReminderTask = 'taskReminderTask';
  static const String _dhikrReminderTask = 'dhikrReminderTask';
  static const String _duaReminderTask = 'duaReminderTask';
  static const String _dailyResetTask = 'dailyResetTask';
  
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  
  // Ensure we initialize WorkManager only once per app session
  static bool _initialized = false;
  
  static Future<void> initialize() async {
    if (_initialized) {
      debugPrint('✅ WorkManagerNotificationService already initialized, skipping');
      return;
    }
    try {
      debugPrint('🔄 Initializing WorkManager Notification Service...');
      
      // Initialize WorkManager with disabled debugging
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: false, // Disable debug notifications
      );
      
      // Clear any existing notifications to prevent queued notifications
      await _clearExistingNotifications();
      
      // Initialize the local notifications plugin
      await _initializeNotifications();
      
      // Schedule all background tasks silently (no immediate notifications)
      await _scheduleAllBackgroundTasksSilently();
      
      _initialized = true;
      debugPrint('✅ WorkManager Notification Service initialized');
    } catch (e) {
      debugPrint('❌ Error initializing WorkManager Notification Service: $e');
    }
  }
  
  static Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(initSettings);
    
    // Create notification channel with high priority
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'background_notifications',
      'Background Notifications',
      description: 'Notifications for background tasks',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
      enableLights: true,
    );
    
    await _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    // Create high-priority channel for critical notifications
    const AndroidNotificationChannel criticalChannel = AndroidNotificationChannel(
      'critical_notifications',
      'Critical Notifications',
      description: 'High-priority notifications that must be shown',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
      enableLights: true,
    );
    
    await _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(criticalChannel);
  }

  // Clear existing notifications to prevent queued notifications from appearing
  static Future<void> _clearExistingNotifications() async {
    try {
      debugPrint('🧹 Clearing existing notifications to prevent queued notifications...');
      
      // Cancel all existing notifications
      await _notifications.cancelAll();
      
      debugPrint('✅ Existing notifications cleared');
    } catch (e) {
      debugPrint('❌ Error clearing existing notifications: $e');
    }
  }

  // Schedule all background tasks silently (no immediate notifications)
  static Future<void> _scheduleAllBackgroundTasksSilently() async {
    try {
      debugPrint('🔄 Scheduling all background notification tasks silently...');
      
      // Schedule task reminders every 6 hours
      await _schedulePeriodicTask(
        _taskReminderTask,
        'Task Reminder',
        'Complete your daily Islamic tasks and earn rewards!',
        Duration(hours: 6),
      );
      
      // Schedule dhikr reminders at prayer times with automatic rescheduling
      await _scheduleDailyTaskWithRescheduling(
        _dhikrReminderTask,
        'Dhikr Reminder',
        'Time for dhikr and remembrance of Allah',
        [5, 13, 16, 19, 20], // 5:30, 13:00, 16:30, 19:00, 20:30
        [30, 0, 30, 0, 30],  // minutes
      );
      
      // Schedule dua reminders with automatic rescheduling
      await _scheduleDailyTaskWithRescheduling(
        _duaReminderTask,
        'Dua Reminder',
        'Recite your daily duas and supplications',
        [7, 18], // 7:00, 18:30
        [0, 30], // minutes
      );
      
      // Schedule daily reset with automatic rescheduling
      await _scheduleDailyTaskWithRescheduling(
        _dailyResetTask,
        'Daily Reset',
        'New day has begun! Reset your daily progress',
        [0], // 00:00
        [0], // minutes
      );
      
      debugPrint('✅ All background notification tasks scheduled silently');
    } catch (e) {
      debugPrint('❌ Error scheduling background tasks: $e');
    }
  }

  // Schedule all background tasks
  static Future<void> scheduleAllBackgroundTasks() async {
    try {
      debugPrint('🔄 Scheduling all background notification tasks...');
      
      // Schedule task reminders every 6 hours
      await _schedulePeriodicTask(
        _taskReminderTask,
        'Task Reminder',
        'Complete your daily Islamic tasks and earn rewards!',
        Duration(hours: 6),
      );
      
      // Schedule dhikr reminders at prayer times with automatic rescheduling
      await _scheduleDailyTaskWithRescheduling(
        _dhikrReminderTask,
        'Dhikr Reminder',
        'Time for dhikr and remembrance of Allah',
        [5, 13, 16, 19, 20], // 5:30, 13:00, 16:30, 19:00, 20:30
        [30, 0, 30, 0, 30],  // minutes
      );
      
      // Schedule dua reminders with automatic rescheduling
      await _scheduleDailyTaskWithRescheduling(
        _duaReminderTask,
        'Dua Reminder',
        'Recite your daily duas and supplications',
        [7, 18], // 7:00, 18:30
        [0, 30], // minutes
      );
      
      // Schedule daily reset with automatic rescheduling
      await _scheduleDailyTaskWithRescheduling(
        _dailyResetTask,
        'Daily Reset',
        'New day has begun! Reset your daily progress',
        [0], // 00:00
        [0], // minutes
      );
      
      debugPrint('✅ All background notification tasks scheduled successfully');
    } catch (e) {
      debugPrint('❌ Error scheduling background tasks: $e');
    }
  }

  // Schedule a periodic task (every X hours)
  static Future<void> _schedulePeriodicTask(
    String taskName,
    String title,
    String body,
    Duration interval,
  ) async {
    try {
      await Workmanager().registerPeriodicTask(
        taskName,
        taskName,
        frequency: interval,
        constraints: Constraints(
          networkType: NetworkType.not_required,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresDeviceIdle: false,
          requiresStorageNotLow: false,
        ),
        inputData: {
          'title': title,
          'body': body,
          'type': 'periodic',
        },
      );
      
      debugPrint('✅ Periodic task scheduled: $taskName every ${interval.inHours} hours');
    } catch (e) {
      debugPrint('❌ Error scheduling periodic task $taskName: $e');
    }
  }

  // Schedule daily tasks at specific times
  static Future<void> _scheduleDailyTask(
    String taskName,
    String title,
    String body,
    List<int> hours,
    List<int> minutes,
  ) async {
    try {
      for (int i = 0; i < hours.length; i++) {
        final hour = hours[i];
        final minute = minutes[i];
        
        // Calculate delay until next occurrence with fallback timezone handling
        tz.TZDateTime now;
        tz.TZDateTime scheduled;
        
        try {
          // Try to get timezone-specific time
          now = tz.TZDateTime.now(tz.getLocation('Asia/Bahrain'));
          scheduled = tz.TZDateTime(tz.getLocation('Asia/Bahrain'), now.year, now.month, now.day, hour, minute);
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
        
        final delay = scheduled.difference(now);
        
        // Schedule one-off task for this specific time
        await Workmanager().registerOneOffTask(
          '${taskName}_${hour}_${minute}',
          taskName,
          initialDelay: delay,
          constraints: Constraints(
            networkType: NetworkType.not_required,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresDeviceIdle: false,
            requiresStorageNotLow: false,
          ),
          inputData: {
            'title': title,
            'body': body,
            'type': 'daily',
            'hour': hour,
            'minute': minute,
          },
        );
        
        debugPrint('✅ Daily task scheduled: $taskName at ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
      }
    } catch (e) {
      debugPrint('❌ Error scheduling daily task $taskName: $e');
    }
  }

  // Schedule daily tasks with automatic daily rescheduling
  static Future<void> _scheduleDailyTaskWithRescheduling(
    String taskName,
    String title,
    String body,
    List<int> hours,
    List<int> minutes,
  ) async {
    try {
      for (int i = 0; i < hours.length; i++) {
        final hour = hours[i];
        final minute = minutes[i];
        
        // Calculate delay until next occurrence with fallback timezone handling
        tz.TZDateTime now;
        tz.TZDateTime scheduled;
        
        try {
          // Try to get timezone-specific time
          now = tz.TZDateTime.now(tz.getLocation('Asia/Bahrain'));
          scheduled = tz.TZDateTime(tz.getLocation('Asia/Bahrain'), now.year, now.month, now.day, hour, minute);
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
        
        final delay = scheduled.difference(now);
        
        // Schedule one-off task for this specific time
        await Workmanager().registerOneOffTask(
          '${taskName}_${hour}_${minute}',
          taskName,
          initialDelay: delay,
          constraints: Constraints(
            networkType: NetworkType.not_required,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresDeviceIdle: false,
            requiresStorageNotLow: false,
          ),
          inputData: {
            'title': title,
            'body': body,
            'type': 'daily',
            'hour': hour,
            'minute': minute,
            'reschedule': true, // Flag to indicate this should be rescheduled
          },
        );
        
        debugPrint('✅ Daily task scheduled: $taskName at ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
      }
    } catch (e) {
      debugPrint('❌ Error scheduling daily task $taskName: $e');
    }
  }

  // Ensure daily tasks are automatically rescheduled every day
  static Future<void> ensureDailyTasksRescheduled() async {
    try {
      debugPrint('🔄 Ensuring daily tasks are automatically rescheduled...');
      
      // Schedule a daily task that will reschedule all other daily tasks with fallback timezone handling
      tz.TZDateTime now;
      tz.TZDateTime scheduled;
      
      try {
        // Try to get timezone-specific time
        now = tz.TZDateTime.now(tz.getLocation('Asia/Bahrain'));
        scheduled = tz.TZDateTime(tz.getLocation('Asia/Bahrain'), now.year, now.month, now.day, 23, 59); // 11:59 PM
        debugPrint('✅ Timezone time retrieved successfully: $now');
      } catch (e) {
        debugPrint('⚠️ Timezone time failed, using system time: $e');
        // Create TZDateTime from system time as fallback
        final systemNow = DateTime.now();
        now = tz.TZDateTime.from(systemNow, tz.local);
        scheduled = tz.TZDateTime.from(DateTime(systemNow.year, systemNow.month, systemNow.day, 23, 59), tz.local); // 11:59 PM
      }
      
      // If time has passed today, schedule for tomorrow
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }
      
      final delay = scheduled.difference(now);
      
      // Schedule the rescheduler task
      await Workmanager().registerOneOffTask(
        'dailyReschedulerTask',
        'dailyReschedulerTask',
        initialDelay: delay,
        constraints: Constraints(
          networkType: NetworkType.not_required,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresDeviceIdle: false,
          requiresStorageNotLow: false,
        ),
        inputData: {
          'type': 'rescheduler',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      
      debugPrint('✅ Daily rescheduler task scheduled for ${scheduled.hour}:${scheduled.minute.toString().padLeft(2, '0')}');
      
    } catch (e) {
      debugPrint('❌ Error scheduling daily rescheduler: $e');
    }
  }

  // Remove all test notification methods - they are not needed for production
  // Only automated daily reminders should work

  // NUCLEAR OPTION: Maximum aggressive background notification strategy
  static Future<void> scheduleNuclearTestNotification() async {
    try {
      debugPrint('🚨 NUCLEAR OPTION: Scheduling maximum aggressive test notification');
      
      // Strategy 1: WorkManager with maximum priority
      await _scheduleWorkManagerNuclearTest();
      
      // Strategy 2: Schedule multiple backup notifications using local notifications
      await _scheduleNuclearBackupNotifications();
      
      debugPrint('🚨 NUCLEAR OPTION: All strategies deployed. Close app and wait 1 minute.');
      
    } catch (e) {
      debugPrint('❌ Error in nuclear option: $e');
    }
  }

  static Future<void> _scheduleWorkManagerNuclearTest() async {
    try {
      // Cancel any existing tasks
      await Workmanager().cancelAll();
      
      // Schedule primary task with maximum priority
      await Workmanager().registerOneOffTask(
        'nuclearTestTask',
        'nuclearTestTask',
        inputData: {
          'priority': 'maximum',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
        constraints: Constraints(
          networkType: NetworkType.connected,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresDeviceIdle: false,
          requiresStorageNotLow: false,
        ),
        initialDelay: const Duration(minutes: 1),
      );
      
      // Schedule backup task 5 seconds later
      await Workmanager().registerOneOffTask(
        'nuclearBackupTask',
        'nuclearBackupTask',
        inputData: {
          'priority': 'backup',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
        constraints: Constraints(
          networkType: NetworkType.connected,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresDeviceIdle: false,
          requiresStorageNotLow: false,
        ),
        initialDelay: const Duration(minutes: 1, seconds: 5),
      );
      
      // Schedule emergency task 10 seconds later
      await Workmanager().registerOneOffTask(
        'nuclearEmergencyTask',
        'nuclearEmergencyTask',
        inputData: {
          'priority': 'emergency',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
        constraints: Constraints(
          networkType: NetworkType.connected,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresDeviceIdle: false,
          requiresStorageNotLow: false,
        ),
        initialDelay: const Duration(minutes: 1, seconds: 10),
      );
      
      debugPrint('✅ Nuclear WorkManager tasks scheduled');
      
    } catch (e) {
      debugPrint('❌ Error scheduling nuclear WorkManager tasks: $e');
    }
  }

  static Future<void> _scheduleNuclearBackupNotifications() async {
    try {
      // Initialize notifications first
      await _initializeNotifications();
      
      // Create nuclear notification channel
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'nuclear_critical',
        'Nuclear Critical',
        description: 'Maximum priority notifications that must be shown',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
        enableLights: true,
      );
      
      await _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
      
      // Schedule multiple local notifications as backup
      final now = DateTime.now();
      final scheduledTime = now.add(const Duration(minutes: 1));
      
      // Primary nuclear notification
      await _notifications.zonedSchedule(
        9997,
        '🚨 NUCLEAR TEST',
        'This notification MUST appear even with app closed!',
        tz.TZDateTime.from(scheduledTime, tz.local),
        _getNuclearNotificationDetails(),
        androidAllowWhileIdle: true,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'nuclear_test',
      );
      
      // Emergency backup notification
      await _notifications.zonedSchedule(
        9996,
        '🚨 NUCLEAR EMERGENCY',
        'Emergency backup notification - must appear!',
        tz.TZDateTime.from(scheduledTime.add(const Duration(seconds: 5)), tz.local),
        _getNuclearNotificationDetails(),
        androidAllowWhileIdle: true,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'nuclear_emergency',
      );
      
      // Final backup notification
      await _notifications.zonedSchedule(
        9995,
        '🚨 NUCLEAR FINAL',
        'Final backup notification - last chance!',
        tz.TZDateTime.from(scheduledTime.add(const Duration(seconds: 10)), tz.local),
        _getNuclearNotificationDetails(),
        androidAllowWhileIdle: true,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'nuclear_final',
      );
      
      debugPrint('✅ Nuclear backup notifications scheduled');
      
    } catch (e) {
      debugPrint('❌ Error scheduling nuclear backup notifications: $e');
    }
  }

  static NotificationDetails _getNuclearNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'nuclear_critical',
        'Nuclear Critical',
        channelDescription: 'Maximum priority notifications that must be shown',
        importance: Importance.max,
        priority: Priority.max,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
        color: Color(0xFFFF0000),
        enableLights: true,
        category: AndroidNotificationCategory.reminder,
        fullScreenIntent: true, // Force display even when device is locked
        visibility: NotificationVisibility.public,
        actions: [
          AndroidNotificationAction('open', 'Open App'),
          AndroidNotificationAction('dismiss', 'Dismiss'),
        ],
        // Additional aggressive settings
        autoCancel: false, // Don't auto-cancel
        ongoing: true, // Make it persistent
      ),
    );
  }

  // Cancel all WorkManager tasks
  static Future<void> cancelAllTasks() async {
    try {
      await Workmanager().cancelAll();
      debugPrint('✅ All WorkManager tasks cancelled');
    } catch (e) {
      debugPrint('❌ Error cancelling WorkManager tasks: $e');
    }
  }

  // Force reschedule all tasks
  static Future<void> forceRescheduleAllTasks() async {
    try {
      debugPrint('🔄 Force rescheduling all background tasks...');
      
      // Cancel all existing tasks
      await Workmanager().cancelAll();
      
      // Wait a bit
      await Future.delayed(const Duration(seconds: 2));
      
      // Reschedule all tasks silently (no immediate notifications)
      await _scheduleAllBackgroundTasksSilently();
      
      // Ensure daily tasks are automatically rescheduled
      await ensureDailyTasksRescheduled();
      
      debugPrint('✅ All background tasks force rescheduled');
    } catch (e) {
      debugPrint('❌ Error force rescheduling tasks: $e');
    }
  }

  // Ensure notifications are automatically scheduled when app starts
  static Future<void> ensureNotificationsScheduled() async {
    try {
      debugPrint('🔄 Ensuring notifications are automatically scheduled...');
      
      // Check if we need to schedule tasks with fallback timezone handling
      tz.TZDateTime now;
      try {
        // Try to get timezone-specific time
        now = tz.TZDateTime.now(tz.getLocation('Asia/Bahrain'));
        debugPrint('✅ Timezone time retrieved successfully: $now');
      } catch (e) {
        debugPrint('⚠️ Timezone time failed, using system time: $e');
        // Create TZDateTime from system time as fallback
        final systemNow = DateTime.now();
        now = tz.TZDateTime.from(systemNow, tz.local);
      }
      
      final today = DateTime(now.year, now.month, now.day);
      
      // Get last scheduled date from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final lastScheduledDate = prefs.getString('last_notifications_scheduled');
      
      if (lastScheduledDate != null) {
        final lastDate = DateTime.parse(lastScheduledDate);
        final lastDay = DateTime(lastDate.year, lastDate.month, lastDate.day);
        
        // If we already scheduled for today, don't reschedule
        if (today.isAtSameMomentAs(lastDay)) {
          debugPrint('✅ Notifications already scheduled for today');
          return;
        }
      }
      
      // Schedule all tasks for today silently (no immediate notifications)
      await _scheduleAllBackgroundTasksSilently();
      
      // Ensure daily tasks are automatically rescheduled
      await ensureDailyTasksRescheduled();
      
      // Save the scheduled date
      await prefs.setString('last_notifications_scheduled', today.toIso8601String());
      
      debugPrint('✅ Notifications automatically scheduled for ${today.year}-${today.month}-${today.day}');
      
    } catch (e) {
      debugPrint('❌ Error ensuring notifications are scheduled: $e');
    }
  }

  // Check if notifications are properly scheduled
  static Future<Map<String, dynamic>> checkNotificationScheduleStatus() async {
    try {
      debugPrint('🔍 Checking notification schedule status...');
      
      // Get current time with fallback to system time if timezone fails
      tz.TZDateTime now;
      String timezoneInfo;
      
      try {
        // Try to get timezone-specific time
        now = tz.TZDateTime.now(tz.getLocation('Asia/Bahrain'));
        timezoneInfo = 'Asia/Bahrain (UTC+3)';
        debugPrint('✅ Timezone time retrieved successfully: $now');
      } catch (e) {
        debugPrint('⚠️ Timezone time failed, using system time: $e');
        // Create TZDateTime from system time as fallback
        final systemNow = DateTime.now();
        now = tz.TZDateTime.from(systemNow, tz.local);
        timezoneInfo = 'System Time (${systemNow.timeZoneName})';
      }
      
      final today = DateTime(now.year, now.month, now.day);
      
      // Get last scheduled date
      final prefs = await SharedPreferences.getInstance();
      final lastScheduledDate = prefs.getString('last_notifications_scheduled');
      
      final status = {
        'currentDate': today.toString(),
        'lastScheduledDate': lastScheduledDate ?? 'Never',
        'isScheduledForToday': lastScheduledDate != null && 
            DateTime.parse(lastScheduledDate).isAtSameMomentAs(today),
        'currentTimezone': timezoneInfo,
        'currentTime': now.toString(),
        'timestamp': DateTime.now().toString(),
      };
      
      debugPrint('📊 Notification Schedule Status: $status');
      return status;
      
    } catch (e) {
      debugPrint('❌ Error checking notification schedule status: $e');
      return {
        'error': e.toString(),
        'timestamp': DateTime.now().toString(),
      };
    }
  }

  // Request exact alarm permissions for Android 12+
  static Future<bool> requestExactAlarmPermission() async {
    try {
      debugPrint('🔍 Requesting exact alarm permission...');
      
      // Try to launch the exact alarm permission request
      final intent = AndroidIntent(action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM');
      await intent.launch();
      
      debugPrint('✅ Exact alarm permission request launched');
      return true;
    } catch (e) {
      debugPrint('❌ Error requesting exact alarm permission: $e');
      return false;
    }
  }

}

// Track shown notification IDs to prevent duplicates
final Set<int> _shownNotificationIds = <int>{};

// This function must be a top-level function
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('🔄 WorkManager executing task: $task');
    
    try {
      switch (task) {
        case 'taskReminderTask':
          await _handleTaskReminder(inputData);
          break;
        case 'dhikrReminderTask':
          await _handleDhikrReminder(inputData);
          break;
        case 'duaReminderTask':
          await _handleDuaReminder(inputData);
          break;
        case 'dailyResetTask':
          await _handleDailyReset(inputData);
          break;
        case 'nuclearTestTask':
          await _handleNuclearNotification(inputData);
          break;
        case 'nuclearBackupTask':
          await _handleNuclearNotification(inputData);
          break;
        case 'nuclearEmergencyTask':
          await _handleNuclearNotification(inputData);
          break;
        case 'dailyReschedulerTask':
          await _handleDailyRescheduler(inputData);
          break;
        default:
          // Check if this is a daily task that needs rescheduling
          if (task.contains('_') && inputData?['reschedule'] == true) {
            await _handleDailyTaskWithRescheduling(task, inputData);
          } else {
            debugPrint('⚠️ Unknown task: $task');
          }
      }
      
      debugPrint('✅ WorkManager task completed: $task');
      return true;
      
    } catch (e) {
      debugPrint('❌ WorkManager task failed: $task, Error: $e');
      return false;
    }
  });
}

Future<void> _handleTaskReminder(Map<String, dynamic>? inputData) async {
  await _showNotification(
    'Task Reminder',
    inputData?['body'] ?? 'Complete your daily Islamic tasks and earn rewards!',
    1001,
    isCritical: true,
  );
}

Future<void> _handleDhikrReminder(Map<String, dynamic>? inputData) async {
  await _showNotification(
    'Dhikr Reminder',
    inputData?['body'] ?? 'Time for dhikr and remembrance of Allah',
    2001,
    isCritical: true,
  );
}

Future<void> _handleDuaReminder(Map<String, dynamic>? inputData) async {
  await _showNotification(
    'Dua Reminder',
    inputData?['body'] ?? 'Recite your daily duas and supplications',
    3001,
    isCritical: true,
  );
}



Future<void> _handleDailyReset(Map<String, dynamic>? inputData) async {
  await _showNotification(
    'Daily Reset',
    inputData?['body'] ?? 'New day has begun! Reset your daily progress',
    4001,
    isCritical: true,
  );
}

Future<void> _handleNuclearNotification(Map<String, dynamic>? inputData) async {
  debugPrint('🚨 Nuclear notification triggered');
  final priority = inputData?['priority'];
  final title = priority == 'maximum' ? '🚨 NUCLEAR TEST' : priority == 'backup' ? '🚨 NUCLEAR EMERGENCY' : '🚨 NUCLEAR FINAL';
  final body = priority == 'maximum' ? 'This notification MUST appear even with app closed!' : priority == 'backup' ? 'Emergency backup notification - must appear!' : 'Final backup notification - last chance!';
  final id = priority == 'maximum' ? 9997 : priority == 'backup' ? 9996 : 9995;

  await _showNotification(
    title,
    body,
    id,
    isCritical: true,
  );
}

Future<void> _handleDailyRescheduler(Map<String, dynamic>? inputData) async {
  debugPrint('🔄 Daily rescheduler task triggered. Rescheduling daily tasks...');
  
  // Get the current date with fallback timezone handling
  tz.TZDateTime now;
  try {
    // Try to get timezone-specific time
    now = tz.TZDateTime.now(tz.getLocation('Asia/Bahrain'));
    debugPrint('✅ Timezone time retrieved successfully: $now');
  } catch (e) {
    debugPrint('⚠️ Timezone time failed, using system time: $e');
    // Create TZDateTime from system time as fallback
    final systemNow = DateTime.now();
    now = tz.TZDateTime.from(systemNow, tz.local);
  }
  
  final scheduledDate = now.add(const Duration(days: 1)); // Schedule for tomorrow
  
  // Reschedule dhikr reminders
  await WorkManagerNotificationService._scheduleDailyTaskWithRescheduling(
    'dhikrReminderTask',
    'Dhikr Reminder',
    'Time for dhikr and remembrance of Allah',
    [5, 13, 16, 19, 20], // 5:30, 13:00, 16:30, 19:00, 20:30
    [30, 0, 30, 0, 30],  // minutes
  );
  
  // Reschedule dua reminders
  await WorkManagerNotificationService._scheduleDailyTaskWithRescheduling(
    'duaReminderTask',
    'Dua Reminder',
    'Recite your daily duas and supplications',
    [7, 18], // 7:00, 18:30
    [0, 30], // minutes
  );
  
  // Reschedule daily reset
  await WorkManagerNotificationService._scheduleDailyTaskWithRescheduling(
    'dailyResetTask',
    'Daily Reset',
    'New day has begun! Reset your daily progress',
    [0], // 00:00
    [0], // minutes
  );
  
  // Reschedule the daily rescheduler for the next day
  await WorkManagerNotificationService.ensureDailyTasksRescheduled();
  
  debugPrint('✅ Daily tasks rescheduled for ${scheduledDate.year}-${scheduledDate.month}-${scheduledDate.day}');
}

Future<void> _handleDailyTaskWithRescheduling(String taskName, Map<String, dynamic>? inputData) async {
  debugPrint('🔄 Daily task with rescheduling triggered: $taskName');
  
  final hour = inputData?['hour'];
  final minute = inputData?['minute'];
  
  if (hour == null || minute == null) {
    debugPrint('❌ Missing hour or minute for rescheduling task: $taskName');
    return;
  }
  
  // Get the current date with fallback timezone handling
  tz.TZDateTime now;
  try {
    // Try to get timezone-specific time
    now = tz.TZDateTime.now(tz.getLocation('Asia/Bahrain'));
    debugPrint('✅ Timezone time retrieved successfully: $now');
  } catch (e) {
    debugPrint('⚠️ Timezone time failed, using system time: $e');
    // Create TZDateTime from system time as fallback
    final systemNow = DateTime.now();
    now = tz.TZDateTime.from(systemNow, tz.local);
  }
  
  final scheduledDate = now.add(const Duration(days: 1)); // Schedule for tomorrow
  
  // Calculate delay until next occurrence
  var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
  
  // If time has passed today, schedule for tomorrow
  if (scheduled.isBefore(now)) {
    scheduled = scheduled.add(const Duration(days: 1));
  }
  
  final delay = scheduled.difference(now);
  
  // Schedule one-off task for this specific time
  await Workmanager().registerOneOffTask(
    taskName,
    taskName,
    initialDelay: delay,
    constraints: Constraints(
      networkType: NetworkType.not_required,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresDeviceIdle: false,
      requiresStorageNotLow: false,
    ),
    inputData: {
      'title': inputData?['title'],
      'body': inputData?['body'],
      'type': 'daily',
      'hour': hour,
      'minute': minute,
      'reschedule': true, // Flag to indicate this should be rescheduled
    },
  );
  
  debugPrint('✅ Daily task rescheduled: $taskName at ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
}

Future<void> _showNotification(String title, String body, int id, {bool isCritical = false}) async {
  try {
    // Check if the app is in the foreground - if so, don't show notifications
    // This prevents notifications from appearing when the user opens the app
    if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
      debugPrint('🚫 App is in foreground, skipping notification: $title');
      return;
    }
    
    // Prevent duplicate notifications by using a set to track shown notifications
    // If this notification ID was already shown in the last 5 minutes, skip it
    if (_shownNotificationIds.contains(id)) {
      debugPrint('🚫 Notification already shown recently, skipping: $title (ID: $id)');
      return;
    }
    
    // Add to shown notifications and clean up after 5 minutes
    _shownNotificationIds.add(id);
    Future.delayed(const Duration(minutes: 5), () {
      _shownNotificationIds.remove(id);
    });
    
    // Initialize notifications
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    final FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();
    await notifications.initialize(initSettings);
    
    // Create notification channel based on priority
    final channelId = isCritical ? 'critical_notifications' : 'background_notifications';
    final channelName = isCritical ? 'Critical Notifications' : 'Background Notifications';
    
    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: 'High-priority notifications that must be shown',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
      enableLights: true,
    );
    
    await notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    
    // Create notification details with maximum priority
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: 'High-priority notifications that must be shown',
      importance: Importance.max,
      priority: Priority.max,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      icon: '@mipmap/ic_launcher',
      color: isCritical ? Color(0xFFFF0000) : Color(0xFF4CAF50),
      enableLights: true,
      category: AndroidNotificationCategory.reminder,
      fullScreenIntent: isCritical, // Force display even when device is locked
      visibility: NotificationVisibility.public,
      actions: [
        const AndroidNotificationAction('open', 'Open App'),
        const AndroidNotificationAction('dismiss', 'Dismiss'),
      ],
    );
    
    final NotificationDetails details = NotificationDetails(android: androidDetails);
    
    // Show the notification (only one attempt now to prevent duplicates)
    try {
      await notifications.show(id, title, body, details);
      debugPrint('✅ Background notification displayed: $title');
    } catch (e) {
      debugPrint('❌ Notification display failed: $e');
    }
    
  } catch (e) {
    debugPrint('❌ Error showing background notification: $e');
  }
} 