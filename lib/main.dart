import 'dart:async';
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

//storage instance
GetStorage storage = GetStorage();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("🟡 Background Message Received: ${message.notification?.title}");
  try {
    NotificationServiceHelper.showFlutterNotification(message);
  } catch (e) {
    log("❌ Error showing background notification: $e");
  }
}

Future<void> main() async {
  // Wrap everything in error handling
  runZonedGuarded(() async {
    try {
      log("🚀 App initialization starting...");
      
      // Initialize Flutter binding
      WidgetsFlutterBinding.ensureInitialized();
      log("✅ Flutter binding initialized");
      
      // Initialize GetStorage
      await GetStorage.init();
      log("✅ GetStorage initialized");
      
      // Initialize AppsFlyer
      try {
        await AppsFlyerService.instance.init();
        log("✅ AppsFlyer initialized");
      } catch (e) {
        log("⚠️ AppsFlyer initialization failed (non-critical): $e");
      }
      
      // Load .env file (optional in CI/CD builds)
      try {
        await dotenv.load(fileName: ".env");
        log("✅ .env file loaded successfully");
      } catch (e) {
        log("⚠️ .env file not found, using default configuration: $e");
      }
      
      // Initialize Firebase (with safety check)
      try {
        if (Firebase.apps.isEmpty) {
          await Firebase.initializeApp();
          log("✅ Firebase initialized successfully");
        } else {
          log("✅ Firebase already initialized");
        }
      } catch (e) {
        log("❌ CRITICAL: Firebase initialization failed: $e");
        // Continue anyway - some features might still work
      }
      
      // Register background message handler
      try {
        FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
        log("✅ Background message handler registered");
      } catch (e) {
        log("⚠️ Could not register background handler: $e");
      }
      
      // Request notification permissions
      try {
        final settings = await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
        log("✅ Notification permission status: ${settings.authorizationStatus}");
      } catch (e) {
        log("⚠️ Could not request notification permissions: $e");
      }
      
      // Initialize local notifications
      try {
        await NotificationServiceHelper.initializeLocalNotifications();
        log("✅ Local notifications initialized");
      } catch (e) {
        log("⚠️ Local notification initialization failed: $e");
      }
      
      // Load language preference
      String? lang = storage.read('language') ?? 'en';
      Locale locale = Locale(lang);
      log("✅ Language set to: $lang");
      
      // Register NotificationController
      try {
        final notif = Get.put(NotificationController(), permanent: true);
        log("✅ NotificationController registered");
        
        // Restore token if already logged in
        final savedToken = storage.read(AppConst.ACCESS_TOKEN);
        if (savedToken != null && savedToken.isNotEmpty) {
          notif.updateToken(savedToken);
          notif.refreshNotifications();
          notif.fetchUnreadCount();
          log("✅ User session restored");
        } else {
          log("ℹ️ No saved session found");
        }
      } catch (e) {
        log("⚠️ NotificationController setup failed: $e");
      }
      
      // Setup foreground message listener
      try {
        FirebaseMessaging.onMessage.listen((message) {
          log("🟢 Foreground message received: ${message.notification?.title}");
          try {
            NotificationServiceHelper.showFlutterNotification(message);
          } catch (e) {
            log("❌ Error showing foreground notification: $e");
          }
        });
        log("✅ Foreground message listener setup");
      } catch (e) {
        log("⚠️ Could not setup foreground listener: $e");
      }
      
      // Setup notification tap handlers
      try {
        // User taps notification when app is in background
        FirebaseMessaging.onMessageOpenedApp.listen((message) {
          log("🔵 Notification clicked (background): ${message.data}");
          try {
            NotificationServiceHelper.handleNotificationTap(message.data);
          } catch (e) {
            log("❌ Error handling notification tap: $e");
          }
        });
        
        // User taps notification when app was terminated
        final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
        if (initialMessage != null) {
          log("🟥 App opened from terminated state via notification");
          try {
            NotificationServiceHelper.handleNotificationTap(initialMessage.data);
          } catch (e) {
            log("❌ Error handling initial notification: $e");
          }
        }
        log("✅ Notification tap handlers setup");
      } catch (e) {
        log("⚠️ Could not setup notification tap handlers: $e");
      }
      
      log("🎯 Starting app UI...");
      runApp(MyApp(locale: locale));
      log("✅ App UI launched successfully");
      
    } catch (e, stackTrace) {
      log("💥 FATAL ERROR during initialization: $e");
      log("Stack trace: $stackTrace");
      
      // Even if initialization fails, try to run app with defaults
      try {
        runApp(MyApp(locale: const Locale('en')));
      } catch (e2) {
        log("💥 Could not recover from fatal error: $e2");
        // Show error screen as last resort
        runApp(MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to start app',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Error: $e',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
      }
    }
  }, (error, stackTrace) {
    // Catch any uncaught errors during app runtime
    log("💥 UNCAUGHT ERROR: $error");
    log("Stack trace: $stackTrace");
  });
}

class MyApp extends StatelessWidget {
  final Locale locale;
  const MyApp({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    // Check connection (non-blocking)
    try {
      APIService.checkConnection(context);
    } catch (e) {
      log("⚠️ Connection check failed: $e");
    }

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            // Dismiss keyboard on tap outside
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: GetMaterialApp(
            initialBinding: Allcontroller(),
            locale: locale,
            debugShowCheckedModeBanner: false,
            title: AppStrings.app_name,
            theme: ThemeData(
              scaffoldBackgroundColor: const Color.fromARGB(255, 235, 230, 230),
              textTheme: GoogleFonts.poppinsTextTheme(),
              highlightColor: AppColors.transparent,
              splashColor: AppColors.transparent,
              useMaterial3: true,
            ),
            scrollBehavior: CustomScrollBehavior(),
            home: SplashScreen(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('hi'), // Hindi
              Locale('ml'), // Malayalam
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
