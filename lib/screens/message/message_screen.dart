import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constant.dart';
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
  late final MessageController controller;
  PaymentMessageScreen({
    super.key,
    required this.conversationId,
    required this.participants,
    required this.name,
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
                    width: 50.w,
                    height: 50.h,
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
