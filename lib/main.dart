import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

// storage instance
GetStorage storage = GetStorage();

/// Needed so iOS can call this from a background isolate.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Flutter & Firebase are available in background isolate.
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    // Uses platform-default options:
    // - iOS: GoogleService-Info.plist
    // - Android: google-services.json / options
    await Firebase.initializeApp();
  }

  log("🟡 Background Message Received: ${message.notification?.title}");
  NotificationServiceHelper.showFlutterNotification(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await AppsFlyerService.instance.init();

  // ❌ Do NOT rely on .env for iOS Firebase config in release.
  // iOS must use GoogleService-Info.plist so PhoneAuth works reliably.[web:50][web:53]
  if (!Platform.isIOS) {
    await dotenv.load(fileName: ".env");
  }

  // 🌐 Firebase initialization
  if (Platform.isIOS) {
    // ✅ Uses GoogleService-Info.plist bundled in ios/Runner.[web:50][web:57]
    await Firebase.initializeApp();
  } else {
    // ✅ Android still uses .env-based options.
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: dotenv.env['ANDROID_API_KEY'] ?? '',
        appId: dotenv.env['ANDROID_APP_ID'] ?? '',
        messagingSenderId: dotenv.env['ANDROID_MESSAGING_SENDER_ID'] ?? '',
        projectId: dotenv.env['ANDROID_PROJECT_ID'] ?? '',
      ),
    );
  }

  // 🔴 Important for PhoneAuth stability on iOS 17/18.
  await FirebaseAuth.instance.setSettings(
    appVerificationDisabledForTesting: false,
  );

  // Background handler registration (after Firebase.initializeApp).
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Request notification permission (needed for APNs + PhoneAuth flow on iOS).[web:6]
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // 📌 Local Notification Initialization
  await NotificationServiceHelper.initializeLocalNotifications();

  String? lang = storage.read('language') ?? 'en';
  Locale locale = Locale(lang);

  // 🔥 REGISTER CONTROLLERS FIRST
  final notif = Get.put(NotificationController(), permanent: true);

  // Restore token if already logged in
  final savedToken = storage.read(AppConst.ACCESS_TOKEN);
  if (savedToken != null) {
    notif.updateToken(savedToken);
    notif.refreshNotifications();
    notif.fetchUnreadCount();
  }

  // 🟢 Foreground message listener
  FirebaseMessaging.onMessage.listen((message) {
    log("🟢 Foreground Msg Received: ${message.notification?.title}");
    NotificationServiceHelper.showFlutterNotification(message);
  });

  // 🔵 User taps notification (when app is in background)
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    log("🔵 Notification clicked: ${message.data}");
    NotificationServiceHelper.handleNotificationTap(message.data);
  });

  // 🔴 Terminated → user taps notification
  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    log("🟥 Terminated state → Notification tapped");
    NotificationServiceHelper.handleNotificationTap(initialMessage.data);
  }

  runApp(MyApp(locale: locale));
}

class MyApp extends StatelessWidget {
  final Locale locale;
  const MyApp({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    // optional: if APIService needs context later, move it to HomeScreen
    APIService.checkConnection(context);

    return ScreenUtilInit(
      designSize: const Size(360, 690), // required for ScreenUtil
      minTextAdapt: true, // prevents text overflow
      splitScreenMode: true, // fixes _splitScreenMode not initialized
      useInheritedMediaQuery: true, // keeps correct context in GetX
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
              scaffoldBackgroundColor:
                  const Color.fromARGB(255, 235, 230, 230),
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
    // Use BouncingScrollPhysics everywhere
    return const BouncingScrollPhysics();
  }

  // Optional: remove overscroll glow on Android
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
