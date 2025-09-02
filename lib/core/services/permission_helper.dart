import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionHelper {
  static final PermissionHelper _instance = PermissionHelper._internal();
  factory PermissionHelper() => _instance;
  PermissionHelper._internal();

  static const String _permissionRequestedKey = 'notification_permission_requested';
  static const String _permissionDeniedKey = 'notification_permission_denied';

  /// Request notification permissions with Samsung-specific handling
  Future<bool> requestNotificationPermissions(BuildContext context) async {
    try {
      // Check current permission status
      final status = await Permission.notification.status;
      
      if (status.isGranted) {
        debugPrint('✅ Notification permission already granted');
        return true;
      }

      if (status.isDenied) {
        // Request permission
        final result = await Permission.notification.request();
        
        if (result.isGranted) {
          debugPrint('✅ Notification permission granted');
          await _savePermissionStatus(true);
          return true;
        } else {
          debugPrint('❌ Notification permission denied');
          await _savePermissionStatus(false);
          await _showPermissionDialog(context, 'Permission Denied');
          return false;
        }
      }

      if (status.isPermanentlyDenied) {
        debugPrint('❌ Notification permission permanently denied');
        await _savePermissionStatus(false);
        await _showPermissionDialog(context, 'Permission Permanently Denied');
        return false;
      }

      return false;
    } catch (e) {
      debugPrint('❌ Error requesting notification permission: $e');
      return false;
    }
  }

  /// Check if notifications are blocked on Samsung devices
  Future<bool> areNotificationsBlocked() async {
    try {
      final status = await Permission.notification.status;
      return status.isDenied || status.isPermanentlyDenied;
    } catch (e) {
      debugPrint('❌ Error checking notification status: $e');
      return true;
    }
  }

  /// Force request permissions with detailed logging
  Future<bool> forceRequestPermissions(BuildContext context) async {
    try {
      debugPrint('🔄 Force requesting notification permissions...');
      
      // Check current status
      final currentStatus = await Permission.notification.status;
      debugPrint('Current permission status: $currentStatus');
      
      if (currentStatus.isGranted) {
        debugPrint('✅ Permissions already granted');
        return true;
      }
      
      // Request permission
      final result = await Permission.notification.request();
      debugPrint('Permission request result: $result');
      
      if (result.isGranted) {
        debugPrint('✅ Permission granted successfully');
        await _savePermissionStatus(true);
        return true;
      } else {
        debugPrint('❌ Permission request failed: $result');
        await _savePermissionStatus(false);
        
        // Show detailed error dialog
        await _showDetailedPermissionDialog(context, result);
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error in force request permissions: $e');
      return false;
    }
  }

  /// Check exact alarm permission status
  Future<Map<String, dynamic>> checkExactAlarmPermission() async {
    try {
      debugPrint('🔍 Checking exact alarm permission...');
      
      // Check if exact alarm permission is available (Android 12+)
      bool exactAlarmAvailable = false;
      bool exactAlarmGranted = false;
      
      try {
        // Try to check exact alarm permission
        final status = await Permission.scheduleExactAlarm.status;
        exactAlarmAvailable = true;
        exactAlarmGranted = status.isGranted;
        debugPrint('Exact alarm permission status: $status');
      } catch (e) {
        debugPrint('Exact alarm permission not available on this device: $e');
        exactAlarmAvailable = false;
      }
      
      // Check notification permission
      final notificationStatus = await Permission.notification.status;
      
      final result = {
        'exactAlarmAvailable': exactAlarmAvailable,
        'exactAlarmGranted': exactAlarmGranted,
        'notificationPermission': notificationStatus.toString(),
        'deviceInfo': {
          'androidVersion': await _getAndroidVersion(),
          'manufacturer': await _getDeviceManufacturer(),
        },
        'timestamp': DateTime.now().toString(),
      };
      
      debugPrint('📊 Exact Alarm Permission Status: $result');
      return result;
      
    } catch (e) {
      debugPrint('❌ Error checking exact alarm permission: $e');
      return {
        'error': e.toString(),
        'timestamp': DateTime.now().toString(),
      };
    }
  }

  /// Get Android version (simplified)
  Future<String> _getAndroidVersion() async {
    try {
      // This is a simplified version - in a real app you'd use device_info_plus
      return 'Android (version info not available)';
    } catch (e) {
      return 'Unknown';
    }
  }

  /// Get device manufacturer (simplified)
  Future<String> _getDeviceManufacturer() async {
    try {
      // This is a simplified version - in a real app you'd use device_info_plus
      return 'Unknown';
    } catch (e) {
      return 'Unknown';
    }
  }

  /// Show permission dialog with Samsung-specific instructions
  Future<void> _showPermissionDialog(BuildContext context, String title) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.notifications_off,
              color: Colors.orange,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To receive Islamic task reminders, please enable notifications:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('1. Go to your device Settings'),
            Text('2. Find "Apps" or "Application Manager"'),
            Text('3. Search for "Islamic Rewards Tracker"'),
            Text('4. Tap "Notifications"'),
            Text('5. Enable "Allow notifications"'),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 Samsung Device Tip:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'If notifications are still blocked, also check:\n• "Do not disturb" settings\n• "Battery optimization" settings\n• "App permissions" in Samsung settings',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// Show detailed permission dialog with specific instructions
  Future<void> _showDetailedPermissionDialog(BuildContext context, PermissionStatus status) async {
    String title = 'Permission Issue';
    String message = 'Unable to enable notifications.';
    
    switch (status) {
      case PermissionStatus.denied:
        title = 'Permission Denied';
        message = 'Please allow notifications when prompted.';
        break;
      case PermissionStatus.permanentlyDenied:
        title = 'Permission Permanently Denied';
        message = 'Notifications are blocked in device settings. Please enable them manually.';
        break;
      case PermissionStatus.restricted:
        title = 'Permission Restricted';
        message = 'Notifications are restricted by device settings or parental controls.';
        break;
      default:
        title = 'Permission Issue';
        message = 'Unable to enable notifications. Please check device settings.';
    }
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.notifications_off,
              color: Colors.red,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            SizedBox(height: 16),
            Text(
              'To fix this issue:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('1. Go to Settings > Apps > Islamic Rewards Tracker'),
            Text('2. Tap "Notifications"'),
            Text('3. Enable "Allow notifications"'),
            Text('4. Enable "Show notifications"'),
            Text('5. Enable "Sound" and "Vibration"'),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 Additional Settings to Check:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '• Do Not Disturb settings\n• Battery optimization\n• App permissions in Samsung settings\n• Lock screen notifications',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// Show Samsung-specific notification settings guide
  Future<void> showSamsungNotificationGuide(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.phone_android,
              color: Colors.blue,
              size: 24,
            ),
            SizedBox(width: 8),
            Text('Samsung Notification Setup'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Follow these steps to enable notifications on your Samsung device:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildStep('1', 'Open Settings app'),
              _buildStep('2', 'Tap "Apps" or "Application Manager"'),
              _buildStep('3', 'Find "Islamic Rewards Tracker"'),
              _buildStep('4', 'Tap "Notifications"'),
              _buildStep('5', 'Enable "Allow notifications"'),
              _buildStep('6', 'Enable "Show notifications"'),
              _buildStep('7', 'Enable "Sound" and "Vibration"'),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🔧 Additional Samsung Settings:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[700],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '• Settings → Notifications → App notifications\n• Settings → Battery → App power management\n• Settings → Do not disturb → Apps\n• Settings → Lock screen → Notifications',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Got it'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(description),
          ),
        ],
      ),
    );
  }

  /// Save permission status
  Future<void> _savePermissionStatus(bool granted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_permissionRequestedKey, true);
    await prefs.setBool(_permissionDeniedKey, !granted);
  }

  /// Check if permission was previously requested
  Future<bool> wasPermissionRequested() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_permissionRequestedKey) ?? false;
  }

  /// Check if permission was previously denied
  Future<bool> wasPermissionDenied() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_permissionDeniedKey) ?? false;
  }

  /// Reset permission status (for testing)
  Future<void> resetPermissionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_permissionRequestedKey);
    await prefs.remove(_permissionDeniedKey);
  }
} 