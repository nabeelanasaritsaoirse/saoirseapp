import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constant.dart';
import '../../constants/app_strings.dart';
import '../../main.dart';
import '../../models/converstion_model.dart';
import '../../models/message_model.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_appbar.dart';
import 'message_controller.dart';

class PaymentMessageScreen extends StatelessWidget {
  final String conversationId;
  final List<Participant> participants;
  final String name;
  final String? profilePic;
  final String? referralCode;
  late final MessageController controller;
  final bool showProfileButton;

  PaymentMessageScreen({
    super.key,
    required this.conversationId,
    required this.participants,
    required this.name,
    this.showProfileButton = false,
    this.profilePic,
    this.referralCode,
  }) {
    controller = Get.put(
      MessageController(
        conversationId: conversationId,
        participants: participants,
      ),
    );
  }

  final currentUserId = storage.read(AppConst.USER_ID);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperColor,
      appBar: CustomAppBar(
        title: name,
        showBack: true,
        actions: [
          if (showProfileButton && profilePic != null && referralCode != null)
            IconButton(
              icon: Icon(Icons.info, color: Colors.white),
              onPressed: () {
                _showFriendInfoDialog(
                  context,
                  name: name,
                  profilePic: profilePic!,
                  referralCode: referralCode!,
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Color(0xFFF5F5F5),
              child: Obx(
                () => ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: controller.messages.length,
                  controller: controller.scrollController,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[index];
                    final currentUserId = storage.read(AppConst.USER_ID);
                    final friend =
                        participants.firstWhere((p) => p.id != currentUserId);
                    return _messageBubble(context, msg,
                        msg.senderId == currentUserId, friend // isUser
                        );
                  },
                ),
              ),
            ),
          ),
          Container(
            color: Color(0xFFF5F5F5),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: 120.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: controller.textController,
                      onChanged: controller.updateInputText,
                      maxLines: null,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                GestureDetector(
                  onTap: controller.sendMessage,
                  child: Container(
                    width: 45.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: Color(0xFF000066),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFriendInfoDialog(BuildContext context,
      {required String profilePic,
      required String name,
      required String referralCode}) {
    showDialog(
      context: context,
      builder: (_) {
        final MessageController controller = MessageController(
          conversationId: conversationId,
          participants: participants,
          referralCode: referralCode,
        );

        return Dialog(
          elevation: 0,
          backgroundColor: AppColors.transparent,
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black26,
                  blurRadius: 12.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔵 HEADER
                Container(
                  height: 90.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.r),
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      appText(
                        "Profile",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.close,
                            color: AppColors.white, size: 22.sp),
                      )
                    ],
                  ),
                ),

                // ⭐ AVATAR + NAME STACK SECTION
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: -40.h,
                      child: CircleAvatar(
                        radius: 40.r,
                        backgroundColor: AppColors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(36.r),
                          child: Image.network(
                            profilePic,
                            width: 72.w,
                            height: 72.w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                AppAssets.user_img,
                                width: 72.w,
                                height: 72.w,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 50.h),
                      child: Column(
                        children: [
                          // NAME
                          appText(
                            name,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black87,
                          ),

                          SizedBox(height: 10.h),

                          // REFERRAL CODE
                          // REFERRAL CODE
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 25.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.shadowColor),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                appText(
                                  controller.referralCode.value,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textBlack,
                                ),
                                SizedBox(width: 8.w),
                                InkWell(
                                  onTap: controller.copyReferralCode,
                                  child: Icon(
                                    Icons.copy,
                                    size: 18.sp,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        buildSocialButton(
                          image: AppAssets.whatsapp,
                          label: AppStrings.whatsapp,
                          color: AppColors.transparent,
                          onTap: () => controller.shareToWhatsApp(referralCode),
                          width: 28.h,
                          height: 28.h,
                          radius: 40.r,
                        ),
                        SizedBox(width: 12.w),
                        buildSocialButton(
                          image: AppAssets.facebook,
                          label: AppStrings.facebook,
                          color: AppColors.transparent,
                          onTap: () => controller.shareToFacebook(referralCode),
                          width: 28.h,
                          height: 28.h,
                          radius: 40.r,
                        ),
                        SizedBox(width: 12.w),
                        buildSocialButton(
                          image: AppAssets.telegram,
                          label: AppStrings.telegram,
                          color: AppColors.transparent,
                          onTap: () => controller.shareToTelegram(referralCode),
                          width: 28.h,
                          height: 28.h,
                          radius: 40.r,
                        ),
                        SizedBox(width: 12.w),
                        buildSocialButton(
                          image: AppAssets.x,
                          label: AppStrings.twitter,
                          color: AppColors.transparent,
                          onTap: () => controller.shareToTwitter(referralCode),
                          width: 28.h,
                          height: 28.h,
                          radius: 40.r,
                        ),
                        SizedBox(width: 12.w),
                        buildSocialButton(
                          image: AppAssets.instagram,
                          label: AppStrings.instagram,
                          color: AppColors.transparent,
                          onTap: () => controller.shareToInstagram(referralCode),
                          width: 28.h,
                          height: 28.h,
                          radius: 40.r,
                        ),
                        SizedBox(width: 12.w),
                        buildSocialButton(
                          image: AppAssets.gmail,
                          label: AppStrings.gmail,
                          color: AppColors.transparent,
                          onTap: () => controller.shareToGmail(referralCode),
                          width: 28.h,
                          height: 28.h,
                          radius: 40.r,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildSocialButton({
    required String image,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required double height,
    required double width,
    required double radius,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Image.asset(image, fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(fontSize: 9.sp, color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _messageBubble(BuildContext context, ChatMessage message, bool isUser,
      Participant partipant) {
    final time = TimeOfDay.fromDateTime(message.createdAt)
        .format(context) // -> 10:25 AM.
        .replaceAll(" ", ""); // Clean UI

    final tick = tickSymbol(message.deliveryStatus);

    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // 🔹 Show other person's name in top (Only incoming messages)
        if (!isUser)
          Padding(
            padding: EdgeInsets.only(left: 6.w, bottom: 2.h),
            child: appText(
              partipant.name,
              fontSize: 11.sp,
              color: AppColors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),

        Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(bottom: 6.h),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFF000066) : AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: AppColors.black.withOpacity(0.05),
                  blurRadius: 5.r,
                  offset: Offset(0, 2.h),
                )
              ],
            ),
            child: appText(
              message.text,
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: isUser ? AppColors.white : AppColors.black87,
              height: 1.4,
            ),
          ),
        ),

        // 🔹 Time + ticks row
        Padding(
          padding: EdgeInsets.only(
              bottom: 10.h, left: isUser ? 0 : 6.w, right: isUser ? 6.w : 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              appText(
                time, //  message time
                fontSize: 10.sp,
                color: Colors.grey.shade600,
              ),
              SizedBox(width: 4),
              appText(
                tick, // ✓ ✓✓
                fontSize: 12.sp,
                color: message.deliveryStatus == "READ"
                    ? Colors.blueAccent // blue ticks on read
                    : Colors.grey[600],
              ),
            ],
          ),
        )
      ],
    );
  }

  String tickSymbol(String status) {
    switch (status) {
      case "SENT":
        return "✓"; // single tick
      case "DELIVERED":
        return "✓✓"; // double tick
      case "READ":
        return "✓✓"; // blue (handled via color)
      default:
        return "•"; // unknown
    }
  }
}
