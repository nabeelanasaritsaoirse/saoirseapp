import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

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

/// Storage
final GetStorage storage = GetStorage();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("🟡 Background Message Received");
  NotificationServiceHelper.showFlutterNotification(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await dotenv.load(fileName: ".env");

  /// -----------------------------
  /// FIREBASE INIT
  /// -----------------------------
  await Firebase.initializeApp(
    options: Platform.isIOS
        ? FirebaseOptions(
            apiKey: dotenv.env['IOS_API_KEY'] ?? '',
            appId: dotenv.env['IOS_APP_ID'] ?? '',
            messagingSenderId:
                dotenv.env['IOS_MESSAGING_SENDER_ID'] ?? '',
            projectId: dotenv.env['IOS_PROJECT_ID'] ?? '',
          )
        : FirebaseOptions(
            apiKey: dotenv.env['ANDROID_API_KEY'] ?? '',
            appId: dotenv.env['ANDROID_APP_ID'] ?? '',
            messagingSenderId:
                dotenv.env['ANDROID_MESSAGING_SENDER_ID'] ?? '',
            projectId: dotenv.env['ANDROID_PROJECT_ID'] ?? '',
          ),
  );

  /// 🔐 REQUIRED — FIXES OTP & GOOGLE SIGN-IN CRASH
  await FirebaseAppCheck.instance.activate(
    appleProvider: AppleProvider.debug, // TestFlight safe
    androidProvider: AndroidProvider.debug,
  );

  /// -----------------------------
  /// APPSFLYER (after Firebase)
  /// -----------------------------
  await AppsFlyerService.instance.init();

  /// -----------------------------
  /// MESSAGING
  /// -----------------------------
  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  await NotificationServiceHelper.initializeLocalNotifications();

  /// -----------------------------
  /// LANGUAGE
  /// -----------------------------
  final String lang = storage.read('language') ?? 'en';
  final Locale locale = Locale(lang);

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

  FirebaseMessaging.onMessage.listen((message) {
    NotificationServiceHelper.showFlutterNotification(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    NotificationServiceHelper.handleNotificationTap(message.data);
  });

  final initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    NotificationServiceHelper.handleNotificationTap(initialMessage.data);
  }

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
        return GetMaterialApp(
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
