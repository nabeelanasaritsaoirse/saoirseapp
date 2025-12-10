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
  NotificationServiceHelper.showFlutterNotification(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await AppsFlyerService.instance.init();
  await dotenv.load(fileName: ".env");
  Platform.isIOS
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
          apiKey: dotenv.env['IOS_API_KEY'] ?? '',
          appId: dotenv.env['IOS_APP_ID'] ?? '',
          messagingSenderId: dotenv.env['IOS_MESSAGING_SENDER_ID'] ?? '',
          projectId: dotenv.env['IOS_PROJECT_ID'] ?? '',
        ))
      : await Firebase.initializeApp(
          options: FirebaseOptions(
          apiKey: dotenv.env['ANDROID_API_KEY'] ?? '',
          appId: dotenv.env['ANDROID_APP_ID'] ?? '',
          messagingSenderId: dotenv.env['ANDROID_MESSAGING_SENDER_ID'] ?? '',
          projectId: dotenv.env['ANDROID_PROJECT_ID'] ?? '',
        ));

  // Background handler registration
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Request permission
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
      designSize: const Size(360, 690), //required for ScreenUtil
      minTextAdapt: true, // prevents text overflow
      splitScreenMode: true, //fixes _splitScreenMode not initialized
      useInheritedMediaQuery: true, //keeps correct context in GetX
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

            // optional - default locale

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
