import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'app.dart'; // your main app widget

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (e, s) {
    log('❌ BG Firebase error', error: e, stackTrace: s);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔒 Never allow startup crash
  try {
    // Load env (DO NOT FAIL APP)
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      log("⚠️ .env not loaded: $e");
    }

    // Firebase init
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );

  } catch (e, s) {
    log('❌ App init failed', error: e, stackTrace: s);
  }

  // 🔥 ALWAYS RUN APP
  runApp(const MyApp());
}
