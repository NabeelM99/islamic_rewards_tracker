# Islamic Rewards Tracker - Notification System

## Overview

The Islamic Rewards Tracker app now includes a comprehensive notification system that helps users stay on track with their daily Islamic tasks, dhikr, and duas. The system provides intelligent reminders that adapt based on task completion status.

## Features

### 🎯 Task Reminders (Every 6 Hours)
- **Schedule**: 6:00 AM, 12:00 PM, 6:00 PM, 12:00 AM
- **Purpose**: Remind users to complete their daily Islamic tasks
- **Smart Behavior**: Stops when all tasks are completed for the day
- **Resumes**: Automatically resumes the next day

### 🕌 Dhikr Reminders (Prayer Times)
- **Schedule**: 5:30 AM (Fajr), 1:00 PM (Dhuhr), 4:30 PM (Asr), 7:00 PM (Maghrib), 8:30 PM (Isha)
- **Purpose**: Remind users to perform dhikr at appropriate times
- **Continuous**: Runs daily regardless of task completion

### 📖 Dua Reminders (Morning & Evening)
- **Schedule**: 7:00 AM (Morning), 6:30 PM (Evening)
- **Purpose**: Remind users to recite daily duas and supplications
- **Continuous**: Runs daily regardless of task completion

### 🎉 Completion Notifications
- **Trigger**: When all daily tasks are completed
- **Message**: Congratulatory notification with Islamic greeting
- **Behavior**: One-time notification per day

## Technical Implementation

### Dependencies Added
```yaml
flutter_local_notifications: ^17.2.2
timezone: ^0.9.4
permission_handler: ^11.3.1
```

### Core Components

#### 1. NotificationService (`lib/core/services/notification_service.dart`)
- Manages all notification scheduling and display
- Handles permission requests
- Creates notification channels for Android
- Provides methods for enabling/disabling different notification types

#### 2. TaskNotificationManager (`lib/core/services/task_notification_manager.dart`)
- Tracks task completion status
- Manages 6-hour reminder cycle
- Handles completion notifications
- Resets daily task counts at midnight

#### 3. NotificationSettingsWidget (`lib/presentation/settings_screen/widgets/notification_settings_widget.dart`)
- User interface for managing notification preferences
- Individual toggles for each notification type
- Test notification functionality
- Schedule information display

### Android Configuration

#### Permissions Added
```xml
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

#### Notification Channels
- **Channel ID**: `islamic_rewards_channel`
- **Importance**: High
- **Features**: Sound, Vibration, Lights, Badge
- **Actions**: Quick action buttons for common responses

## User Experience

### Settings Screen
Users can access notification settings through:
1. Open the app
2. Navigate to Settings (bottom navigation)
3. Scroll to the "Notifications" section

### Available Settings
- **Enable Notifications**: Master toggle for all notifications
- **Task Reminders**: Toggle for 6-hour task reminders
- **Dhikr Reminders**: Toggle for prayer time dhikr reminders
- **Dua Reminders**: Toggle for morning/evening dua reminders
- **Test Notification**: Send a test notification to verify setup

### Notification Actions
- **Task Reminders**: "Complete Tasks" | "Snooze 1 Hour"
- **Dhikr Reminders**: "Start Dhikr" | "Snooze 30 Min"
- **Dua Reminders**: "Recite Dua" | "Snooze 15 Min"

## Smart Features

### Adaptive Scheduling
- Notifications automatically adjust based on task completion
- Task reminders stop when all tasks are completed
- Dhikr and dua reminders continue regardless of task status
- Daily reset at midnight for fresh start

### Permission Handling
- Automatic permission requests on first app launch
- Graceful handling of denied permissions
- Clear user feedback for permission status

### Battery Optimization
- Uses exact alarms for precise timing
- Respects device battery optimization settings
- Efficient scheduling to minimize battery impact

## Customization

### Notification Sounds
To add custom notification sounds:
1. Place audio files in `android/app/src/main/res/raw/`
2. Supported formats: `.wav`, `.mp3`, `.ogg`
3. Recommended file names:
   - `notification_sound.wav` (task reminders)
   - `dhikr_sound.wav` (dhikr reminders)
   - `dua_sound.wav` (dua reminders)

### Timing Adjustments
To modify notification times, edit the schedule arrays in `NotificationService`:
```dart
// Task reminders (every 6 hours)
final times = [
  tz.TZDateTime(tz.local, now.year, now.month, now.day, 6, 0),
  tz.TZDateTime(tz.local, now.year, now.month, now.day, 12, 0),
  tz.TZDateTime(tz.local, now.year, now.month, now.day, 18, 0),
  tz.TZDateTime(tz.local, now.year, now.month, now.day, 0, 0).add(const Duration(days: 1)),
];
```

## Testing

### Test Notifications
1. Go to Settings → Notifications
2. Tap "Send Test Notification"
3. Verify notification appears with proper sound and vibration

### Debug Information
- Check console logs for notification scheduling
- Monitor notification permissions in device settings
- Verify timezone settings for accurate scheduling

## Troubleshooting

### Common Issues

#### Notifications Not Appearing
1. Check notification permissions in device settings
2. Verify app is not battery optimized
3. Ensure notification channel is created
4. Check if Do Not Disturb mode is enabled

#### Incorrect Timing
1. Verify device timezone settings
2. Check if device time is set correctly
3. Ensure app has proper timezone permissions

#### Missing Sounds
1. Verify sound files are in correct directory
2. Check file format compatibility
3. Ensure device volume is not muted

### Debug Commands
```bash
# Check notification permissions
adb shell dumpsys notification | grep islamic_rewards

# View scheduled alarms
adb shell dumpsys alarm | grep islamic_rewards

# Test notification manually
adb shell am broadcast -a com.android.systemui.action.NOTIFICATION_TEST
```

## Future Enhancements

### Planned Features
- [ ] Custom notification sounds per category
- [ ] Prayer time-based notifications (using prayer time APIs)
- [ ] Notification history and statistics
- [ ] Smart snooze based on user behavior
- [ ] Notification grouping and priority management
- [ ] Offline notification scheduling
- [ ] Cross-device notification sync

### Integration Opportunities
- [ ] Prayer time APIs for accurate timing
- [ ] Islamic calendar integration
- [ ] Location-based prayer time adjustments
- [ ] Wearable device notifications
- [ ] Smart home integration

## Support

For issues or questions about the notification system:
1. Check the troubleshooting section above
2. Review device-specific notification settings
3. Test with the built-in test notification feature
4. Contact support with detailed device information

---

**Note**: This notification system is designed to be respectful and non-intrusive while helping users maintain their Islamic practices. All notifications include appropriate Islamic greetings and are scheduled at respectful times. 