import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';

class WordNotification {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidInitSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInitSettings = DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _notifications.initialize(initSettings);
  }

  static Future<void> showRandomWordNotification(List<Map<String, String>> words) async {
    if (words.isEmpty) return;

    final random = Random();
    final randomWord = words[random.nextInt(words.length)];

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      "word_channel",
      "Word Notifications",
      importance: Importance.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      0,
      randomWord["en"],
      randomWord["tr"],
      platformDetails,
    );
  }
}
