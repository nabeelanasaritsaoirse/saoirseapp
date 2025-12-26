import 'dart:developer';
import 'dart:io';

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

/// 🔴 REQUIRED for iOS background notifications
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationServiceHelper.showFlutterNotification(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // -----------------------------
  // Storage
  // -----------------------------
  await GetStorage.init();

  // -----------------------------
  // ENV (SAFE)
  // -----------------------------
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("⚠️ dotenv load failed: $e");
  }

  // -----------------------------
  // Firebase (SAFE)
  // -----------------------------
  try {
    if (Platform.isIOS) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: dotenv.env['IOS_API_KEY']!,
          appId: dotenv.env['IOS_APP_ID']!,
          messagingSenderId: dotenv.env['IOS_MESSAGING_SENDER_ID']!,
          projectId: dotenv.env['IOS_PROJECT_ID']!,
        ),
      );
    } else {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: dotenv.env['ANDROID_API_KEY']!,
          appId: dotenv.env['ANDROID_APP_ID']!,
          messagingSenderId: dotenv.env['ANDROID_MESSAGING_SENDER_ID']!,
          projectId: dotenv.env['ANDROID_PROJECT_ID']!,
        ),
      );
    }
  } catch (e, s) {
    log("🔥 Firebase init failed", error: e, stackTrace: s);
  }

  // -----------------------------
  // Firebase Messaging
  // -----------------------------
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((message) {
    log("🟢 Foreground Msg: ${message.notification?.title}");
    NotificationServiceHelper.showFlutterNotification(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    log("🔵 Notification clicked");
    NotificationServiceHelper.handleNotificationTap(message.data);
  });

  final initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    log("🟥 Terminated → Notification tapped");
    NotificationServiceHelper.handleNotificationTap(initialMessage.data);
  }

  // -----------------------------
  // Local Notifications
  // -----------------------------
  await NotificationServiceHelper.initializeLocalNotifications();

  // -----------------------------
  // AppsFlyer (AFTER Firebase)
  // -----------------------------
  try {
    await AppsFlyerService.instance.init();
  } catch (e) {
    debugPrint("⚠️ AppsFlyer init failed: $e");
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
  // RUN APP (SAFE POINT)
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
            final currentFocus = FocusScope.of(context);
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
