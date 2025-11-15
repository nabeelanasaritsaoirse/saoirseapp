import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/constants/app_colors.dart';
import '/widgets/app_button.dart';
import '/widgets/app_text.dart';

class selectAddress extends StatefulWidget {
  const selectAddress({super.key});

  @override
  State<selectAddress> createState() => _selectAddressState();
}

int selectedIndex = 0;

class _selectAddressState extends State<selectAddress> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> addressList = [
      {"title": "Home", "subtitle": "Kazhakuttam, Trivandrum, 24930"},
      {"title": "Office", "subtitle": "Kazhakuttam, Trivandrum, 24930"},
      {"title": "outhouse", "subtitle": "kallikandy, kannur,670693"},
    ];

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30.sp,
          ),
          onTap: () => Navigator.pop(context),
        ),
        title: appText(
          "Select Address",
          color: AppColors.white,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: appButton(
                  buttonColor: AppColors.primaryColor,
                  child: appText(
                    "+ Add New Address",
                    color: AppColors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  onTap: () {
//
//               Add New Address Button function
//
                  },
                )),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.builder(
                itemCount: addressList.length,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                itemBuilder: (context, index) {
                  final item = addressList[index];
                  return AddressCard(
                    title: item["title"]!,
                    subtitle: item["subtitle"]!,
                    isSelected: selectedIndex == index,
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  );
                },
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                child: appButton(
                  buttonColor: AppColors.primaryColor,
                  child: appText(
                    "Continue",
                    color: AppColors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  onTap: () {
//
// Continue Button function
//
                  },
                )),
          ],
        ),
      ),
    );
  }

  Widget AddressCard({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 40.h,
              width: 40.w,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_pin,
                color: AppColors.white,
                size: 25.sp,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appText(
                    title,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                  SizedBox(height: 3.h),
                  appText(
                    subtitle,
                    fontSize: 12.sp,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey,
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
