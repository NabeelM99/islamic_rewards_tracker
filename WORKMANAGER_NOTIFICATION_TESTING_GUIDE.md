# WorkManager Notification Testing Guide

## Overview
This guide explains how to test the new WorkManager-based notification system that should provide reliable background notifications even when the app is closed.

## What Was Fixed
1. **Removed incompatible parameters** from WorkManager calls (`uniqueName`, `cancelByUniqueName`)
2. **Implemented robust background notification system** using WorkManager
3. **Added comprehensive testing tools** in the settings screen
4. **Integrated WorkManager with local notifications** for maximum reliability

## How to Test

### 1. Basic Test (Immediate)
- Go to **Settings** → **Notifications**
- Click **"Test Immediate Notification"** (green button)
- Should show notification immediately

### 2. Quick Background Test (1 minute)
- Go to **Settings** → **Notifications**
- Click **"Quick Test (1 min) - Close App to Test"** (orange button)
- **IMPORTANT**: Close the app completely (swipe it away from recent apps)
- Wait 1 minute
- Notification should appear even with app closed

### 3. Standard Background Test (2 minutes)
- Go to **Settings** → **Notifications**
- Click **"Schedule WorkManager Test (2 min from now)"** (purple button)
- Close the app completely
- Wait 2 minutes
- Notification should appear

### 4. Check System Status
- Click **"Check Notification Status"** (teal button)
- This shows:
  - App notifications enabled/disabled
  - System permission status
  - WorkManager working status
  - Current timezone
  - Bahrain time

### 5. Check Exact Alarm Permissions
- Click **"Check Exact Alarm Permission Status"** (cyan button)
- Shows if your device supports exact alarms (Android 12+)

### 6. Force Reschedule All Tasks
- Click **"Force Reschedule Background Tasks"** (deep purple button)
- This reschedules all WorkManager background tasks

## Expected Behavior

### When App is Open
- All notifications work normally
- Test buttons show success messages

### When App is Closed
- **WorkManager tasks should continue running**
- **Notifications should appear at scheduled times**
- **System should be more reliable than before**

## Troubleshooting

### If Notifications Don't Work When App is Closed:

1. **Check Device Settings**:
   - Go to **Device Settings** → **Apps** → **Islamic Rewards Tracker**
   - Ensure **"Background activity"** is enabled
   - Ensure **"Battery optimization"** is disabled for this app

2. **Check Samsung Settings** (if using Samsung device):
   - Go to **Device Settings** → **Apps** → **Islamic Rewards Tracker**
   - Enable **"Allow background activity"**
   - Disable **"Auto-optimize"**

3. **Check WorkManager Status**:
   - Use **"Check Notification Status"** button
   - Look for any error messages in console

4. **Force Reschedule**:
   - Use **"Force Reschedule Background Tasks"** button
   - This cancels and reschedules all tasks

### Common Issues:

1. **"WorkManager: Not Working"**:
   - Device may have aggressive battery optimization
   - Try disabling battery optimization for the app

2. **"System Permission: Denied"**:
   - Go to device settings and enable notifications
   - May need to grant exact alarm permission (Android 12+)

3. **Notifications appear late**:
   - Device may be in battery saver mode
   - Check if "Do Not Disturb" is enabled

## Technical Details

### WorkManager Tasks Scheduled:
- **Task Reminders**: Every 6 hours (6:00, 12:00, 18:00, 00:00)
- **Dhikr Reminders**: Prayer times (5:30, 13:00, 16:30, 19:00, 20:30)
- **Dua Reminders**: Morning/Evening (7:00, 18:30)
- **Daily Reset**: Midnight (00:00)

### Timezone:
- All times are in **Asia/Bahrain (UTC+3)**
- System automatically adjusts for your device's timezone

### Background System:
- **WorkManager**: Handles background task scheduling
- **Local Notifications**: Displays the actual notifications
- **Dual approach**: Ensures maximum reliability

## Testing Checklist

- [ ] Immediate notification works
- [ ] Quick test (1 min) works with app closed
- [ ] Standard test (2 min) works with app closed
- [ ] Status check shows all systems working
- [ ] Exact alarm permission check shows status
- [ ] Force reschedule works without errors
- [ ] Background tasks continue after app restart

## Success Indicators

✅ **Green status** in notification status check
✅ **WorkManager: Working** shows in status
✅ **Notifications appear on time** even with app closed
✅ **No error messages** in console logs
✅ **All test buttons** work without errors

## Next Steps

If the system is working:
1. **Schedule real notifications** using the app
2. **Test with app closed** for extended periods
3. **Monitor battery usage** to ensure it's reasonable
4. **Report any issues** with specific error messages

If the system is not working:
1. **Check device-specific settings**
2. **Try force rescheduling** all tasks
3. **Check console logs** for error messages
4. **Test on different devices** if possible

---

**Note**: This system uses WorkManager which is designed to work reliably even when the app is closed. If notifications still don't work, it's likely a device-specific issue with battery optimization or permissions. 