package com.islamic_rewards_tracker.app

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Build
import android.util.Log
import java.util.*

class AlarmScheduler(private val context: Context) {
    
    companion object {
        private const val TAG = "AlarmScheduler"
        private const val PREFS_NAME = "alarm_scheduler_prefs"
        private const val KEY_LAST_SCHEDULED_DATE = "last_scheduled_date"
        private const val DAILY_RESCHEDULER_ID = 9000
        
        // Task reminder times (24-hour format)
        private val TASK_TIMES = listOf(6, 12, 18, 0)
        private val DHIKR_TIMES = listOf(5, 13, 16, 19, 20)
        private val DHIKR_MINUTES = listOf(30, 0, 30, 0, 30)
        private val DUA_TIMES = listOf(7, 18)
        private val DUA_MINUTES = listOf(0, 30)
        
        // Daily reset notification (1 minute after midnight)
        private const val DAILY_RESET_ID = 4000
        private const val DAILY_RESET_HOUR = 0
        private const val DAILY_RESET_MINUTE = 1
    }
    
    private val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
    private val prefs: SharedPreferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
    
    // Added to satisfy receivers; currently a no-op because we don't persist a dedupe flag here
    fun clearDailyDedupeFlag() {
        prefs.edit().remove(KEY_LAST_SCHEDULED_DATE).apply()
        Log.d(TAG, "\u267B\uFE0F Cleared daily dedupe flag")
    }
    
    /**
     * Schedule all reminders using exact alarms
     */
    fun scheduleAllReminders() {
        val todayKey = getTodayKey()
        val alreadyScheduledToday = prefs.getString(KEY_LAST_SCHEDULED_DATE, null) == todayKey
        
        Log.d(TAG, "\uD83D\uDD04 Scheduling all reminders using exact alarms... SDK=${Build.VERSION.SDK_INT} canExact=${canScheduleExactAlarmsSafe()}")
        
        // Daily dedupe: avoid cancel/reschedule loops within the same day
        if (alreadyScheduledToday) {
            Log.d(TAG, "\u2705 Alarms already scheduled today ($todayKey). Skipping to avoid duplicates.")
            ensureDailyRescheduler()
            return
        }
        
        // Cancel any existing alarms first to prevent duplicates
        cancelAllReminders()
        
        var scheduledCount = 0
        var skippedDedupeCount = 0
        
        // Schedule task reminders
        TASK_TIMES.forEachIndexed { index, hour ->
            if (scheduleExact(
                    1000 + index,
                    hour,
                    0,
                    "Task Reminder",
                    "Complete your daily Islamic tasks and earn rewards!"
                )
            ) {
                scheduledCount++
            } else {
                skippedDedupeCount++
            }
        }
        
        // Schedule dhikr reminders
        DHIKR_TIMES.forEachIndexed { index, hour ->
            val minute = DHIKR_MINUTES[index]
            if (scheduleExact(
                    2000 + index,
                    hour,
                    minute,
                    "Dhikr Reminder",
                    "Time for dhikr and remembrance of Allah"
                )
            ) {
                scheduledCount++
            } else {
                skippedDedupeCount++
            }
        }
        
        // Schedule dua reminders
        DUA_TIMES.forEachIndexed { index, hour ->
            val minute = DUA_MINUTES[index]
            if (scheduleExact(
                    3000 + index,
                    hour,
                    minute,
                    "Dua Reminder",
                    "Recite your daily duas and supplications"
                )
            ) {
                scheduledCount++
            } else {
                skippedDedupeCount++
            }
        }
        
        // Schedule daily reset notification (00:01)
        if (scheduleExact(
                DAILY_RESET_ID,
                DAILY_RESET_HOUR,
                DAILY_RESET_MINUTE,
                "Daily Reset",
                "New day has begun! Reset your daily progress"
            )
        ) {
            scheduledCount++
        } else {
            skippedDedupeCount++
        }
        
        // Ensure a single 23:59 daily rescheduler is set
        ensureDailyRescheduler()
        
        prefs.edit().putString(KEY_LAST_SCHEDULED_DATE, todayKey).apply()
        
        val totalExpected = TASK_TIMES.size + DHIKR_TIMES.size + DUA_TIMES.size + 1 // +1 for daily reset
        Log.d(TAG, "\u2705 All reminders processed | expected=$totalExpected scheduled=$scheduledCount skipped_dedupe=$skippedDedupeCount")
    }
    
    /**
     * Ensure a single daily rescheduler alarm at 23:59 to re-register next day's alarms
     */
    private fun ensureDailyRescheduler() {
        val intent = Intent(context, DailyRescheduleReceiver::class.java).apply {
            action = "DAILY_RESCHEDULER"
        }
        val existing = PendingIntent.getBroadcast(
            context,
            DAILY_RESCHEDULER_ID,
            intent,
            PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE
        )
        if (existing != null) {
            Log.d(TAG, "\u23F3 Daily rescheduler already set")
            return
        }
        val calendar = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 23)
            set(Calendar.MINUTE, 59)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
            if (timeInMillis <= System.currentTimeMillis()) {
                add(Calendar.DAY_OF_YEAR, 1)
            }
        }
        val pi = PendingIntent.getBroadcast(
            context,
            DAILY_RESCHEDULER_ID,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, calendar.timeInMillis, pi)
        } else {
            alarmManager.setExact(AlarmManager.RTC_WAKEUP, calendar.timeInMillis, pi)
        }
        Log.d(TAG, "\u23F0 Daily rescheduler set for 23:59 (ID: $DAILY_RESCHEDULER_ID)")
    }
    
    /**
     * Schedule a single exact alarm
     * @return true if scheduled, false if skipped due to deduplication
     */
    private fun scheduleExact(id: Int, hour: Int, minute: Int, title: String, message: String): Boolean {
        val calendar = Calendar.getInstance()
        calendar.set(Calendar.HOUR_OF_DAY, hour)
        calendar.set(Calendar.MINUTE, minute)
        calendar.set(Calendar.SECOND, 0)
        calendar.set(Calendar.MILLISECOND, 0)
        
        // If time has passed today, schedule for tomorrow
        if (calendar.timeInMillis <= System.currentTimeMillis()) {
            calendar.add(Calendar.DAY_OF_YEAR, 1)
        }
        
        val intent = Intent(context, ReminderReceiver::class.java).apply {
            action = "REMINDER_$id"
            putExtra("title", title)
            putExtra("message", message)
            putExtra("requestCode", id)
        }
        
        // Dedupe guard: if a matching PendingIntent already exists, skip rescheduling
        val existing = PendingIntent.getBroadcast(
            context,
            id,
            intent,
            PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE
        )
        if (existing != null) {
            Log.d(TAG, "\u21A9\uFE0F Skipping duplicate schedule for ID $id at ${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}")
            return false
        }
        
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            id,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        
        // Use exact alarm that bypasses Doze mode and battery optimization
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            alarmManager.setExactAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP,
                calendar.timeInMillis,
                pendingIntent
            )
        } else {
            alarmManager.setExact(
                AlarmManager.RTC_WAKEUP,
                calendar.timeInMillis,
                pendingIntent
            )
        }
        
        Log.d(TAG, "\u23F0 Scheduled $title for ${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')} (ID: $id) ts=${calendar.time}")
        return true
    }
    
    /**
     * Cancel a specific alarm
     */
    fun cancel(id: Int) {
        val intent = Intent(context, ReminderReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            id,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        alarmManager.cancel(pendingIntent)
        Log.d(TAG, "\u274C Cancelled alarm with ID: $id")
    }
    
    /**
     * Cancel all reminders
     */
    fun cancelAllReminders() {
        Log.d(TAG, "\uD83E\uDDF9 Cancelling all existing alarms...")
        
        // Cancel task reminders
        TASK_TIMES.forEachIndexed { index, _ ->
            cancel(1000 + index)
        }
        
        // Cancel dhikr reminders
        DHIKR_TIMES.forEachIndexed { index, _ ->
            cancel(2000 + index)
        }
        
        // Cancel dua reminders
        DUA_TIMES.forEachIndexed { index, _ ->
            cancel(3000 + index)
        }
        
        // Cancel daily reset notification
        cancel(DAILY_RESET_ID)
        
        // Cancel daily rescheduler
        try {
            val intent = Intent(context, DailyRescheduleReceiver::class.java).apply { action = "DAILY_RESCHEDULER" }
            val pi = PendingIntent.getBroadcast(context, DAILY_RESCHEDULER_ID, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            alarmManager.cancel(pi)
        } catch (_: Throwable) {}
        
        Log.d(TAG, "\u2705 All alarms cancelled")
    }
    
    /**
     * Check if alarms are scheduled (planned list)
     */
    fun getScheduledAlarms(): List<Map<String, Any>> {
        val alarms = mutableListOf<Map<String, Any>>()
        
        // This is a simplified check - in production you might want to use AlarmManager.getNextAlarmClock()
        // For now, we'll return the expected schedule
        TASK_TIMES.forEachIndexed { index, hour ->
            alarms.add(mapOf(
                "id" to (1000 + index),
                "type" to "Task Reminder",
                "hour" to hour,
                "minute" to 0
            ))
        }
        
        DHIKR_TIMES.forEachIndexed { index, hour ->
            alarms.add(mapOf(
                "id" to (2000 + index),
                "type" to "Dhikr Reminder",
                "hour" to hour,
                "minute" to DHIKR_MINUTES[index]
            ))
        }
        
        DUA_TIMES.forEachIndexed { index, hour ->
            alarms.add(mapOf(
                "id" to (3000 + index),
                "type" to "Dua Reminder",
                "hour" to hour,
                "minute" to DUA_MINUTES[index]
            ))
        }
        
        // Also include the daily rescheduler (23:59)
        alarms.add(mapOf(
            "id" to DAILY_RESCHEDULER_ID,
            "type" to "Daily Rescheduler",
            "hour" to 23,
            "minute" to 59
        ))
        
        return alarms
    }

    /**
     * Android 12+ exact alarm capability (logged for diagnostics)
     */
    private fun canScheduleExactAlarmsSafe(): Boolean {
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                alarmManager.canScheduleExactAlarms()
            } else true
        } catch (t: Throwable) {
            Log.w(TAG, "Error checking canScheduleExactAlarms: ${t.message}")
            true
        }
    }

    private fun getTodayKey(): String {
        val cal = Calendar.getInstance()
        return "${cal.get(Calendar.YEAR)}-${cal.get(Calendar.MONTH)+1}-${cal.get(Calendar.DAY_OF_MONTH)}"
    }

    /**
     * Schedule a completion notification a few seconds from now.
     */
    fun scheduleCompletionNotification() {
        val completionId = 5000
        val intent = Intent(context, ReminderReceiver::class.java).apply {
            action = "COMPLETION_NOTIFICATION"
            putExtra("title", "Daily Tasks Completed!")
            putExtra("message", "Congratulations! You've completed all your daily Islamic tasks. May Allah reward you abundantly!")
            putExtra("requestCode", completionId)
        }
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            completionId,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val triggerTime = System.currentTimeMillis() + 5000
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            alarmManager.setExactAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP,
                triggerTime,
                pendingIntent
            )
        } else {
            alarmManager.setExact(
                AlarmManager.RTC_WAKEUP,
                triggerTime,
                pendingIntent
            )
        }
        Log.d(TAG, "\u2705 Completion notification scheduled for 5 seconds from now")
    }
} 