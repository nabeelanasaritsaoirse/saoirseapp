import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_strings.dart';
import '../../widgets/custom_appbar.dart';
import '/screens/add_address/add_address_controller.dart';
import '/constants/app_colors.dart';
import '/widgets/app_button.dart';
import '/widgets/app_text.dart';
import '/widgets/app_text_field.dart';
import 'add_address_validation.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AddAddressController addAddressController = Get.find<AddAddressController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: CustomAppBar(
        title: AppStrings.add_address_label,
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
                    EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
                validator: (value) =>
                    AddAddressValidation.nameValidation(name: value ?? ""),
              ),
              SizedBox(height: 10.h),
              appText(AppStrings.StreetName,
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
                    EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
                validator: (value) =>
                    AddAddressValidation.streetValidation(street: value ?? ""),
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
                    EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
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
                    EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
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
                              vertical: 13.h, horizontal: 10.w),
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
                        appText(AppStrings.ZipCode,
                            fontSize: 14.sp, fontWeight: FontWeight.w600),
                        SizedBox(
                          height: 5.h,
                        ),
                        appTextField(
                          controller: addAddressController.zipController,
                          textColor: AppColors.black,
                          textInputType: TextInputType.number,
                          hintText: AppStrings.ZipCode,
                          hintColor: AppColors.grey,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 13.h, horizontal: 10.w),
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
                height: 5.h,
              ),
              appTextField(
                controller: addAddressController.phoneController,
                textColor: AppColors.black,
                textInputType: TextInputType.phone,
                hintText: AppStrings.phoneNumber,
                hintColor: AppColors.grey,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
                validator: (value) => AddAddressValidation.phoneValidation(
                    phone: value?.trim() ?? ""),
              ),
              SizedBox(height: 25.h),
              appButton(
                child: appText(AppStrings.Save,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white),
                buttonColor: AppColors.primaryColor,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    addAddressController.saveAddress();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
