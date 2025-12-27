import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'bindings/allcontroller.dart';
import 'constants/app_colors.dart';
import 'constants/app_strings.dart';
import 'l10n/app_localizations.dart';
import 'screens/splash/splash_screen.dart';
import 'services/notification_service_helper.dart';

/// 🔐 Storage
final GetStorage storage = GetStorage();

/// 🔴 Background notifications (NO Firebase init here)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("🟢 Background message received");
  NotificationServiceHelper.showFlutterNotification(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// -----------------------------
  /// STORAGE (SAFE)
  /// -----------------------------
  await GetStorage.init();

  /// -----------------------------
  /// FIREBASE (ONCE, SAFE, PLIST)
  /// -----------------------------
  try {
    await Firebase.initializeApp();
    log("✅ Firebase initialized");
  } catch (e, s) {
    log("🔴 Firebase init failed", error: e, stackTrace: s);
  }

  /// -----------------------------
  /// FIREBASE MESSAGING (SAFE)
  /// -----------------------------
  try {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((message) {
      NotificationServiceHelper.showFlutterNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      NotificationServiceHelper.handleNotificationTap(message.data);
    });
  } catch (e, s) {
    log("🔴 Firebase Messaging error", error: e, stackTrace: s);
  }

  /// -----------------------------
  /// 🚀 RUN APP (NO BLOCKERS)
  /// -----------------------------
  runApp(const RootApp());
}

/// ----------------------------------------------------
/// ROOT APP (NO SIDE EFFECTS)
/// ----------------------------------------------------
class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    final String lang = storage.read('language') ?? 'en';

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialBinding: Allcontroller(),
          locale: Locale(lang),
          fallbackLocale: const Locale('en'),
          title: AppStrings.app_name,

          /// 🔥 TEMPORARY VISUAL CONFIRMATION
          home: const SplashScreen(),

          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFF0F0F0),
            textTheme: GoogleFonts.poppinsTextTheme(),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),

          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          supportedLocales: const [
            Locale('en'),
            Locale('hi'),
            Locale('ml'),
          ],
        );
      },
    );
  }
}
