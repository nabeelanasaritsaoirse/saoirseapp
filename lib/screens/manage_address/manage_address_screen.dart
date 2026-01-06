import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/address_response.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_appbar.dart';
import '../add_address/add_address.dart';
import 'manage_address_controller.dart';

class ManageAddressScreen extends StatelessWidget {
  ManageAddressScreen({super.key});

  final ManageAddressController controller = Get.put(ManageAddressController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: CustomAppBar(
        title: AppStrings.manage_address,
        showBack: true,
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
                onTap: () => Get.to(AddAddress()),
              ),
            ),
            SizedBox(height: 10.h),

            // 📌 Address List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: appLoader());
                }

                if (controller.addressList.isEmpty) {
                  return Center(
                    child: appText("No address found"),
                  );
                }

                return ListView.builder(
                  itemCount: controller.addressList.length,
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  itemBuilder: (context, index) {
                    final item = controller.addressList[index];

                    return addressCard(
                      title: "${item.addressType} (${item.name})",
                      subtitle:
                          "${item.addressLine1}, ${item.city}, ${item.state}, ${item.pincode}",
                      context: context,
                      address: item,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget addressCard({
    required String title,
    required String subtitle,
    required BuildContext context,
    required Address address,
  }) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(26), // smoother like image
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 4), // softer long shadow
            ),
          ],
        ),
        child: Row(
          children: [
            // LEFT ICON CIRCLE
            Container(
              height: 45.h,
              width: 45.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor, // navy blue
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on_rounded,
                color: AppColors.white,
                size: 26.sp,
              ),
            ),

            SizedBox(width: 10.w),

            // TEXT SECTION
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appText(
                    title,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                  SizedBox(height: 4.h),
                  appText(
                    subtitle,
                    fontSize: 13.sp,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    color: AppColors.textGray,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            Column(
              spacing: 4.h,
              children: [
                _actionIconButton(
                  icon: Icons.edit,
                  iconColor: AppColors.primaryColor,
                  backgroundColor: const Color(0xFFEFF1FF),
                  onTap: () {
                    Get.to(() => AddAddress(
                          address: address,
                        ));
                  },
                ),
                _actionIconButton(
                  icon: Icons.delete,
                  iconColor: AppColors.red,
                  backgroundColor: const Color(0xFFFFECEC),
                  onTap: () => _showDeleteDialog(context, address.id),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

void _showDeleteDialog(BuildContext context, String addressId) {
  final controller = Get.find<ManageAddressController>();
  showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.0.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Delete Icon
              Container(
                width: 70.w,
                height: 70.h,
                decoration: BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.shadowColor,
                        blurRadius: 20.r,
                        spreadRadius: 5,
                        offset: const Offset(0, 2)),
                  ],
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: AppColors.white,
                  size: 40,
                ),
              ),
              SizedBox(height: 20.h),

              // Title
              appText(
                'Delete Address',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
              SizedBox(height: 10.h),

              // Description

              appText(
                'Are you sure you want to delete this address?',
                fontSize: 14,
                color: AppColors.grey,
                height: 1.5,
              ),
              SizedBox(height: 20.h),

              // Buttons Row
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: appText(
                          "Cancel",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey,
                        )),
                  ),
                  SizedBox(width: 10.w),

                  // Delete Button
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          Get.back();
                          await controller.deleteAddress(addressId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: appText(
                          "Delete",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _actionIconButton({
  required IconData icon,
  required Color iconColor,
  required Color backgroundColor,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 35.w,
      height: 35.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 18.sp,
        color: iconColor,
      ),
    ),
  );
}
