import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '/screens/add_address/add_address_controller.dart';
import '/constants/app_colors.dart';
import '/widgets/app_button.dart';
import '/widgets/app_text.dart';
import '/widgets/app_text_field.dart';

class addAdress extends StatefulWidget {
  const addAdress({super.key});

  @override
  State<addAdress> createState() => _addAdressState();
}

class _addAdressState extends State<addAdress> {
  @override
  Widget build(BuildContext context) {
    AddAddressController addAddressController = Get.put(AddAddressController());

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back,
            color: AppColors.white,
            size: 30.sp,
          ),
          onTap: () => Navigator.pop(context),
        ),
        title: appText(
          "Add Address",
          color: AppColors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appText("Name", fontSize: 14.sp, fontWeight: FontWeight.w600),
            appTextField(
              controller: addAddressController.nameController,
              textColor: AppColors.black,
              hintText: "Name",
              hintColor: AppColors.grey,
            ),
            SizedBox(
              height: 10.h,
            ),
            appText("Street Name",
                fontSize: 14.sp, fontWeight: FontWeight.w600),
            appTextField(
              controller: addAddressController.streetNameController,
              textColor: AppColors.black,
              hintText: "Street Name",
              hintColor: AppColors.grey,
            ),
            SizedBox(
              height: 10.h,
            ),
            appText("City", fontSize: 14.sp, fontWeight: FontWeight.w600),
            appTextField(
              controller: addAddressController.cityController,
              textColor: AppColors.black,
              hintText: "City",
              hintColor: AppColors.grey,
            ),
            SizedBox(
              height: 10.h,
            ),
            appText("State / Province",
                fontSize: 14.sp, fontWeight: FontWeight.w600),
            appTextField(
              controller: addAddressController.stateController,
              textColor: AppColors.black,
              hintText: "State / Province",
              hintColor: AppColors.grey,
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      appText("Country",
                          fontSize: 14.sp, fontWeight: FontWeight.w600),
                      appTextField(
                        controller: addAddressController.CountryController,
                        textColor: AppColors.black,
                        hintText: "Country",
                        hintColor: AppColors.grey,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      appText("Zip Code",
                          fontSize: 14.sp, fontWeight: FontWeight.w600),
                      appTextField(
                        controller: addAddressController.zipController,
                        textColor: AppColors.black,
                        hintText: "Zip Code",
                        hintColor: AppColors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            appText("Phone Number",
                fontSize: 14.sp, fontWeight: FontWeight.w600),
            appTextField(
              controller: addAddressController.phoneController,
              textColor: AppColors.black,
              hintText: " Phone Number",
              hintColor: AppColors.grey,
            ),
            SizedBox(height: 25.h),
            appButton(
              child: appText("Save",
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white),
              buttonColor: AppColors.primaryColor,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
