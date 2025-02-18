package com.example.dictionary_app

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.os.IBinder
import android.util.Log
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.Button
import android.widget.TextView

class PopupService : Service() {
    private lateinit var windowManager: WindowManager
    private var popupView: View? = null

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d("PopupService", "PopupService başlatıldı.")

        // 🔹 Foreground Service için Notification Ayarla
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = "popup_service_channel"
            val channel = NotificationChannel(
                channelId,
                "Popup Service",
                NotificationManager.IMPORTANCE_LOW
            )

            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(channel)

            val notification = Notification.Builder(this, channelId)
                .setContentTitle("Dictionary App")
                .setContentText("Popup servisi çalışıyor...")
                .setSmallIcon(android.R.drawable.ic_dialog_info)
                .build()

            startForeground(1, notification)
        }

        // 🔹 Popup Aç
        showPopup()

        return START_STICKY
    }

    private fun showPopup() {
        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
        val inflater = getSystemService(LAYOUT_INFLATER_SERVICE) as LayoutInflater
        popupView = inflater.inflate(R.layout.popup_layout, null)

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON,
            PixelFormat.TRANSLUCENT
        )
        params.gravity = Gravity.CENTER
        windowManager.addView(popupView, params)

        val closeButton = popupView?.findViewById<Button>(R.id.close_button)
        closeButton?.setOnClickListener {
            Log.d("PopupService", "Popup kapatıldı.")
            windowManager.removeView(popupView)
            stopSelf()
        }

        val wordText = popupView?.findViewById<TextView>(R.id.word_text)
        wordText?.text = getRandomWord()
    }

    override fun onDestroy() {
    super.onDestroy()
    try {
        if (popupView != null && popupView?.windowToken != null) {
            windowManager.removeView(popupView)
        }
    } catch (e: Exception) {
        Log.e("PopupService", "Popup zaten kaldırılmış: ${e.message}")
    }
    Log.d("PopupService", "PopupService durduruldu.")
}


    private fun getRandomWord(): String {
        val words = listOf(
            "Apple - Elma",
            "Book - Kitap",
            "Car - Araba",
            "Dog - Köpek",
            "House - Ev"
        )
        return words.random()
    }
}
