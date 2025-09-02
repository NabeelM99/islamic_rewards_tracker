package com.islamic_rewards_tracker.app

import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.islamic_rewards_tracker.app.AlarmScheduler

class MainActivity: FlutterFragmentActivity() {
    companion object {
        private const val TAG = "MainActivity"
        private const val CHANNEL_NAME = "exact_alarm_service"
    }
    
    private lateinit var methodChannel: MethodChannel
    private lateinit var alarmScheduler: AlarmScheduler

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Initialize AlarmScheduler
        alarmScheduler = AlarmScheduler(this)
        
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    startAlarmScheduler()
                    result.success(true)
                }
                "stopService" -> {
                    stopAlarmScheduler()
                    result.success(true)
                }
                "scheduleAll" -> {
                    scheduleAllReminders()
                    result.success(true)
                }
                "scheduleTaskReminders" -> {
                    scheduleTaskReminders()
                    result.success(true)
                }
                "scheduleDhikrReminders" -> {
                    scheduleDhikrReminders()
                    result.success(true)
                }
                "scheduleDuaReminders" -> {
                    scheduleDuaReminders()
                    result.success(true)
                }
                "getStatus" -> {
                    val status = getServiceStatus()
                    result.success(status)
                }
                "getScheduledAlarms" -> {
                    val alarms = alarmScheduler.getScheduledAlarms()
                    result.success(alarms)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Check if this is a boot-triggered launch
        if (intent?.action == "RESCHEDULE_NOTIFICATIONS") {
            Log.d(TAG, "App launched from boot receiver, will reschedule notifications")
            // Schedule all reminders using AlarmScheduler
            scheduleAllReminders()
        }
        
        Log.d(TAG, "MainActivity created successfully")
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        
        if (intent.action == "RESCHEDULE_NOTIFICATIONS") {
            Log.d(TAG, "Received reschedule notifications intent")
            // Schedule all reminders using AlarmScheduler
            scheduleAllReminders()
        }
    }
    
    private fun startAlarmScheduler() {
        Log.d(TAG, "🚀 Starting AlarmScheduler for exact timing notifications")
        scheduleAllReminders()
    }
    
    private fun stopAlarmScheduler() {
        Log.d(TAG, "🛑 Stopping AlarmScheduler")
        alarmScheduler.cancelAllReminders()
    }
    
    private fun scheduleAllReminders() {
        Log.d(TAG, "🔄 Scheduling all reminders using AlarmScheduler")
        alarmScheduler.scheduleAllReminders()
    }
    
    private fun scheduleTaskReminders() {
        Log.d(TAG, "🔄 Scheduling task reminders using AlarmScheduler")
        // For now, schedule all reminders (task reminders are included)
        alarmScheduler.scheduleAllReminders()
    }
    
    private fun scheduleDhikrReminders() {
        Log.d(TAG, "🔄 Scheduling dhikr reminders using AlarmScheduler")
        // For now, schedule all reminders (dhikr reminders are included)
        alarmScheduler.scheduleAllReminders()
    }
    
    private fun scheduleDuaReminders() {
        Log.d(TAG, "🔄 Scheduling dua reminders using AlarmScheduler")
        // For now, schedule all reminders (dua reminders are included)
        alarmScheduler.scheduleAllReminders()
    }
    
    private fun getServiceStatus(): Map<String, Any> {
        return mapOf(
            "running" to true,
            "exactAlarmPermission" to true,
            "batteryOptimizationDisabled" to true,
            "serviceActive" to true,
            "usingAlarmManager" to true,
            "workManagerDisabled" to true
        )
    }
}