package com.islamic_rewards_tracker.app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import java.util.*

class ReminderReceiver : BroadcastReceiver() {
    
    companion object {
        private const val CHANNEL_ID = "exact_alarms"
        private const val CHANNEL_NAME = "Exact Alarms"
        private const val TAG = "ReminderReceiver"
    }
    
    override fun onReceive(context: Context, intent: Intent) {
        val title = intent.getStringExtra("title") ?: "Reminder"
        val message = intent.getStringExtra("message") ?: "Time for your reminder"
        val requestCode = intent.getIntExtra("requestCode", 1000)
        val action = intent.action
        
        Log.d(TAG, "\u23F0 Alarm fired | action=$action id=$requestCode title=$title")
        
        // Handle dismiss actions
        if (action?.startsWith("DISMISS_") == true) {
            Log.d(TAG, "Dismiss action received for notification $requestCode")
            return
        }
        
        // Create notification channel if needed
        createNotificationChannel(context)
        
        // Show the notification
        showNotification(context, title, message, requestCode)
        
        Log.d(TAG, "\uD83D\uDCE3 Notification posted | id=$requestCode action=$action")
        
        // Reschedule for tomorrow (daily repetition)
        rescheduleForTomorrow(context, intent)
    }
    
    private fun createNotificationChannel(context: Context) {
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
                setShowBadge(true)
            }
            
            val notificationManager = context.getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
        }
    }
    
    private fun showNotification(context: Context, title: String, message: String, requestCode: Int) {
        val notificationManager = context.getSystemService(NotificationManager::class.java)
        
        // Create action buttons
        val openAppIntent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra("fromNotification", true)
            putExtra("title", title)
            putExtra("message", message)
        }
        val openAppPendingIntent = android.app.PendingIntent.getActivity(
            context,
            requestCode * 2,
            openAppIntent,
            android.app.PendingIntent.FLAG_UPDATE_CURRENT or android.app.PendingIntent.FLAG_IMMUTABLE
        )
        
        val dismissIntent = Intent(context, ReminderReceiver::class.java).apply {
            action = "DISMISS_$requestCode"
        }
        val dismissPendingIntent = android.app.PendingIntent.getBroadcast(
            context,
            requestCode * 2 + 1,
            dismissIntent,
            android.app.PendingIntent.FLAG_UPDATE_CURRENT or android.app.PendingIntent.FLAG_IMMUTABLE
        )
        
        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(message)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_REMINDER)
            .setAutoCancel(true)
            .setVibrate(longArrayOf(0, 500, 200, 500))
            .setLights(0xFF4CAF50.toInt(), 1000, 1000)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setFullScreenIntent(createFullScreenIntent(context, title, message), true)
            .addAction(android.R.drawable.ic_menu_view, "Open App", openAppPendingIntent)
            .addAction(android.R.drawable.ic_menu_close_clear_cancel, "Dismiss", dismissPendingIntent)
            .build()
        
        try {
            notificationManager.notify(requestCode, notification)
        } catch (t: Throwable) {
            Log.e(TAG, "Failed to post notification: ${t.message}")
        }
    }
    
    private fun createFullScreenIntent(context: Context, title: String, message: String): android.app.PendingIntent {
        val intent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra("fromNotification", true)
            putExtra("title", title)
            putExtra("message", message)
        }
        
        return android.app.PendingIntent.getActivity(
            context,
            0,
            intent,
            android.app.PendingIntent.FLAG_UPDATE_CURRENT or android.app.PendingIntent.FLAG_IMMUTABLE
        )
    }
    
    private fun rescheduleForTomorrow(context: Context, intent: Intent) {
        // This will be handled by the AlarmScheduler when it reschedules
        // The scheduler automatically reschedules daily reminders
    }
} 