package com.islamic_rewards_tracker.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class DailyRescheduleReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "DailyRescheduleReceiver"
    }

    override fun onReceive(context: Context, intent: Intent) {
        Log.d(TAG, "\u23F0 Daily rescheduler fired: ${intent.action}")
        try {
            val scheduler = AlarmScheduler(context)
            scheduler.clearDailyDedupeFlag()
            scheduler.scheduleAllReminders()
            Log.d(TAG, "\u2705 Next day alarms scheduled by daily rescheduler")
        } catch (t: Throwable) {
            Log.e(TAG, "Failed in daily rescheduler: ${t.message}")
        }
    }
} 