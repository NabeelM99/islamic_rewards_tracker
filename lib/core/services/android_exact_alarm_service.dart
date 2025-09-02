import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class AndroidExactAlarmService {
  static const MethodChannel _channel = MethodChannel('exact_alarm_service');
  
  /// Check if exact alarm permission is granted (Android 12+)
  static Future<bool> canScheduleExactAlarms() async {
    try {
      if (await Permission.scheduleExactAlarm.isDenied) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Request exact alarm permission
  static Future<bool> requestExactAlarmPermission() async {
    try {
      final status = await Permission.scheduleExactAlarm.request();
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }
  
  /// Check if battery optimization is disabled
  static Future<bool> isIgnoringBatteryOptimizations() async {
    try {
      final status = await Permission.ignoreBatteryOptimizations.status;
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }
  
  /// Request to ignore battery optimization
  static Future<bool> requestIgnoreBatteryOptimizations() async {
    try {
      final status = await Permission.ignoreBatteryOptimizations.request();
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }
  
  /// Start the alarm scheduler
  static Future<bool> startAlarmScheduler() async {
    try {
      final result = await _channel.invokeMethod('startService');
      return result == true;
    } on PlatformException catch (e) {
      print('Error starting alarm scheduler: $e');
      return false;
    }
  }
  
  /// Schedule all reminders using exact alarms
  static Future<bool> scheduleAllReminders() async {
    try {
      final result = await _channel.invokeMethod('scheduleAll');
      return result == true;
    } on PlatformException catch (e) {
      print('Error scheduling reminders: $e');
      return false;
    }
  }
  
  /// Schedule specific reminder types
  static Future<bool> scheduleTaskReminders() async {
    try {
      final result = await _channel.invokeMethod('scheduleTaskReminders');
      return result == true;
    } on PlatformException catch (e) {
      print('Error scheduling task reminders: $e');
      return false;
    }
  }
  
  static Future<bool> scheduleDhikrReminders() async {
    try {
      final result = await _channel.invokeMethod('scheduleDhikrReminders');
      return result == true;
    } on PlatformException catch (e) {
      print('Error scheduling dhikr reminders: $e');
      return false;
    }
  }
  
  static Future<bool> scheduleDuaReminders() async {
    try {
      final result = await _channel.invokeMethod('scheduleDuaReminders');
      return result == true;
    } on PlatformException catch (e) {
      print('Error scheduling dua reminders: $e');
      return false;
    }
  }
  
  /// Stop the alarm scheduler
  static Future<bool> stopAlarmScheduler() async {
    try {
      final result = await _channel.invokeMethod('stopService');
      return result == true;
    } on PlatformException catch (e) {
      print('Error stopping alarm scheduler: $e');
      return false;
    }
  }
  
  /// Check service status
  static Future<Map<String, dynamic>> getServiceStatus() async {
    try {
      final result = await _channel.invokeMethod('getStatus');
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      return {
        'running': false,
        'error': e.message ?? 'Unknown error',
        'exactAlarmPermission': false,
        'batteryOptimizationDisabled': false,
      };
    }
  }
  
  /// Get scheduled alarms
  static Future<List<Map<String, dynamic>>> getScheduledAlarms() async {
    try {
      final result = await _channel.invokeMethod('getScheduledAlarms');
      return List<Map<String, dynamic>>.from(result);
    } on PlatformException catch (e) {
      print('Error getting scheduled alarms: $e');
      return [];
    }
  }
} 