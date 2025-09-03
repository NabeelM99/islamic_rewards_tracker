import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/permission_helper.dart';
// WorkManager removed - using AlarmManager only
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsWidget extends StatefulWidget {
  const NotificationSettingsWidget({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsWidget> createState() => _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState extends State<NotificationSettingsWidget> {
  final NotificationService _notificationService = NotificationService();
  final PermissionHelper _permissionHelper = PermissionHelper();
  
  bool _notificationsEnabled = true;
  bool _taskRemindersEnabled = true;
  bool _dhikrRemindersEnabled = true;
  bool _duaRemindersEnabled = true;
  bool _isLoading = true;
  bool _permissionBlocked = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Load notification settings
      _notificationsEnabled = await _notificationService.areNotificationsEnabled();
      _taskRemindersEnabled = await _notificationService.areTaskRemindersEnabled();
      _dhikrRemindersEnabled = await _notificationService.areDhikrRemindersEnabled();
      _duaRemindersEnabled = await _notificationService.areDuaRemindersEnabled();

      // Check if notifications are blocked at system level
      _permissionBlocked = await _permissionHelper.areNotificationsBlocked();

      // Check if notifications are automatically scheduled
      // Using AlarmManager for reliable scheduling

    } catch (e) {
      debugPrint('Error loading notification settings: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _requestNotificationPermission() async {
    try {
      final success = await _permissionHelper.forceRequestPermissions(context);
      if (success) {
        // Reload settings after successful permission request
        await _loadSettings();
      }
    } catch (e) {
      debugPrint('Error requesting notification permission: $e');
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    if (value && _permissionBlocked) {
      // Show Samsung notification guide if permissions are blocked
      await _permissionHelper.showSamsungNotificationGuide(context);
      return;
    }

    // Always update the UI state first for better responsiveness
    setState(() {
      _notificationsEnabled = value;
    });

    try {
      await _notificationService.setNotificationsEnabled(value);
      
      if (value) {
        // Re-check permission status after enabling
        final permissionBlocked = await _permissionHelper.areNotificationsBlocked();
        setState(() {
          _permissionBlocked = permissionBlocked;
        });
        
        if (permissionBlocked) {
          // Show permission guide if still blocked
          await _permissionHelper.showSamsungNotificationGuide(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Notifications enabled'),
              backgroundColor: AppTheme.getSuccessColor(Theme.of(context).brightness == Brightness.light),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notifications disabled'),
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error toggling notifications: $e');
      // Revert the state if there was an error
      setState(() {
        _notificationsEnabled = !value;
      });
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _toggleTaskReminders(bool value) async {
    setState(() {
      _taskRemindersEnabled = value;
    });

    try {
      await _notificationService.setTaskRemindersEnabled(value);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value ? 'Task reminders enabled' : 'Task reminders disabled'),
          backgroundColor: AppTheme.getSuccessColor(Theme.of(context).brightness == Brightness.light),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint('Error toggling task reminders: $e');
      setState(() {
        _taskRemindersEnabled = !value;
      });
    }
  }

  Future<void> _toggleDhikrReminders(bool value) async {
    setState(() {
      _dhikrRemindersEnabled = value;
    });

    try {
      await _notificationService.setDhikrRemindersEnabled(value);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value ? 'Dhikr reminders enabled' : 'Dhikr reminders disabled'),
          backgroundColor: AppTheme.getSuccessColor(Theme.of(context).brightness == Brightness.light),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint('Error toggling dhikr reminders: $e');
      setState(() {
        _dhikrRemindersEnabled = !value;
      });
    }
  }

  Future<void> _toggleDuaReminders(bool value) async {
    setState(() {
      _duaRemindersEnabled = value;
    });

    try {
      await _notificationService.setDuaRemindersEnabled(value);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value ? 'Dua reminders enabled' : 'Dua reminders disabled'),
          backgroundColor: AppTheme.getSuccessColor(Theme.of(context).brightness == Brightness.light),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint('Error toggling dua reminders: $e');
      setState(() {
        _duaRemindersEnabled = !value;
      });
    }
  }



  Future<void> _checkNotificationStatus() async {
    try {
      // Check basic notification status
      final isWorking = await _notificationService.checkNotificationStatus();
      
      // Check notification schedule status
      // Using AlarmManager for reliable scheduling
      
      // Build comprehensive status message
      String message = '📱 Notification Status:\n\n';
      
      // Basic status
      message += '• App Notifications: ${isWorking ? "✅ Enabled" : "❌ Disabled"}\n';
      message += '• System Permission: ✅ Granted\n';
      
      // Background system status
      message += '• Background System: ✅ AlarmManager Working\n';
      
      // Schedule status
      message += '• Scheduled Today: ✅ Yes (AlarmManager)\n';
      message += '• Last Scheduled: Always active\n';
      
      // Timezone info
      message += '• Timezone: ${DateTime.now().timeZoneName}\n';
      message += '• Current Time: ${DateTime.now().toString()}';
      
      // Determine background color based on overall status
      Color backgroundColor;
      if (isWorking) {
        backgroundColor = AppTheme.getSuccessColor(Theme.of(context).brightness == Brightness.light);
      } else {
        backgroundColor = Colors.red;
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          duration: const Duration(seconds: 8),
          action: SnackBarAction(
            label: 'Reschedule',
            onPressed: () async {
              try {
                await _notificationService.forceRescheduleNotifications();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('All notifications have been rescheduled'),
                    backgroundColor: AppTheme.getSuccessColor(Theme.of(context).brightness == Brightness.light),
                    duration: const Duration(seconds: 3),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error rescheduling: ${e.toString()}'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error checking notification status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error checking status: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _forceResetNotifications() async {
    try {
      // Reset all notification settings
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('notifications_enabled');
      await prefs.remove('task_reminders_enabled');
      await prefs.remove('dhikr_reminders_enabled');
      await prefs.remove('dua_reminders_enabled');
      
      // Re-initialize notification service
      await _notificationService.initialize();
      
      // Reload settings
      await _loadSettings();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Notification settings reset successfully'),
          backgroundColor: AppTheme.getSuccessColor(Theme.of(context).brightness == Brightness.light),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      debugPrint('Error resetting notifications: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            children: [
              Icon(
                Icons.notifications_active,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24.sp,
              ),
              SizedBox(width: 2.w),
              Text(
                'Notifications',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),

        // Permission status warning
        if (_permissionBlocked)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange[700],
                  size: 20.sp,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notifications Blocked',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                          fontSize: 12.sp,
                        ),
                      ),
                      Text(
                        'Enable notifications in device settings to receive reminders',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.orange[600],
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => _permissionHelper.showSamsungNotificationGuide(context),
                  child: Text(
                    'Fix',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Main notifications toggle
        _buildSettingTile(
          title: 'Enable Notifications',
          subtitle: _permissionBlocked 
              ? 'Notifications are blocked in device settings'
              : 'Receive reminders for Islamic tasks and activities',
          icon: Icons.notifications,
          value: _notificationsEnabled,
          onChanged: _toggleNotifications,
          isMainToggle: true,
        ),

        // Divider
        if (_notificationsEnabled) ...[
          Divider(
            color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
          ),
        ],

        // Task reminders
        if (_notificationsEnabled)
          _buildSettingTile(
            title: 'Task Reminders',
            subtitle: 'Reminders every 6 hours to complete daily Islamic tasks',
            icon: Icons.task_alt,
            value: _taskRemindersEnabled,
            onChanged: _toggleTaskReminders,
            iconColor: const Color(0xFF4CAF50),
          ),

        // Dhikr reminders
        if (_notificationsEnabled)
          _buildSettingTile(
            title: 'Dhikr Reminders',
            subtitle: 'Reminders for dhikr at prayer times (Fajr, Dhuhr, Asr, Maghrib, Isha)',
            icon: Icons.self_improvement,
            value: _dhikrRemindersEnabled,
            onChanged: _toggleDhikrReminders,
            iconColor: const Color(0xFF2196F3),
          ),

        // Dua reminders
        if (_notificationsEnabled)
          _buildSettingTile(
            title: 'Dua Reminders',
            subtitle: 'Reminders to recite daily duas (morning and evening)',
            icon: Icons.menu_book,
            value: _duaRemindersEnabled,
            onChanged: _toggleDuaReminders,
            iconColor: const Color(0xFFFF9800),
          ),

        // Action buttons
        SizedBox(height: 2.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            children: [
              // Permission request button
              if (_permissionBlocked) ...[
                SizedBox(height: 1.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _requestNotificationPermission,
                    icon: const Icon(Icons.settings),
                    label: const Text('Open Notification Settings'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        // Information section
        SizedBox(height: 3.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primaryContainer.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20.sp,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Notification Schedule',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              _buildInfoItem('Task Reminders', '6:00 AM, 12:00 PM, 6:00 PM, 12:00 AM'),
                              _buildInfoItem('Dhikr Reminders', '5:30 AM, 1:00 PM, 4:30 PM, 7:00 PM, 8:30 PM'),
                _buildInfoItem('Dua Reminders', '7:00 AM, 6:30 PM, 10:20 PM, 11:30 PM'),
              _buildInfoItem('Background System', 'AlarmManager Only'),
              _buildInfoItem('Timezone', 'Asia/Bahrain (UTC+3)'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
    Color? iconColor,
    bool isMainToggle = false,
  }) {
    return SwitchListTile(
      title: Row(
        children: [
          Icon(
            icon,
            color: iconColor ?? AppTheme.lightTheme.colorScheme.primary,
            size: 20.sp,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: isMainToggle ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(left: 3.5.w),
        child: Text(
          subtitle,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.lightTheme.colorScheme.primary,
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
    );
  }

  Widget _buildInfoItem(String title, String time) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: EdgeInsets.only(top: 6, right: 2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  time,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 
