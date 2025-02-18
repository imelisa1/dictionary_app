package com.example.dictionary_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    private val lockScreenReceiver = LockScreenReceiver()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // 🔹 BroadcastReceiver'ı Dinlemeye Başla
        val filter = IntentFilter(Intent.ACTION_USER_PRESENT)
        registerReceiver(lockScreenReceiver, filter)
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(lockScreenReceiver)
    }
}
