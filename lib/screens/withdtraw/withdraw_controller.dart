import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController accController = TextEditingController();
  TextEditingController confirmAccController = TextEditingController();
  TextEditingController ifscController = TextEditingController();

  @override
  void onClose() {
    nameController.dispose();
    accController.dispose();
    confirmAccController.dispose();
    ifscController.dispose();
    super.onClose();
  }
}
