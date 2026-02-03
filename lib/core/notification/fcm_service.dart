// ignore_for_file: avoid_print

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:baykodasansor/core/api/api_client.dart';

class FCMService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// 🔔 ANDROID NOTIFICATION CHANNEL
  static const AndroidNotificationChannel _channel =
      AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Foreground notifications',
    importance: Importance.max,
  );

  static Future<void> init() async {
    print("FCM INIT ÇALIŞTI");

    /// 🔔 ANDROID 13+ RUNTIME İZNİ
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("FCM AUTH STATUS: ${settings.authorizationStatus}");

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print("FCM İZNİ REDDEDİLDİ");
      return;
    }

    /// 🔔 LOCAL NOTIFICATION INIT
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit);

    await _localNotifications.initialize(initSettings);

    /// 🔊 CHANNEL OLUŞTUR
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    /// 🔑 FCM TOKEN
    final token = await _fcm.getToken();
    print("FCM TOKEN: $token");

    if (token == null) return;

    final platform = Platform.isIOS ? 'ios' : 'android';

    try {
      await ApiClient.post(
        "/save_fcm_token.php",
        {
          "device_token": token,
          "platform": platform,
        },
      );
      print("FCM TOKEN API'YE GÖNDERİLDİ");
    } catch (e) {
      print("FCM API HATASI: $e");
    }

    /// 🔥 FOREGROUND – DATA-ONLY OKUMA
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final data = message.data;

      final title = data['title'];
      final body  = data['body'];

      if (title == null || body == null) {
        print("⚠️ DATA GELDİ AMA title/body YOK");
        return;
      }

      print("🔔 FCM GELDİ (DATA): $title");

      _localNotifications.show(
  DateTime.now().millisecondsSinceEpoch % 100000, // ✅ 32-bit SAFE
  title,
  body,
  NotificationDetails(
    android: AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    ),
  ),
);
    });
  }
}
