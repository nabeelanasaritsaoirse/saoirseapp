import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
  try {
    WidgetsFlutterBinding.ensureInitialized();
    log("✅ WidgetsFlutterBinding initialized");

    // Catch platform errors (before Flutter is ready)
    PlatformDispatcher.instance.onError = (error, stack) {
      log("❌ PLATFORM ERROR: $error", stackTrace: stack);
      return true;
    };

    // Catch Flutter framework errors
    FlutterError.onError = (details) {
      log("❌ FLUTTER ERROR: ${details.exception}", stackTrace: details.stack);
      FlutterError.presentError(details);
    };

    /// Orientation lock (safe before runApp)
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    log("✅ Orientation set");

    await GetStorage.init();
    log("✅ GetStorage initialized");

    /// 🚀 Render UI immediately (NO heavy work here)
    runApp(const BootstrapApp());
    log("✅ runApp called");
  } catch (e, s) {
    log("❌ MAIN CRASH: $e", stackTrace: s);
    // Show error screen instead of crashing
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red,
        body: Center(
          child: Text("App Error: $e", style: const TextStyle(color: Colors.white)),
        ),
      ),
    ));
  }
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
      log("🔄 Starting app initialization...");

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
      log("🔄 Initializing Firebase...");
      await Firebase.initializeApp();
      log("✅ Firebase initialized");

      /// -----------------------------
      /// CRASHLYTICS
      /// -----------------------------
      log("🔄 Initializing Crashlytics...");
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      log("✅ Crashlytics initialized");

      /// Log app start to Crashlytics
      FirebaseCrashlytics.instance.log("App initialization started");

      log("🔄 Setting up Firebase Messaging...");
      FirebaseMessaging.onBackgroundMessage(
        firebaseMessagingBackgroundHandler,
      );

      /// iOS foreground notifications
      if (Platform.isIOS) {
        log("🔄 Configuring iOS foreground notifications...");
        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
        log("✅ iOS foreground notifications configured");
      }

      log("🔄 Requesting notification permission...");
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      log("✅ Notification permission requested");

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
      log("✅ Firebase Messaging configured");

      /// -----------------------------
      /// LOCAL NOTIFICATIONS
      /// -----------------------------
      log("🔄 Initializing local notifications...");
      await NotificationServiceHelper.initializeLocalNotifications();
      log("✅ Local notifications initialized");

      /// -----------------------------
      /// APPSFLYER (OPTIONAL)
      /// -----------------------------
      try {
        log("🔄 Initializing AppsFlyer...");
        await AppsFlyerService.instance.init();
        log("✅ AppsFlyer initialized");
      } catch (e) {
        log("⚠️ AppsFlyer init failed: $e");
      }

      /// -----------------------------
      /// LANGUAGE
      /// -----------------------------
      final lang = storage.read('language') ?? 'en';
      _locale = Locale(lang);
      log("✅ Language set to: $lang");

      /// -----------------------------
      /// CONTROLLERS
      /// -----------------------------
      log("🔄 Setting up controllers...");
      final notif = Get.put(NotificationController(), permanent: true);
      final token = storage.read(AppConst.ACCESS_TOKEN);

      if (token != null) {
        notif.updateToken(token);
        notif.refreshNotifications();
        notif.fetchUnreadCount();
      }
      log("✅ Controllers initialized");

      FirebaseCrashlytics.instance.log("App initialization completed successfully");
      log("✅ App initialization completed!");
    } catch (e, s) {
      log("❌ Bootstrap init failed: $e", stackTrace: s);
      // Report to Crashlytics
      try {
        await FirebaseCrashlytics.instance.recordError(e, s, reason: "Bootstrap init failed");
      } catch (_) {}
      _locale = const Locale('en');
    }

    if (mounted) {
      setState(() => _ready = true);
      log("✅ _ready set to true, showing main app");
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
    log("🔄 Building MyApp...");

    // Get safe text theme (fallback if Google Fonts fails)
    TextTheme safeTextTheme;
    try {
      safeTextTheme = GoogleFonts.poppinsTextTheme();
      log("✅ Google Fonts loaded");
    } catch (e) {
      log("⚠️ Google Fonts failed, using default: $e");
      safeTextTheme = ThemeData.light().textTheme;
    }

    try {
      return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        // Removed useInheritedMediaQuery - can cause iOS 17+ issues
        builder: (context, child) {
          log("🔄 ScreenUtilInit builder called");
          return _buildMaterialApp(safeTextTheme);
        },
      );
    } catch (e) {
      log("❌ ScreenUtilInit failed: $e, using fallback");
      // Fallback without ScreenUtil
      return _buildMaterialApp(safeTextTheme);
    }
  }

  Widget _buildMaterialApp(TextTheme textTheme) {
    log("🔄 Building GetMaterialApp...");
    try {
      return GetMaterialApp(
        initialBinding: AllController(),
        locale: locale,
        debugShowCheckedModeBanner: false,
        title: AppStrings.app_name,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 235, 230, 230),
          textTheme: textTheme,
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
        // Add error widget builder
        builder: (context, widget) {
          // Wrap with error boundary
          ErrorWidget.builder = (FlutterErrorDetails details) {
            log("❌ Widget error: ${details.exception}");
            return Center(
              child: Text(
                'UI Error: ${details.exception}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          };
          return widget ?? const SizedBox.shrink();
        },
      );
    } catch (e) {
      log("❌ GetMaterialApp failed: $e");
      return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.orange,
          body: Center(
            child: Text("App Build Error: $e",
              style: const TextStyle(color: Colors.white)),
          ),
        ),
      );
    }
  }
}
