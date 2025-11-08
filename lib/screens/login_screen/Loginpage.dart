import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

import 'package:saoirse_app/constants/app_colors.dart';
import 'package:saoirse_app/widgets/app_button.dart';
import 'package:saoirse_app/widgets/app_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    color: AppColors.primaryColor,

                    onPressed: () {
                      // BACK BUTTON FUNCTION
                    },
                  ),
                  SizedBox(height: 12.h),
                  appText(
                    "Let’s you log in",
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                    fontSize: 28.sp,
                    // fontStyle:  GoogleFonts.poppinsTextTheme(),
                  ),

                  SizedBox(height: 6.h),
                  appText(
                    "Welcome back you have been missed",

                    color: AppColors.textBlack,
                    fontSize: 14.sp,
                    // fontStyle: GoogleFonts.poppinsTextTheme(),
                  ),

                  SizedBox(height: 28.h),

                  TextFormField(
                    // controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      hintText: "eg. Admin@1234",
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.h),

                  TextFormField(
                    // controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "eg. Admin82200",
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.visibility_rounded),
                        onPressed: () {
                          // PASSWORD VISIBILITY FUNCTION
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: appText(
                        "Forget Password..?",
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                        // fontStyle: GoogleFonts.poppinsTextTheme(),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),

                  appButton(
                    onTap: () {
                      log("loginbutton");
                      //  LOGIN BUTTON FUNCTION
                    },
                    buttonColor: AppColors.primaryColor,
                    buttonText: "LOGIN",
                    textColor: AppColors.white,
                    height: 40.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
