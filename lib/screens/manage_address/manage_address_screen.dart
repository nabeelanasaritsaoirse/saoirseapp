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
                      subtitle: getFormattedAddress(item),
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

  String getFormattedAddress(Address address) {
    final line2 = address.addressLine2.trim();

    if (line2.isNotEmpty) {
      return "${address.addressLine1},\n$line2,"
          "\n${address.landmark}, ${address.city}, ${address.state}, ${address.pincode}";
    }

    return "${address.addressLine1}, "
        "${address.city}, ${address.state}, ${address.pincode}";
  }

  Widget addressCard({
    required String title,
    required String subtitle,
    required BuildContext context,
    required Address address,
  }) {
    return GestureDetector(
      child: Stack(
        children: [
          /// ADDRESS CARD
          Container(
            margin: EdgeInsets.only(
              bottom: 15.h,
              top: address.isDefault ? 8.h : 0, // prevent badge shadow overlap
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                /// LEFT ICON CIRCLE
                Container(
                  height: 45.h,
                  width: 45.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on_rounded,
                    color: AppColors.white,
                    size: 26.sp,
                  ),
                ),

                SizedBox(width: 10.w),

                /// TEXT SECTION
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
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        color: AppColors.textGray,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),

                /// ACTION BUTTONS
                Column(
                  spacing: 4.h,
                  children: [
                    _actionIconButton(
                      icon: Icons.edit,
                      iconColor: AppColors.primaryColor,
                      backgroundColor: const Color(0xFFEFF1FF),
                      onTap: () {
                        Get.to(() => AddAddress(address: address));
                      },
                    ),
                    _actionIconButton(
                      icon: Icons.delete,
                      iconColor: AppColors.red,
                      backgroundColor: const Color(0xFFFFECEC),
                      onTap: () {
                        DeleteAccountDialog.show(
                          onDelete: () async {
                            await controller.deleteAddress(address.id);
                          },
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),

          /// 🔥 DEFAULT BADGE (FLOATING TOP LEFT)
          if (address.isDefault)
            Positioned(
              top: 10.r,
              left: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(26.r),
                    bottomRight: Radius.circular(14.r),
                  ),
                ),
                child: appText(
                  "Default",
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class DeleteAccountDialog {
  static void show({
    required VoidCallback onDelete,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ///  DELETE ICON
              Container(
                width: 56.w,
                height: 56.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE6E6),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.delete,
                    color: AppColors.red,
                    size: 26.sp,
                  ),
                ),
              ),

              SizedBox(height: 14.h),

              /// TITLE
              appText(
                "Delete Address",
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8.h),

              /// DESCRIPTION
              appText(
                "Are you sure you want to delete this address?",
                fontSize: 13.sp,
                color: AppColors.black54,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20.h),

              /// ACTION BUTTONS
              Row(
                children: [
                  /// CANCEL
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 42.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: appText(
                          "Cancel",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  /// DELETE
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        onDelete();
                      },
                      child: Container(
                        height: 42.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: appText(
                          "Delete",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
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
