package com.islamic_rewards_tracker.app

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import java.util.*

class AlarmScheduler(private val context: Context) {
    
    companion object {
        private const val TAG = "AlarmScheduler"
        
        // Task reminder times (24-hour format)
        private val TASK_TIMES = listOf(6, 12, 18, 0)
        private val DHIKR_TIMES = listOf(5, 13, 16, 19, 20)
        private val DHIKR_MINUTES = listOf(30, 0, 30, 0, 30)
        private val DUA_TIMES = listOf(7, 18)
        private val DUA_MINUTES = listOf(0, 30)
    }
    
    private val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
    
    /**
     * Schedule all reminders using exact alarms
     */
    fun scheduleAllReminders() {
        Log.d(TAG, "🔄 Scheduling all reminders using exact alarms...")
        
        // Cancel any existing alarms first to prevent duplicates
        cancelAllReminders()
        
        // Schedule task reminders
        TASK_TIMES.forEachIndexed { index, hour ->
            scheduleExact(
                1000 + index,
                hour,
                0,
                "Task Reminder",
                "Complete your daily Islamic tasks and earn rewards!"
            )
        }
        
        // Schedule dhikr reminders
        DHIKR_TIMES.forEachIndexed { index, hour ->
            val minute = DHIKR_MINUTES[index]
            scheduleExact(
                2000 + index,
                hour,
                minute,
                "Dhikr Reminder",
                "Time for dhikr and remembrance of Allah"
            )
        }
        
        // Schedule dua reminders
        DUA_TIMES.forEachIndexed { index, hour ->
            val minute = DUA_MINUTES[index]
            scheduleExact(
                3000 + index,
                hour,
                minute,
                "Dua Reminder",
                "Recite your daily duas and supplications"
            )
        }
        
        Log.d(TAG, "✅ All reminders scheduled using exact alarms")
    }
    
    /**
     * Schedule a single exact alarm
     */
    private fun scheduleExact(id: Int, hour: Int, minute: Int, title: String, message: String) {
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
        
        Log.d(TAG, "⏰ Scheduled $title for ${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')} (ID: $id)")
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
        Log.d(TAG, "❌ Cancelled alarm with ID: $id")
    }
    
    /**
     * Cancel all reminders
     */
    fun cancelAllReminders() {
        Log.d(TAG, "🧹 Cancelling all existing alarms...")
        
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
        
        Log.d(TAG, "✅ All alarms cancelled")
    }
    
    /**
     * Check if alarms are scheduled
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
        
        return alarms
    }
} 