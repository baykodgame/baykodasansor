import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// 🔔 FCM SERVICE (EKLENDİ)
import 'core/notification/fcm_service.dart';

// 🔥 EKLENDİ (intl locale fix)
import 'package:intl/date_symbol_data_local.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/license_screen.dart';
import 'screens/bina_list_screen.dart';
import 'screens/bina_detail_screen.dart';
import 'screens/bina_ekle_screen.dart';
import 'models/bina_model.dart';

/// 🔔 ANDROID BACKGROUND FCM (ZORUNLU)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 TÜRKÇE TARİH
  await initializeDateFormatting('tr_TR', null);

  // 🔥 FIREBASE INIT
  await Firebase.initializeApp();

  // 🔔 BACKGROUND MESSAGE HANDLER
  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );

  // 🔥 FOREGROUND + TOKEN + LOCAL NOTIFICATION INIT
  await FCMService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (_) => const LoginScreen(),
        "/home": (_) => const HomeScreen(),
        "/license": (_) => const LicenseScreen(),
        "/binalar": (_) => const BinaListScreen(),
        "/bina_ekle": (_) => const BinaEkleScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == "/bina_detay") {
          final bina = settings.arguments as BinaModel;
          return MaterialPageRoute(
            builder: (_) => BinaDetailScreen(bina: bina),
          );
        }
        return null;
      },
    );
  }
}
