import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants/app_colors.dart';
import 'constants/app_strings.dart';
import 'l10n/app_localizations.dart';
import 'screens/splash/splash_screen.dart';

GetStorage storage = GetStorage();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Platform.isIOS
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
          apiKey: 'AIzaSyDpQb5HVM28WGffCCwrMmNs9luxSMFyaBY',
          appId: '1:486829564070:ios:07e32a618113ab29479467',
          messagingSenderId: '486829564070',
          projectId: 'saoirse-epi',
        ))
      : await Firebase.initializeApp();
  String? lang = storage
      .read('language'); // ✅ use the GetStorage instance you already defined
  Locale locale = lang != null ? Locale(lang) : const Locale('en');

  runApp(MyApp(locale: locale));
}

class MyApp extends StatelessWidget {
  final Locale locale;
  const MyApp({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    // optional: if APIService needs context later, move it to HomeScreen
    // APIService.checkConnection(context);

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
              useMaterial3: true, // optional modern UI
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
