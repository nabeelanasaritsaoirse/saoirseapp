// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_strings.dart';
import '../../models/address_response.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/custom_appbar.dart';
import '/screens/add_address/add_address_controller.dart';
import '/constants/app_colors.dart';
import '/widgets/app_button.dart';
import '/widgets/app_text.dart';
import '/widgets/app_text_field.dart';
import 'add_address_validation.dart';

class AddAddress extends StatefulWidget {
  final Address? address;
  const AddAddress({super.key, this.address});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final _formKey = GlobalKey<FormState>();
  late AddAddressController addAddressController;

  @override
  void initState() {
    super.initState();
    addAddressController = Get.find<AddAddressController>();

    if (widget.address != null) {
      addAddressController.setEditAddress(widget.address!);
    }
  }

  @override
  Widget build(BuildContext context) {
    AddAddressController addAddressController =
        Get.find<AddAddressController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: CustomAppBar(
        title: addAddressController.isEdit.value
            ? "Edit Address"
            : AppStrings.add_address_label,
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appText(AppStrings.Name,
                  fontSize: 14.sp, fontWeight: FontWeight.w600),
              SizedBox(
                height: 5.h,
              ),
              appTextField(
                controller: addAddressController.nameController,
                textColor: AppColors.black,
                textInputType: TextInputType.name,
                hintText: AppStrings.Name,
                hintColor: AppColors.grey,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                validator: (value) =>
                    AddAddressValidation.nameValidation(name: value ?? ""),
              ),
              SizedBox(height: 10.h),
              appText("Address Line 1",
                  fontSize: 14.sp, fontWeight: FontWeight.w600),
              SizedBox(
                height: 5.h,
              ),
              appTextField(
                controller: addAddressController.streetNameController,
                textColor: AppColors.black,
                hintText: AppStrings.StreetName,
                textInputType: TextInputType.streetAddress,
                hintColor: AppColors.grey,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                validator: (value) =>
                    AddAddressValidation.streetValidation(street: value ?? ""),
              ),
              SizedBox(height: 10.h),
              appText("Address Line 2 (Optional)",
                  fontSize: 14.sp, fontWeight: FontWeight.w600),
              SizedBox(height: 5.h),
              appTextField(
                controller: addAddressController.addressLine2Controller,
                textColor: AppColors.black,
                hintText: "Address Line 2",
                textInputType: TextInputType.streetAddress,
                hintColor: AppColors.grey,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              ),
              SizedBox(height: 10.h),
              appText("Landmark (Optional)",
                  fontSize: 14.sp, fontWeight: FontWeight.w600),
              SizedBox(height: 5.h),
              appTextField(
                controller: addAddressController.landmarkController,
                textColor: AppColors.black,
                hintText: "Landmark",
                hintColor: AppColors.grey,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              ),
              SizedBox(height: 10.h),
              appText(AppStrings.City,
                  fontSize: 14.sp, fontWeight: FontWeight.w600),
              SizedBox(
                height: 5.h,
              ),
              appTextField(
                controller: addAddressController.cityController,
                textColor: AppColors.black,
                textInputType: TextInputType.name,
                hintText: AppStrings.City,
                hintColor: AppColors.grey,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                validator: (value) =>
                    AddAddressValidation.cityValidation(city: value ?? ""),
              ),
              SizedBox(height: 10.h),
              appText(AppStrings.State,
                  fontSize: 14.sp, fontWeight: FontWeight.w600),
              SizedBox(
                height: 5.h,
              ),
              appTextField(
                controller: addAddressController.stateController,
                textColor: AppColors.black,
                hintText: AppStrings.State,
                textInputType: TextInputType.text,
                hintColor: AppColors.grey,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                validator: (value) =>
                    AddAddressValidation.stateValidation(state: value ?? ""),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        appText(AppStrings.Country,
                            fontSize: 14.sp, fontWeight: FontWeight.w600),
                        SizedBox(
                          height: 5.h,
                        ),
                        appTextField(
                          controller: addAddressController.countryController,
                          textColor: AppColors.black,
                          textInputType: TextInputType.text,
                          hintText: AppStrings.Country,
                          hintColor: AppColors.grey,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 10.w),
                          validator: (value) =>
                              AddAddressValidation.countryValidation(
                                  country: value ?? ""),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        appText(AppStrings.PinCode,
                            fontSize: 14.sp, fontWeight: FontWeight.w600),
                        SizedBox(
                          height: 5.h,
                        ),
                        appTextField(
                          controller: addAddressController.pinController,
                          textColor: AppColors.black,
                          textInputType: TextInputType.number,
                          hintText: AppStrings.PinCode,
                          hintColor: AppColors.grey,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 10.w),
                          validator: (value) =>
                              AddAddressValidation.zipValidation(
                                  zip: value ?? ""),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              appText(AppStrings.phoneNumber,
                  fontSize: 14.sp, fontWeight: FontWeight.w600),
              SizedBox(
                height: 10.h,
              ),
              appTextField(
                controller: addAddressController.phoneController,
                textColor: AppColors.black,
                textInputType: TextInputType.phone,
                hintText: AppStrings.phoneNumber,
                hintColor: AppColors.grey,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                validator: (value) => AddAddressValidation.phoneValidation(
                    phone: value?.trim() ?? ""),
              ),
              SizedBox(height: 15.h),
              appText("Address Type",
                  fontSize: 14.sp, fontWeight: FontWeight.w600),
              SizedBox(height: 5.h),
              Row(
                children: [
                  _typeChip("home"),
                  SizedBox(width: 10.w),
                  _typeChip("work"),
                  SizedBox(width: 10.w),
                  _typeChip("other"),
                ],
              ),
              SizedBox(height: 10.h),
              Obx(() => Row(
                    children: [
                      Checkbox(
                        activeColor: AppColors.primaryColor,
                        value: addAddressController.isDefaultAddress.value,
                        onChanged: (value) {
                          /// 🚨 USER TRYING TO UNCHECK DEFAULT ADDRESS
                          if (addAddressController.isEdit.value &&
                              addAddressController.initialIsDefault == true &&
                              value == false) {
                            appToaster(
                              error: true,
                              content:
                                  "At least 1 address should be set as default",
                            );

                            return; // ⛔ DON'T CHANGE VALUE
                          }

                          /// ✅ OTHERWISE ALLOW
                          addAddressController.isDefaultAddress.value =
                              value ?? false;
                        },
                      ),
                      appText(
                        "Save as Default",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  )),
              SizedBox(height: 10.h),
              appButton(
                buttonColor: AppColors.primaryColor,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    addAddressController.saveAddress();
                  }
                },
                child: Obx(() {
                  // ✅ Rx is READ here
                  if (addAddressController.isLoading.value) {
                    return SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    );
                  }

                  return appText(
                    AppStrings.Save,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _typeChip(String type) {
    final controller = Get.find<AddAddressController>();

    IconData icon;
    switch (type) {
      case "home":
        icon = Icons.home_rounded;
        break;
      case "work":
        icon = Icons.work_rounded;
        break;
      default:
        icon = Icons.location_on_rounded;
    }

    return Obx(() {
      final isSelected = controller.addressType.value == type;

      return GestureDetector(
        onTap: () => controller.addressType.value = type,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color:
                isSelected ? AppColors.primaryColor : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.30),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 17.sp,
                color: isSelected ? Colors.white : Colors.grey.shade500,
              ),
              SizedBox(width: 6.w),
              appText(
                type.capitalizeFirst!,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
            ],
          ),
        ),
      );
    });
  }
}
