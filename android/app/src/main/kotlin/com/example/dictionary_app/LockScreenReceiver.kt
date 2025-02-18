package com.example.dictionary_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class LockScreenReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        Log.d("LockScreenReceiver", "🔹 Broadcast alındı: ${intent?.action}")

        if (intent?.action == Intent.ACTION_USER_PRESENT) {
            Log.d("LockScreenReceiver", "🔹 Telefonun kilidi açıldı, popup servisi başlatılıyor...")

            val popupService = Intent(context, PopupService::class.java)
            context?.startForegroundService(popupService)
        }
    }
}
