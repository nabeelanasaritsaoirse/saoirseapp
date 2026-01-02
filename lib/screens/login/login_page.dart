import 'package:country_phone_validator/country_phone_validator.dart' as cpv;
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../constants/app_assets.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_toast.dart';
import '../otp/otp_screen.dart';
import '../refferal/qr_scanner.dart';
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
  LoginController loginController = Get.find<LoginController>();

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

  String extractReferral(String qrData) {
    Uri uri = Uri.parse(qrData);
    return uri.queryParameters["deep_link_value"] ?? qrData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
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
                      Row(
                        children: [
                          Expanded(
                            child: appTextField(
                              controller:
                                  loginController.referreltextController,
                              hintText: AppStrings.Referral_code,
                              enabled: true,
                              textColor: AppColors.black,
                              hintColor: AppColors.black,
                              hintSize: 15.sp,
                              prefixWidth: 20.w,
                              validator: (value) {
                                // Keep using LoginService.referralValidation (returns null if valid)
                                return LoginService.referralValidation(
                                    referral: value ?? "");
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.qr_code_scanner,
                                size: 32, color: AppColors.primaryColor),
                            onPressed: () => showQRPicker(),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Form(
                        key: loginController.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                return LoginService.usernameValidation(
                                    username: value ?? "");
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
                                  final fullNumber =
                                      loginController.fullPhoneNumber;
                                  appToast(content: fullNumber);
                                },
                                prefixWidth: 70.w,
                                hintText: AppStrings.phoneNumber,
                                textInputType: TextInputType.phone,
                                hintColor: AppColors.black,
                                textColor: AppColors.black,
                                hintSize: 15.sp,
                                validator: (value) {
                                  // final raw = value ?? "";
                                  // final digitsOnly =
                                  //     raw.trim().replaceAll(RegExp(r'\D'), '');

                                  // if (digitsOnly.isEmpty) {
                                  //   return "Phone number is required";
                                  // }

                                  // if (digitsOnly.length < 7 ||
                                  //     digitsOnly.length > 15) {
                                  //   return "Enter a valid phone number";
                                  // }

                                  // // Now call your service safely
                                  // int? serviceResult;
                                  // try {
                                  //   serviceResult =
                                  //       LoginService.phoneValidation(
                                  //     phone: int.parse(digitsOnly),
                                  //   );
                                  // } catch (e) {
                                  //   return "Enter a valid phone number";
                                  // }

                                  // // If service returns null → valid
                                  // if (serviceResult == null) return null;

                                  // // If service returns an int → convert to error text
                                  // return "Invalid phone number";
                                  final raw = value ?? "";
                                  final digitsOnly =
                                      raw.replaceAll(RegExp(r'\D'), '');

                                  final selectedCountry =
                                      loginController.country.value;
                                  if (digitsOnly.isEmpty) {
                                    return "Phone number is required";
                                  }
                                  if (selectedCountry == null) {
                                    return "Please select a country";
                                  }

                                  final dialCode =
                                      '+${selectedCountry.phoneCode}';
                                  // or selectedCountry.dialCode depending on your Country object

                                  final isValid =
                                      cpv.CountryUtils.validatePhoneNumber(
                                          digitsOnly, dialCode);

                                  if (!isValid) {
                                    return "Invalid number for ${selectedCountry.name}";
                                  }
                                  return null;
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
                                          // if (!loginController.validateInputs()) {

                                          //   return;
                                          // }
                                          if (!loginController
                                              .formKey.currentState!
                                              .validate()) {
                                            return;
                                          }

                                          loginController.loading.value =
                                              true; // START LOADING

                                          bool isSent =
                                              await AuthService.sendOTP(
                                            loginController.fullPhoneNumber,
                                          );

                                          loginController.loading.value =
                                              false; // STOP LOADING

                                          if (isSent) {
                                            Get.to(() => VerifyOTPScreen(
                                                  phoneNumber: loginController
                                                      .fullPhoneNumber,
                                                  referral: loginController
                                                      .referreltextController
                                                      .text,
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
                          ],
                        ),
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

  void scanQRWithCamera() {
    Get.to(() => QRScannerScreen(
          onReferralDetected: (value) {
            final code = extractReferral(value);
            loginController.referreltextController.text = code;
            loginController.update();
          },
        ));
  }

  Future<void> pickQRFromGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final MobileScannerController scanner = MobileScannerController();

    final BarcodeCapture? result = await scanner.analyzeImage(image.path);

    if (result != null && result.barcodes.isNotEmpty) {
      final value = result.barcodes.first.rawValue ?? "";
      final code = extractReferral(value);

      loginController.referreltextController.text = code;
      loginController.update();
    } else {}
  }

  void showQRPicker() {
    Get.bottomSheet(
      TweenAnimationBuilder(
        duration: Duration(milliseconds: 300),
        tween: Tween<double>(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, 50 * (1 - value)),
            child: Opacity(opacity: value, child: child),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: AppColors.black.withOpacity(0.2),
                blurRadius: 20.r,
                offset: Offset(0, -5),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Grab indicator
              Container(
                width: 50.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(height: 20.h),

              // Title
              Text(
                "Choose QR Method",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black87,
                ),
              ),
              SizedBox(height: 20.h),

              // Option 1 — Scan QR
              GestureDetector(
                onTap: () {
                  Get.back();
                  scanQRWithCamera();
                },
                child: Container(
                  padding: EdgeInsets.all(14),
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: AppColors.blueshade.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.qr_code_scanner,
                            size: 28, color: AppColors.primaryColor),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Text(
                          "Scan using Camera",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios,
                          size: 18.sp, color: AppColors.lightGrey),
                    ],
                  ),
                ),
              ),

              // Option 2 — Upload QR
              GestureDetector(
                onTap: () {
                  Get.back();
                  pickQRFromGallery();
                },
                child: Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: AppColors.blueshade.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.image,
                            size: 28.sp, color: AppColors.primaryColor),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          "Upload QR from Gallery",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios,
                          size: 18.sp, color: AppColors.lightGrey),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class ReferralUtils {
  static String extractReferral(String qrData) {
    Uri uri = Uri.parse(qrData);
    return uri.queryParameters["code"] ?? qrData;
  }
}
