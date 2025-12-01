// ignore_for_file: avoid_print

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_assets.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_toast.dart';
import '../otp/otp_screen.dart';
import '/constants/app_colors.dart';
import '/constants/app_strings.dart';
import '/screens/login/login_controller.dart';
import '/services/login_service.dart';
import '/widgets/app_button.dart';
import '/widgets/app_text.dart';
import '/widgets/app_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController loginController = Get.put(LoginController());

  Country? country;

  void showCountryPickerDialog(BuildContext context) {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        bottomSheetHeight: 600.h,
        backgroundColor: AppColors.white,
      ),
      onSelect: (country) {
        loginController.updateCountry(country);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.h),
              child: SingleChildScrollView(
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30.h),
                      appText(
                        AppStrings.login_title,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                        fontSize: 28.sp,
                        fontFamily: "Poppins",
                      ),
                      SizedBox(height: 6.h),
                      appText(
                        AppStrings.login_note,
                        color: AppColors.textBlack,
                        fontSize: 14.sp,
                      ),
                      SizedBox(height: 28.h),
                      appText(
                        AppStrings.Referral_code,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                        fontSize: 15.sp,
                        fontFamily: "Poppins",
                      ),
                      appTextField(
                        controller: loginController.referrelController,
                        prefixWidth: 20.w,
                        hintText: AppStrings.Referral_code,
                        hintColor: AppColors.black,
                        textColor: AppColors.black,
                        hintSize: 15.sp,
                        validator: (value) {
                          // Keep using LoginService.referralValidation (returns null if valid)
                          return LoginService.referralValidation(referral: value ?? "");
                        },
                      ),
                      SizedBox(height: 15.h),
                      appText(
                        "Username",
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                        fontSize: 15.sp,
                        fontFamily: "Poppins",
                      ),
                      appTextField(
                        controller: loginController.emailController,
                        suffixWidget: Icon(
                          Icons.visibility_rounded,
                          color: AppColors.black,
                        ),
                        prefixWidth: 20.w,
                        hintText: "Username",
                        hintColor: AppColors.black,
                        textColor: AppColors.black,
                        hintSize: 15.sp,
                        validator: (value) {
                          return LoginService.usernameValidation(username: value ?? "");
                        },
                      ),
                      SizedBox(height: 15.h),
                      appText(
                        AppStrings.phoneNumber,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                        fontSize: 15.sp,
                        fontFamily: "Poppins",
                      ),
                      Obx(() {
                        if (loginController.loading.value &&
                            loginController.country.value == null) {
                          // Still waiting for API (max 5 sec)
                          return const Center(
                            child: CircularProgressIndicator(
                                color: AppColors.primaryColor),
                          );
                        }

                        final country = loginController.country.value;

                        return appTextField(
                          controller: loginController.phoneController,
                          onFieldSubmitted: (phoneNumber) {
                            final fullNumber = loginController.fullPhoneNumber;
                            appToast(content: fullNumber);
                          },
                          prefixWidth: 70.w,
                          hintText: AppStrings.phoneNumber,
                          hintColor: AppColors.black,
                          textColor: AppColors.black,
                          hintSize: 15.sp,
                          validator: (value) {
  final raw = value ?? "";
  final digitsOnly = raw.trim().replaceAll(RegExp(r'\D'), '');

  if (digitsOnly.isEmpty) {
    return "Phone number is required";
  }

  if (digitsOnly.length < 7 || digitsOnly.length > 15) {
    return "Enter a valid phone number";
  }

  // Now call your service safely
  int? serviceResult;
  try {
    serviceResult = LoginService.phoneValidation(
      phone: int.parse(digitsOnly),
    );
  } catch (e) {
    return "Enter a valid phone number";
  }

  // If service returns null → valid
  if (serviceResult == null) return null;

  // If service returns an int → convert to error text
  return "Invalid phone number";
},

                          prefixWidget: GestureDetector(
                            onTap: () => showCountryPickerDialog(context),
                            child: Container(
                              height: 55.h,
                              alignment: Alignment.center,
                              child: Text(
                                // defensive access to avoid unexpected null errors
                                "${country?.flagEmoji ?? ''}+${country?.phoneCode ?? ''}",
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: 15.h),
                      Center(
                        child: Obx(() {
                          return loginController.loading.value
                              ? SizedBox(
                                  height: 40.h,
                                  width: 150.w,
                                  child: Center(
                                    child: appLoader(),
                                  ),
                                )
                              : appButton(
                                  onTap: () async {
                                    print("[SEND OTP BUTTON PRESSED]");

                                    if (!loginController.validateInputs()) {
                                      print("Validation Failed");
                                      return;
                                    }

                                    loginController.loading.value =
                                        true; // START LOADING

                                    print("✔ Validation Passed");
                                    print(
                                        "Phone Number = ${loginController.fullPhoneNumber}");

                                    bool isSent = await AuthService.sendOTP(
                                      loginController.fullPhoneNumber,
                                    );

                                    print("📨 sendOTP Result: $isSent");

                                    loginController.loading.value =
                                        false; // STOP LOADING

                                    if (isSent) {
                                      print("Navigating to VerifyOTPScreen");
                                      Get.to(() => VerifyOTPScreen(
                                            phoneNumber:
                                                loginController.fullPhoneNumber,
                                            referral: loginController
                                                .referrelController.text,
                                            username: loginController
                                                .emailController.text,
                                          ));
                                    }
                                  },
                                  buttonColor: AppColors.primaryColor,
                                  buttonText: AppStrings.send_otp,
                                  textColor: AppColors.white,
                                  height: 40.h,
                                  width: 150.w,
                                );
                        }),
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1.h,
                              width: 20.w,
                              color: AppColors.grey,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          appText(
                            "or",
                            color: AppColors.black,
                            fontSize: 15.sp,
                            fontFamily: "Poppins",
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Container(
                              height: 1.h,
                              width: 20.w,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Center(
                        child: appButton(
                          onTap: () {
                            loginController.googleLogin();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppAssets.google_icon,
                                height: 20.h,
                                width: 20.w,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 10.w),
                              appText(
                                AppStrings.LoginWithGoogle,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryColor,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          buttonColor: AppColors.white,
                          borderColor: AppColors.primaryColor,
                          borderWidth: 2,
                          width: 200.w,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Obx(() {
            return Visibility(
              visible: loginController.loading.value,
              child: appLoader(),
            );
          }),
        ],
      ),
    );
  }
}



// // ignore_for_file: avoid_print

// import 'package:country_picker/country_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import '../../constants/app_assets.dart';
// import '../../services/auth_service.dart';
// import '../../widgets/app_loader.dart';
// import '../../widgets/app_toast.dart';
// import '../otp/otp_screen.dart';
// import '/constants/app_colors.dart';
// import '/constants/app_strings.dart';
// import '/screens/login/login_controller.dart';
// import '/services/login_service.dart';
// import '/widgets/app_button.dart';
// import '/widgets/app_text.dart';
// import '/widgets/app_text_field.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   LoginController loginController = Get.put(LoginController());

//   Country? country;

//   void showCountryPickerDialog(BuildContext context) {
//     showCountryPicker(
//       context: context,
//       countryListTheme: CountryListThemeData(
//         bottomSheetHeight: 600.h,
//         backgroundColor: AppColors.white,
//       ),
//       onSelect: (country) {
//         loginController.updateCountry(country);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Stack(
//         children: [
//           SafeArea(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.h),
//               child: SingleChildScrollView(
//                 child: Form(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 30.h),
//                       appText(
//                         AppStrings.login_title,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.primaryColor,
//                         fontSize: 28.sp,
//                         fontFamily: "Poppins",
//                       ),
//                       SizedBox(height: 6.h),
//                       appText(
//                         AppStrings.login_note,
//                         color: AppColors.textBlack,
//                         fontSize: 14.sp,
//                       ),
//                       SizedBox(height: 28.h),
//                       appText(
//                         AppStrings.Referral_code,
//                         fontWeight: FontWeight.w500,
//                         color: AppColors.primaryColor,
//                         fontSize: 15.sp,
//                         fontFamily: "Poppins",
//                       ),
//                       appTextField(
//                         controller: loginController.referrelController,
//                         prefixWidth: 20.w,
//                         hintText: AppStrings.Referral_code,
//                         hintColor: AppColors.black,
//                         textColor: AppColors.black,
//                         hintSize: 15.sp,
//                         validator: (value) {
//                           return LoginService.referralValidation(
//                               referral: value!);
//                         },
//                       ),
//                       SizedBox(height: 15.h),
//                       appText(
//                         "Username",
//                         fontWeight: FontWeight.w500,
//                         color: AppColors.primaryColor,
//                         fontSize: 15.sp,
//                         fontFamily: "Poppins",
//                       ),
//                       appTextField(
//                         controller: loginController.emailController,
//                         suffixWidget: Icon(
//                           Icons.visibility_rounded,
//                           color: AppColors.black,
//                         ),
//                         prefixWidth: 20.w,
//                         hintText: "Username",
//                         hintColor: AppColors.black,
//                         textColor: AppColors.black,
//                         hintSize: 15.sp,
//                         validator: (value) {
//                           return LoginService.usernameValidation(
//                               username: value!);
//                         },
//                       ),
//                       SizedBox(height: 15.h),
//                       appText(
//                         AppStrings.phoneNumber,
//                         fontWeight: FontWeight.w500,
//                         color: AppColors.primaryColor,
//                         fontSize: 15.sp,
//                         fontFamily: "Poppins",
//                       ),
//                       Obx(() {
//                         if (loginController.loading.value &&
//                             loginController.country.value == null) {
//                           // Still waiting for API (max 5 sec)
//                           return const Center(
//                             child: CircularProgressIndicator(
//                                 color: AppColors.primaryColor),
//                           );
//                         }

//                         final country = loginController.country.value;

//                         return appTextField(
//                           controller: loginController.phoneController,
//                           onFieldSubmitted: (phoneNumber) {
//                             final fullNumber = loginController.fullPhoneNumber;
//                             appToast(content: fullNumber);
//                           },
//                           prefixWidth: 70.w,
//                           hintText: AppStrings.phoneNumber,
//                           hintColor: AppColors.black,
//                           textColor: AppColors.black,
//                           hintSize: 15.sp,
//                           validator: (value) {
//                             return LoginService.phoneValidation(
//                               phone: int.parse(value!),
//                             ).toString();
//                           },
//                           prefixWidget: GestureDetector(
//                             onTap: () => showCountryPickerDialog(context),
//                             child: Container(
//                               height: 55.h,
//                               alignment: Alignment.center,
//                               child: Text(
//                                 "${country!.flagEmoji}+${country.phoneCode}",
//                                 style: TextStyle(
//                                   color: AppColors.black,
//                                   fontSize: 15.sp,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       }),
//                       SizedBox(height: 15.h),
//                       Center(
//                         child: Obx(() {
//                           return loginController.loading.value
//                               ? SizedBox(
//                                   height: 40.h,
//                                   width: 150.w,
//                                   child: Center(
//                                     child: appLoader(),
//                                   ),
//                                 )
//                               : appButton(
//                                   onTap: () async {
//                                     print("[SEND OTP BUTTON PRESSED]");

//                                     if (!loginController.validateInputs()) {
//                                       print("Validation Failed");
//                                       return;
//                                     }

//                                     loginController.loading.value =
//                                         true; // START LOADING

//                                     print("✔ Validation Passed");
//                                     print(
//                                         "Phone Number = ${loginController.fullPhoneNumber}");

//                                     bool isSent = await AuthService.sendOTP(
//                                       loginController.fullPhoneNumber,
//                                     );

//                                     print("📨 sendOTP Result: $isSent");

//                                     loginController.loading.value =
//                                         false; // STOP LOADING

//                                     if (isSent) {
//                                       print("Navigating to VerifyOTPScreen");
//                                       Get.to(() => VerifyOTPScreen(
//                                             phoneNumber:
//                                                 loginController.fullPhoneNumber,
//                                             referral: loginController
//                                                 .referrelController.text,
//                                             username: loginController
//                                                 .emailController.text,
//                                           ));
//                                     }
//                                   },
//                                   buttonColor: AppColors.primaryColor,
//                                   buttonText: AppStrings.send_otp,
//                                   textColor: AppColors.white,
//                                   height: 40.h,
//                                   width: 150.w,
//                                 );
//                         }),
//                       ),
//                       SizedBox(height: 15.h),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Container(
//                               height: 1.h,
//                               width: 20.w,
//                               color: AppColors.grey,
//                             ),
//                           ),
//                           SizedBox(width: 10.w),
//                           appText(
//                             "or",
//                             color: AppColors.black,
//                             fontSize: 15.sp,
//                             fontFamily: "Poppins",
//                           ),
//                           SizedBox(width: 10.w),
//                           Expanded(
//                             child: Container(
//                               height: 1.h,
//                               width: 20.w,
//                               color: AppColors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 15.h),
//                       Center(
//                         child: appButton(
//                           onTap: () {
//                             loginController.googleLogin();
//                           },
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image.asset(
//                                 AppAssets.google_icon,
//                                 height: 20.h,
//                                 width: 20.w,
//                                 fit: BoxFit.cover,
//                               ),
//                               SizedBox(width: 10.w),
//                               appText(
//                                 AppStrings.LoginWithGoogle,
//                                 fontSize: 16.sp,
//                                 fontWeight: FontWeight.w500,
//                                 color: AppColors.primaryColor,
//                               ),
//                             ],
//                           ),
//                           padding: EdgeInsets.symmetric(vertical: 5.h),
//                           buttonColor: AppColors.white,
//                           borderColor: AppColors.primaryColor,
//                           borderWidth: 2,
//                           width: 200.w,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Obx(() {
//             return Visibility(
//               visible: loginController.loading.value,
//               child: appLoader(),
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }
