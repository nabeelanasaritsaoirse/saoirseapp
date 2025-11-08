import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saoirse_app/screens/home/home_screen.dart';

import 'constants/app_colors.dart';
import 'constants/app_strings.dart';
import 'services/api_service.dart';

final storage = GetStorage();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            debugShowCheckedModeBanner: false,
            title: AppStrings.app_name,
            theme: ThemeData(
              scaffoldBackgroundColor: AppColors.scaffoldColor,
              textTheme: GoogleFonts.poppinsTextTheme(),
              highlightColor: AppColors.transparent,
              splashColor: AppColors.transparent,
              useMaterial3: true, // optional modern UI
            ),
            scrollBehavior: CustomScrollBehavior(),
            home: const HomeScreen(), // ✅ fixed const
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
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
