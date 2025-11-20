import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/custom_appbar.dart';
import 'eidit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  // ignore: use_super_parameters
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());

    void showCountryPickerDialog() {
      showCountryPicker(
        context: context,
        countryListTheme: CountryListThemeData(
          bottomSheetHeight: 600.h,
          backgroundColor: AppColors.white,
        ),
        onSelect: (country) {
          controller.updateCountry(country);
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: AppStrings.editLabel,
        showBack: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32.h),

              // Profile Image
              Center(
                child: Stack(
                  children: [
                    Obx(() {
                      return Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.grey,
                          image: DecorationImage(
                            image: controller.profileImage.value != null
                                ? FileImage(controller.profileImage.value!)
                                : const NetworkImage(
                                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
                                  ) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () => controller.pickProfileImage(),
                        child: Container(
                          width: 34.w,
                          height: 34.w,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: AppColors.white,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              // Full Name
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    appText(AppStrings.fullName,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBlack),
                    SizedBox(height: 8.h),
                    appTextField(
                      controller: controller.fullNameController,
                      prefixWidth: 20.w,
                      hintText: AppStrings.fullName,
                      hintColor: AppColors.black,
                      textColor: AppColors.black,
                      hintSize: 15.sp,
                      validator: controller.validateFullName,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15.h),

              // Phone Number
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.phoneNumber,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBlack,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        /// LEFT COUNTRY BOX
                        Obx(() {
                          final c = controller.country.value;

                          return GestureDetector(
                            onTap: showCountryPickerDialog,
                            child: Container(
                              width: 80.w,
                              height: 50.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: AppColors.shadowColor,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: c == null
                                  ? const SizedBox()
                                  : Text(
                                      "${c.flagEmoji} +${c.phoneCode}",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textBlack,
                                      ),
                                    ),
                            ),
                          );
                        }),

                        SizedBox(width: 12.w),

                        /// PHONE INPUT FIELD
                        Expanded(
                          child: appTextField(
                            controller: controller.phoneNumberController,
                            prefixWidth: 0,
                            hintText: AppStrings.phoneNumber,
                            textInputType: TextInputType.phone,
                            hintColor: AppColors.textBlack,
                            textColor: AppColors.textBlack,
                            textWeight: FontWeight.w500,
                            hintSize: 15.sp,
                            validator: controller.validatePhone,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15.h),

              // Email
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.email,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBlack,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    appTextField(
                      controller: controller.emailController,
                      prefixWidth: 20.w,
                      hintText: AppStrings.email,
                      hintColor: AppColors.black,
                      textColor: AppColors.black,
                      hintSize: 15.sp,
                      validator: controller.validateEmail,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 60.h),

              // SAVE BUTTON
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: appButton(
                    onTap: () => controller.saveChanges(),
                    width: double.infinity,
                    height: 54.h,
                    buttonColor: AppColors.primaryColor,
                    child: Center(
                      child: appText(AppStrings.saveChanges,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white),
                    )),
              ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
