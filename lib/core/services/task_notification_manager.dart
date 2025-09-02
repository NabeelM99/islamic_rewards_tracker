import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'notification_service.dart';

class TaskNotificationManager {
  static final TaskNotificationManager _instance = TaskNotificationManager._internal();
  factory TaskNotificationManager() => _instance;
  TaskNotificationManager._internal();

  final NotificationService _notificationService = NotificationService();
  
  // Shared preferences keys
  static const String _lastTaskCompletionKey = 'last_task_completion';
  static const String _tasksCompletedTodayKey = 'tasks_completed_today';
  static const String _lastNotificationDateKey = 'last_notification_date';

  /// Check if all tasks are completed for today
  Future<bool> areAllTasksCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksCompletedToday = prefs.getInt(_tasksCompletedTodayKey) ?? 0;
    
    // Assuming there are 7 main tasks (Morning Adhkar, Evening Adhkar, etc.)
    return tasksCompletedToday >= 7;
  }

  /// Mark a task as completed and update notification schedule
  Future<void> markTaskCompleted(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    
    // Update completion count for today
    final today = DateTime(now.year, now.month, now.day);
    final lastCompletionDate = prefs.getString(_lastTaskCompletionKey);
    
    if (lastCompletionDate != null) {
      final lastDate = DateTime.parse(lastCompletionDate);
      final lastDay = DateTime(lastDate.year, lastDate.month, lastDate.day);
      
      if (today.isAtSameMomentAs(lastDay)) {
        // Same day, increment count
        final currentCount = prefs.getInt(_tasksCompletedTodayKey) ?? 0;
        await prefs.setInt(_tasksCompletedTodayKey, currentCount + 1);
      } else {
        // New day, reset count
        await prefs.setInt(_tasksCompletedTodayKey, 1);
      }
    } else {
      // First completion
      await prefs.setInt(_tasksCompletedTodayKey, 1);
    }
    
    // Update last completion time
    await prefs.setString(_lastTaskCompletionKey, now.toIso8601String());
    
    // Check if all tasks are completed
    final allCompleted = await areAllTasksCompleted();
    if (allCompleted) {
      await _onAllTasksCompleted();
    } else {
      await _scheduleNextReminder();
    }
  }

  /// Handle when all tasks are completed
  Future<void> _onAllTasksCompleted() async {
    debugPrint('All tasks completed for today!');
    
    // Cancel task reminders for today
    await _notificationService.cancelAllNotifications();
    
    // Show completion notification
    await _showCompletionNotification();
    
    // Schedule tomorrow's reminders
    await _scheduleTomorrowReminders();
  }

  /// Schedule the next reminder (6 hours from now)
  Future<void> _scheduleNextReminder() async {
    final now = DateTime.now();
    final nextReminder = now.add(const Duration(hours: 6));
    
    // Only schedule if it's still today
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    
    if (nextReminder.isBefore(tomorrow)) {
      await _notificationService.scheduleTaskReminders();
    }
  }

  /// Schedule reminders for tomorrow
  Future<void> _scheduleTomorrowReminders() async {
    // Schedule all notifications for tomorrow
    await _notificationService.scheduleAllNotifications();
  }

  /// Show completion notification
  Future<void> _showCompletionNotification() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastNotificationDateKey, DateTime.now().toIso8601String());
    
    // Show a congratulatory notification
    await _notificationService.show(
      9998,
      '🎉 All Tasks Completed!',
      'Congratulations! You have completed all your Islamic tasks for today. May Allah accept your efforts!',
      null, // Use default notification details
    );
  }

  /// Reset daily task count (called at midnight)
  Future<void> resetDailyTaskCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tasksCompletedTodayKey, 0);
    
    // Schedule new notifications for the new day
    await _notificationService.scheduleAllNotifications();
  }

  /// Get today's completion count
  Future<int> getTodayCompletionCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_tasksCompletedTodayKey) ?? 0;
  }

  /// Check if it's a new day and reset if needed
  Future<void> checkAndResetDailyCount() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCompletionDate = prefs.getString(_lastTaskCompletionKey);
    
    if (lastCompletionDate != null) {
      final lastDate = DateTime.parse(lastCompletionDate);
      final now = DateTime.now();
      final lastDay = DateTime(lastDate.year, lastDate.month, lastDate.day);
      final today = DateTime(now.year, now.month, now.day);
      
      if (!today.isAtSameMomentAs(lastDay)) {
        // New day, reset count
        await resetDailyTaskCount();
      }
    }
  }

  /// Initialize the notification manager
  Future<void> initialize() async {
    await checkAndResetDailyCount();
    await _notificationService.scheduleAllNotifications();
  }

  /// Get completion percentage for today
  Future<double> getCompletionPercentage() async {
    final completed = await getTodayCompletionCount();
    const totalTasks = 7; // Total number of main tasks
    return (completed / totalTasks).clamp(0.0, 1.0);
  }

  /// Get remaining tasks count
  Future<int> getRemainingTasksCount() async {
    final completed = await getTodayCompletionCount();
    const totalTasks = 7;
    return (totalTasks - completed).clamp(0, totalTasks);
  }

  /// Check if notifications should be shown based on completion status
  Future<bool> shouldShowNotifications() async {
    final allCompleted = await areAllTasksCompleted();
    return !allCompleted;
  }

  /// Update notification schedule based on current completion status
  Future<void> updateNotificationSchedule() async {
    final shouldShow = await shouldShowNotifications();
    
    if (shouldShow) {
      await _notificationService.scheduleTaskReminders();
    } else {
      // All tasks completed, cancel task reminders but keep other notifications
      await _notificationService.cancelAllNotifications();
      await _notificationService.scheduleDhikrReminders();
      await _notificationService.scheduleDuaReminders();
    }
  }
} 