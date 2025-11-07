// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


import '../home/home_screen.dart';
import '../signin/signin_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = GetStorage();

  // navigation
  void _splashScreen() {
    bool isLogin = box.read(AppConst.USER_ID) != null;

    Future.delayed(const Duration(seconds: 2), () {
      if (isLogin) {
        Get.offAll(() => const HomeScreen());
      } else {
        Get.offAll(() => const SignInScreen());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _splashScreen();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Example logo placeholder
              Icon(
                Icons.flutter_dash,
                size: 100,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 20),
              const Text(
                "Union App",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

// constants/app_constant.dart
class AppConst {
  static String USER_ID = 'User ID';
}






// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import 'package:http/http.dart' as storage;

// import '../../constants/app_constant.dart';

// import '../home/home_screen.dart';
// import '../signin/signin_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   //navigation
//   _splashScreen() {
//     bool isLogin = !(storage.read(AppConst.USER_ID) == null);

//     Future.delayed(const Duration(seconds: 2), () async {
//       if (isLogin) {
//         Get.offAll(() => const HomeScreen());
//       } else {
//         Get.offAll(() => const SignInScreen());
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();

//     _splashScreen();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Center(
//           // child: Image.asset(
//           //   AppAssets.app_logo,
//           //   height: 250.h,
//           //   width: Get.width,
//           //   fit: BoxFit.contain,
//           // ),
//         ),
//       ),
//     );
//   }
// }
