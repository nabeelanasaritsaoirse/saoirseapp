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
    AddAddressController addAddressController = Get.put(AddAddressController());

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
              appTextField(
                controller: addAddressController.nameController,
                textColor: AppColors.black,
                hintText: AppStrings.Name,
                hintColor: AppColors.grey,
                validator: (value) =>
                    AddAddressValidation.nameValidation(name: value ?? ""),
              ),
              SizedBox(height: 10.h),

              appText(AppStrings.StreetName,
                  fontSize: 14.sp, fontWeight: FontWeight.w600),
              appTextField(
                controller: addAddressController.streetNameController,
                textColor: AppColors.black,
                hintText: AppStrings.StreetName,
                hintColor: AppColors.grey,
                validator: (value) =>
                    AddAddressValidation.streetValidation(street: value ?? ""),
              ),
              SizedBox(height: 10.h),

              appText(AppStrings.City,
                  fontSize: 14.sp, fontWeight: FontWeight.w600),
              appTextField(
                controller: addAddressController.cityController,
                textColor: AppColors.black,
                hintText: AppStrings.City,
                hintColor: AppColors.grey,
                validator: (value) =>
                    AddAddressValidation.cityValidation(city: value ?? ""),
              ),
              SizedBox(height: 10.h),

              appText(AppStrings.State,
                  fontSize: 14.sp, fontWeight: FontWeight.w600),
              appTextField(
                controller: addAddressController.stateController,
                textColor: AppColors.black,
                hintText: AppStrings.State,
                hintColor: AppColors.grey,
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
                        appTextField(
                          controller: addAddressController.countryController,
                          textColor: AppColors.black,
                          hintText: AppStrings.Country,
                          hintColor: AppColors.grey,
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
                        appTextField(
                          controller: addAddressController.zipController,
                          textColor: AppColors.black,
                          hintText: AppStrings.ZipCode,
                          hintColor: AppColors.grey,
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
              appTextField(
                controller: addAddressController.phoneController,
                textColor: AppColors.black,
                hintText: AppStrings.phoneNumber,
                hintColor: AppColors.grey,
                validator: (value) =>
                    AddAddressValidation.phoneValidation(
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










