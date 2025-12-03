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
  late final MessageController controller;
  PaymentMessageScreen({
    super.key,
    required this.conversationId,
    required this.participants,
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
        title: 'Messages',
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
                  itemBuilder: (context, index) {
                    final msg = controller.messages[index];
                    final currentUserId = storage.read(AppConst.USER_ID);

                    return _messageBubble(
                      context,
                      msg,
                      msg.senderId == currentUserId, // isUser
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

Widget _messageBubble(BuildContext context, ChatMessage message, bool isUser) {
  return Align(
    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
      decoration: BoxDecoration(
        color: isUser ? Color(0xFF000066) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: appText(
        message.text,
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: isUser ? Colors.white : Colors.black87,
        fontFamily: "poppins",
        textAlign: TextAlign.start,
        height: 1.4,
      ),
    ),
  );
}
