import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/address_service.dart';
import '../../widgets/app_toast.dart';
import '../select_address/select_address_controller.dart';

class AddAddressController extends GetxController {
  // Text controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController streetNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> saveAddress() async {
    isLoading.value = true;

    final body = {
      "name": nameController.text.trim(),
      "addressLine1": streetNameController.text.trim(),
      "city": cityController.text.trim(),
      "state": stateController.text.trim(),
      "pincode": zipController.text.trim(),
      "phoneNumber": phoneController.text.trim(),
      "isDefault": true
    };

    bool result = await AddressService.addAddress(body);

    isLoading.value = false;

    if (result) {
      try {
        Get.find<SelectAddressController>().fetchAddresses();
        Get.back();
      } catch (e) {
        log("SelectAddressController not found: $e");
      }

      appToast(title: "Success", content: "Address added successfully");

      
    } else {
      appToast(error: true, title: "Error", content: "Failed to add address");
    }
  }
}
