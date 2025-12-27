import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bindings/allcontroller.dart';
import 'constants/app_colors.dart';
import 'constants/app_constant.dart';
import 'constants/app_strings.dart';
import 'l10n/app_localizations.dart';
import 'screens/notification/notification_controller.dart';
import 'screens/splash/splash_screen.dart';
import 'services/api_service.dart';
import 'services/appsflyer_service.dart';
import 'services/notification_service_helper.dart';

/// 🔐 Storage
final GetStorage storage = GetStorage();

/// 🔴 iOS SAFE background handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // ❌ DO NOT initialize Firebase here on iOS
  NotificationServiceHelper.showFlutterNotification(message);
  log("🟢 Background message handled");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // -----------------------------
  // Storage
  // -----------------------------
  await GetStorage.init();

  // -----------------------------
  // ENV (NON-FIREBASE ONLY)
  // -----------------------------
  try {
    await dotenv.load(fileName: ".env");
    log("🔵 .env loaded");
  } catch (e) {
    log("⚠️ dotenv load failed: $e");
  }

  // -----------------------------
  // Firebase (ONCE – reads plist)
  // -----------------------------
  try {
    log("🔵 Initializing Firebase...");
    await Firebase.initializeApp();
    log("✅ Firebase initialized");
    log("📦 Project ID: ${Firebase.app().options.projectId}");
  } catch (e, s) {
    log("🔴 Firebase init failed", error: e, stackTrace: s);
  }

  // -----------------------------
  // Firebase Messaging
  // -----------------------------
  try {
    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((message) {
      log("🟢 Foreground message");
      NotificationServiceHelper.showFlutterNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log("🔵 Notification tapped");
      NotificationServiceHelper.handleNotificationTap(message.data);
    });

    final initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      log("🟥 App opened from terminated state");
      NotificationServiceHelper.handleNotificationTap(
        initialMessage.data,
      );
    }
  } catch (e, s) {
    log("🔴 Firebase Messaging setup failed", error: e, stackTrace: s);
  }

  // -----------------------------
  // Local Notifications
  // -----------------------------
  try {
    await NotificationServiceHelper.initializeLocalNotifications();
  } catch (e, s) {
    log("🔴 Local notification init failed", error: e, stackTrace: s);
  }

  // -----------------------------
  // AppsFlyer (AFTER Firebase)
  // -----------------------------
  try {
    await AppsFlyerService.instance.init();
  } catch (e) {
    log("⚠️ AppsFlyer init failed: $e");
  }

  // -----------------------------
  // Language
  // -----------------------------
  final String lang = storage.read('language') ?? 'en';
  final Locale locale = Locale(lang);

  // -----------------------------
  // Notification Controller
  // -----------------------------
  final notif = Get.put(NotificationController(), permanent: true);

  final savedToken = storage.read(AppConst.ACCESS_TOKEN);
  if (savedToken != null) {
    notif.updateToken(savedToken);
    notif.refreshNotifications();
    notif.fetchUnreadCount();
  }

  // -----------------------------
  // RUN APP
  // -----------------------------
  runApp(MyApp(locale: locale));
}

class MyApp extends StatelessWidget {
  final Locale locale;
  const MyApp({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    APIService.checkConnection(context);

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: GetMaterialApp(
            initialBinding: Allcontroller(),
            locale: locale,
            debugShowCheckedModeBanner: false,
            title: AppStrings.app_name,
            theme: ThemeData(
              scaffoldBackgroundColor:
                  const Color.fromARGB(255, 235, 230, 230),
              textTheme: GoogleFonts.poppinsTextTheme(),
              highlightColor: AppColors.transparent,
              splashColor: AppColors.transparent,
              useMaterial3: true,
            ),
            scrollBehavior: CustomScrollBehavior(),
            home: const SplashScreen(),
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
            fallbackLocale: const Locale('en'),
          ),
        );
      },
    );
  }
}

class CustomScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
