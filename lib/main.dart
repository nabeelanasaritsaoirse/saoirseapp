import 'dart:developer';
import 'dart:io' show Platform;

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
import 'constants/app_strings.dart';
import 'l10n/app_localizations.dart';
import 'screens/splash/splash_screen.dart';
import 'services/notification_service_helper.dart';

/// Global storage
final GetStorage storage = GetStorage();

/// Background notifications (iOS requirement)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    // ✅ Check if already initialized
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
    NotificationServiceHelper.showFlutterNotification(message);
  } catch (e, st) {
    log("❌ Background message error", error: e, stackTrace: st);
  }
}

Future<void> main() async {
  // ✅ Ensure binding is initialized FIRST
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Global error handler
  FlutterError.onError = (details) {
    log("❌ Flutter error", error: details.exception, stackTrace: details.stack);
  };

  // ✅ Initialize critical services synchronously before runApp
  try {
    await GetStorage.init();
    log("✅ GetStorage initialized");
  } catch (e) {
    log("❌ GetStorage failed: $e");
  }

  runApp(const BootstrapApp());
}

/// ---------------------------------------------------------------------------
/// BOOTSTRAP APP (minimal, non-blocking startup)
/// ---------------------------------------------------------------------------
class BootstrapApp extends StatefulWidget {
  const BootstrapApp({super.key});

  @override
  State<BootstrapApp> createState() => _BootstrapAppState();
}

class _BootstrapAppState extends State<BootstrapApp> {
  Locale _locale = const Locale('en');
  bool _isReady = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      log("🚀 Bootstrap start");

      // ✅ Env (optional, non-blocking)
      try {
        await dotenv.load(fileName: ".env");
        log("✅ .env loaded");
      } catch (e) {
        log("⚠️ .env not found, using defaults: $e");
      }

      // ✅ Firebase (safe init with platform check)
      try {
        if (Firebase.apps.isEmpty) {
          await Firebase.initializeApp();
          log("✅ Firebase initialized");
          
          // ✅ Only set background handler AFTER successful init
          FirebaseMessaging.onBackgroundMessage(
            firebaseMessagingBackgroundHandler,
          );
        }
      } catch (e) {
        log("⚠️ Firebase init skipped: $e");
        // Continue without Firebase - don't block app launch
      }

      // ✅ Restore language (already initialized GetStorage in main)
      try {
        final lang = storage.read('language') ?? 'en';
        _locale = Locale(lang);
        log("✅ Language: $lang");
      } catch (e) {
        log("⚠️ Language default to 'en': $e");
        _locale = const Locale('en');
      }

      log("✅ Bootstrap complete");
      
      // ✅ Update UI state
      if (mounted) {
        setState(() {
          _isReady = true;
        });
      }
    } catch (e, st) {
      log("❌ Bootstrap failed", error: e, stackTrace: st);
      if (mounted) {
        setState(() {
          _isReady = true; // ✅ Still proceed to show app (with error handling)
          _errorMessage = "Startup warning: $e";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Show loading state while bootstrapping
    if (!_isReady) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white, // Or your splash color
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Your app logo here
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(
                  'Loading...',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ✅ Show error if bootstrap had issues (optional)
    if (_errorMessage != null) {
      log("⚠️ App starting with warning: $_errorMessage");
    }

    return MyApp(locale: _locale);
  }
}

/// ---------------------------------------------------------------------------
/// MAIN APP
/// ---------------------------------------------------------------------------
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
          debugShowCheckedModeBanner: false,
          title: AppStrings.app_name,
          locale: locale,
          fallbackLocale: const Locale('en'),

          /// ✅ ONLY ONE binding (no duplicates)
          initialBinding: Allcontroller(),

          theme: ThemeData(
            scaffoldBackgroundColor: const Color.fromARGB(255, 235, 230, 230),
            textTheme: GoogleFonts.poppinsTextTheme(),
            splashColor: AppColors.transparent,
            highlightColor: AppColors.transparent,
            useMaterial3: true,
          ),

          scrollBehavior: const _NoGlowScrollBehavior(),
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
        );
      },
    );
  }
}

/// ---------------------------------------------------------------------------
/// SCROLL BEHAVIOR
/// ---------------------------------------------------------------------------
class _NoGlowScrollBehavior extends ScrollBehavior {
  const _NoGlowScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
