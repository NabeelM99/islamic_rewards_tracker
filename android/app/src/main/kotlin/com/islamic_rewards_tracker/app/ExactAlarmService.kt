package com.islamic_rewards_tracker.app

import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import java.util.*

class ExactAlarmService : Service() {
    
    companion object {
        private const val NOTIFICATION_ID = 1001
        private const val CHANNEL_ID = "exact_alarms"
        private const val CHANNEL_NAME = "Exact Alarms"
        
        // Task reminder times (24-hour format)
        private val TASK_TIMES = listOf(6, 12, 18, 0)
        private val DHIKR_TIMES = listOf(5, 13, 16, 19, 20)
        private val DHIKR_MINUTES = listOf(30, 0, 30, 0, 30)
        private val DUA_TIMES = listOf(7, 18)
        private val DUA_MINUTES = listOf(0, 30)
    }
    
    private lateinit var alarmManager: AlarmManager
    private lateinit var notificationManager: NotificationManager
    
    override fun onCreate() {
        super.onCreate()
        alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        createNotificationChannel()
    }
    
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            "SCHEDULE_TASK_REMINDERS" -> scheduleTaskReminders()
            "SCHEDULE_DHIKR_REMINDERS" -> scheduleDhikrReminders()
            "SCHEDULE_DUA_REMINDERS" -> scheduleDuaReminders()
            "SCHEDULE_ALL" -> scheduleAllReminders()
        }
        
        // Start foreground service to keep it alive (only if needed)
        try {
            startForeground(NOTIFICATION_ID, createForegroundNotification())
        } catch (e: Exception) {
            // If foreground service fails, continue as regular service
            // This handles cases where foreground service permissions are not granted
        }
        
        return START_STICKY
    }
    
    override fun onBind(intent: Intent?): IBinder? = null
    
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                CHANNEL_NAME,
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Exact timing notifications for Islamic reminders"
                enableVibration(true)
                enableLights(true)
                lockscreenVisibility = NotificationCompat.VISIBILITY_PUBLIC
            }
            notificationManager.createNotificationChannel(channel)
        }
    }
    
    private fun createForegroundNotification(): android.app.Notification {
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Islamic Reminders Active")
            .setContentText("Keeping your daily reminders on schedule")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setOngoing(true)
            .build()
    }
    
    private fun scheduleTaskReminders() {
        TASK_TIMES.forEachIndexed { index, hour ->
            val minute = 0
            scheduleExactAlarm(
                "TASK_REMINDER_$index",
                hour,
                minute,
                "Task Reminder",
                "Complete your daily Islamic tasks and earn rewards!",
                1000 + index
            )
        }
    }
    
    private fun scheduleDhikrReminders() {
        DHIKR_TIMES.forEachIndexed { index, hour ->
            val minute = DHIKR_MINUTES[index]
            scheduleExactAlarm(
                "DHIKR_REMINDER_$index",
                hour,
                minute,
                "Dhikr Reminder",
                "Time for dhikr and remembrance of Allah",
                2000 + index
            )
        }
    }
    
    private fun scheduleDuaReminders() {
        DUA_TIMES.forEachIndexed { index, hour ->
            val minute = DUA_MINUTES[index]
            scheduleExactAlarm(
                "DUA_REMINDER_$index",
                hour,
                minute,
                "Dua Reminder",
                "Recite your daily duas and supplications",
                3000 + index
            )
        }
    }
    
    private fun scheduleAllReminders() {
        scheduleTaskReminders()
        scheduleDhikrReminders()
        scheduleDuaReminders()
    }
    
    private fun scheduleExactAlarm(
        action: String,
        hour: Int,
        minute: Int,
        title: String,
        message: String,
        requestCode: Int
    ) {
        val calendar = Calendar.getInstance()
        calendar.set(Calendar.HOUR_OF_DAY, hour)
        calendar.set(Calendar.MINUTE, minute)
        calendar.set(Calendar.SECOND, 0)
        
        // If time has passed today, schedule for tomorrow
        if (calendar.timeInMillis <= System.currentTimeMillis()) {
            calendar.add(Calendar.DAY_OF_YEAR, 1)
        }
        
        val intent = Intent(this, ReminderReceiver::class.java).apply {
            this.action = action
            putExtra("title", title)
            putExtra("message", message)
            putExtra("requestCode", requestCode)
        }
        
        val pendingIntent = PendingIntent.getBroadcast(
            this,
            requestCode,
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
    }
    
    override fun onDestroy() {
        super.onDestroy()
        // Reschedule alarms when service is destroyed
        scheduleAllReminders()
    }
} 