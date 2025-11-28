// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/custom_appbar.dart';
import '../profile/profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Get.find<ProfileController>();
    controller.resetFormData();
  }

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(EditProfileController());
    final controller = Get.find<ProfileController>();

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
                      final user = controller.profile.value?.user;
                      final localImage = controller.profileImage.value;
                      return Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.grey,
                          image: DecorationImage(
                            image: localImage != null
                                ? FileImage(localImage) as ImageProvider
                                : (user!.profilePicture.isNotEmpty
                                    ? NetworkImage(user.profilePicture)
                                    : AssetImage(AppAssets.user_img)
                                        as ImageProvider),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
                    Obx(() {
                      return controller.isLoading.value
                          ? Container(
                              width: 120.w,
                              height: 120.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.4),
                              ),
                              child: Center(
                                child: SizedBox(
                                    width: 28.w,
                                    height: 28.w,
                                    child: appLoader()),
                              ),
                            )
                          : const SizedBox();
                    }),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () {
                          controller.pickProfileImage();
                        },
                        child: Container(
                          width: 34.w,
                          height: 34.w,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Iconsax.camera,
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
                      textInputType: TextInputType.name,
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
              Obx(() {
                if (!controller.showPhoneField.value) return SizedBox();
                return Padding(
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
                            return controller.showPhoneField.value
                                ? Container(
                                    width: 80.w,
                                    height: 50.h,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                          color: AppColors.shadowColor),
                                    ),
                                    child: Text(
                                      "${controller.country.value?.flagEmoji} +${controller.country.value?.phoneCode}",
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : SizedBox();
                          }),

                          SizedBox(width: 12.w),

                          /// PHONE INPUT FIELD
                          Expanded(
                            child: appTextField(
                              controller: controller.phoneNumberController,
                              prefixWidth: 0,
                              readOnly: true,
                              enabled: false,
                              validator: null,
                              hintText: AppStrings.phoneNumber,
                              textInputType: TextInputType.phone,
                              hintColor: AppColors.textBlack,
                              textColor: AppColors.textBlack,
                              textWeight: FontWeight.w500,
                              hintSize: 15.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),

              SizedBox(height: 15.h),

              // Email
              Obx(() {
                if (!controller.showEmailField.value) return SizedBox();
                return Padding(
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
                        readOnly: true, // 🔥 IMPORTANT
                        enabled: false, // 🔥 Important
                        validator: null,
                        prefixWidth: 20.w,
                        hintText: AppStrings.email,
                        textInputType: TextInputType.emailAddress,
                        hintColor: AppColors.black,
                        textColor: AppColors.black,
                        hintSize: 15.sp,
                      ),
                    ],
                  ),
                );
              }),

              SizedBox(height: 60.h),

              // SAVE BUTTON
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Obx(() {
                  return appButton(
                    onTap: controller.isLoading.value
                        ? () {}
                        : () {
                            controller.updateUserName();
                            Get.back();
                          },
                    width: double.infinity,
                    height: 54.h,
                    buttonColor: AppColors.primaryColor,
                    child: Center(
                      child: controller.isLoading.value
                          ? SizedBox(
                              width: 26.w,
                              height: 26.w,
                              child: appLoader(),
                            )
                          : appText(
                              AppStrings.saveChanges,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                    ),
                  );
                }),
              ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
