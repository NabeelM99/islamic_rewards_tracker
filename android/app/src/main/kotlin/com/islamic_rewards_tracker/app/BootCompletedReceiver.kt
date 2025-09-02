package com.islamic_rewards_tracker.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class BootCompletedReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "BootCompletedReceiver"
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        Log.d(TAG, "\uD83D\uDD04 Boot/Package event received: $action")
        try {
            val scheduler = AlarmScheduler(context)
            // Clear daily dedupe so reschedule can run after reboot
            scheduler.clearDailyDedupeFlag()
            scheduler.scheduleAllReminders()
            Log.d(TAG, "\u2705 Alarms rescheduled after boot/package replace")
        } catch (t: Throwable) {
            Log.e(TAG, "Failed to reschedule after boot: ${t.message}")
        }
    }
} 