import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'bindings/allcontroller.dart';
import 'constants/app_colors.dart';
import 'constants/app_strings.dart';
import 'constants/app_constant.dart';
import 'l10n/app_localizations.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/notification/notification_controller.dart';
import 'services/notification_service_helper.dart';
import 'services/appsflyer_service.dart';

/// ----------------------------------------------------
/// STORAGE
/// ----------------------------------------------------
final GetStorage storage = GetStorage();

/// ----------------------------------------------------
/// BACKGROUND NOTIFICATIONS (SAFE FOR iOS)
/// ----------------------------------------------------
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
    NotificationServiceHelper.showFlutterNotification(message);
  } catch (e, s) {
    log("❌ Background notification error", error: e, stackTrace: s);
  }
}

/// ----------------------------------------------------
/// MAIN (LIGHTWEIGHT)
/// ----------------------------------------------------
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Orientation lock (safe before runApp)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await GetStorage.init();

  /// 🚀 Render UI immediately (NO heavy work here)
  runApp(const BootstrapApp());
}

/// ----------------------------------------------------
/// BOOTSTRAP APP (ALL HEAVY INIT HERE)
/// ----------------------------------------------------
class BootstrapApp extends StatefulWidget {
  const BootstrapApp({super.key});

  @override
  State<BootstrapApp> createState() => _BootstrapAppState();
}

class _BootstrapAppState extends State<BootstrapApp> {
  bool _ready = false;
  Locale _locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      /// -----------------------------
      /// ENV (NEVER crash release)
      /// -----------------------------
      try {
        await dotenv.load(fileName: ".env");
        log("✅ .env loaded");
      } catch (_) {
        log("⚠️ .env not found (expected in release)");
      }

      /// -----------------------------
      /// FIREBASE
      /// -----------------------------
      await Firebase.initializeApp();
      log("✅ Firebase initialized");

      FirebaseMessaging.onBackgroundMessage(
        firebaseMessagingBackgroundHandler,
      );

      /// iOS foreground notifications
      if (Platform.isIOS) {
        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }

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

      final initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        NotificationServiceHelper.handleNotificationTap(
          initialMessage.data,
        );
      }

      /// -----------------------------
      /// LOCAL NOTIFICATIONS
      /// -----------------------------
      await NotificationServiceHelper.initializeLocalNotifications();

      /// -----------------------------
      /// APPSFLYER (OPTIONAL)
      /// -----------------------------
      try {
        await AppsFlyerService.instance.init();
      } catch (e) {
        log("⚠️ AppsFlyer init failed: $e");
      }

      /// -----------------------------
      /// LANGUAGE
      /// -----------------------------
      final lang = storage.read('language') ?? 'en';
      _locale = Locale(lang);

      /// -----------------------------
      /// CONTROLLERS
      /// -----------------------------
      final notif = Get.put(NotificationController(), permanent: true);
      final token = storage.read(AppConst.ACCESS_TOKEN);

      if (token != null) {
        notif.updateToken(token);
        notif.refreshNotifications();
        notif.fetchUnreadCount();
      }
    } catch (e, s) {
      log("❌ Bootstrap init failed", error: e, stackTrace: s);
      _locale = const Locale('en');
    }

    if (mounted) {
      setState(() => _ready = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MyApp(locale: _locale);
  }
}

/// ----------------------------------------------------
/// MAIN APP UI
/// ----------------------------------------------------
class MyApp extends StatelessWidget {
  final Locale locale;
  const MyApp({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return GetMaterialApp(
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
        );
      },
    );
  }
}
