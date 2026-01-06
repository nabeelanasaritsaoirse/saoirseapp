import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/models/address_response.dart';
import 'package:saoirse_app/screens/manage_address/manage_address_controller.dart';

import '../../widgets/app_toast.dart';


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
    RxBool isEdit = false.obs;
  String? addressId;

 void setEditAddress(Address address) {
  isEdit.value = true;
  addressId = address.id;

  nameController.text = address.name;
  streetNameController.text = address.addressLine1;
  cityController.text = address.city;
  stateController.text = address.state;
  countryController.text = address.country;
  zipController.text = address.pincode;
  phoneController.text = address.phoneNumber;
}



  // Future<void> saveAddress() async {
  //   isLoading.value = true;

  //   final body = {
  //     "name": nameController.text.trim(),
  //     "addressLine1": streetNameController.text.trim(),
  //     "city": cityController.text.trim(),
  //     "state": stateController.text.trim(),
  //     "pincode": zipController.text.trim(),
  //     "phoneNumber": phoneController.text.trim(),
  //     "isDefault": true
  //   };

  //   bool result = await AddressService.addAddress(body);

  //   isLoading.value = false;

  //   if (result) {
  //     try {
  //       Get.find<SelectAddressController>().fetchAddresses();
  //       Get.back();
  //     } catch (e) {
  //       log("SelectAddressController not found: $e");
  //     }

  //     appToast(title: "Success", content: "Address added successfully");

      
  //   } else {
  //     appToast(error: true, title: "Error", content: "Failed to add address");
  //   }
  // }

  //   Future<void> saveAddress() async {
  //   isLoading.value = true;

  //   final body = {
  //     "name": nameController.text.trim(),
  //     "addressLine1": streetNameController.text.trim(),
  //     "city": cityController.text.trim(),
  //     "state": stateController.text.trim(),
  //     "country": countryController.text.trim(),
  //     "pincode": zipController.text.trim(),
  //     "phoneNumber": phoneController.text.trim(),
  //     "isDefault": true,
  //   };

  //   try {
  //     bool success;

  //     // ---------- EDIT ----------
  //     if (isEdit.value && addressId != null) {
  //       success = await Get.find<ManageAddressController>().editAddress(
  //         addressId: addressId!,
  //         body: body,
  //       );
  //     }
  //     // ---------- ADD ----------
  //     else {
  //       success = await Get.find<ManageAddressController>()
  //           .addAddress(body);
  //     }

  //     if (success) {
  //       appToast(
  //         title: "Success",
  //         content: isEdit.value
  //             ? "Address updated successfully"
  //             : "Address added successfully",
  //       );

  //       clearForm();
  //       Get.back();
  //     } else {
  //       appToast(
  //         error: true,
  //         title: "Error",
  //         content: isEdit.value
  //             ? "Failed to update address"
  //             : "Failed to add address",
  //       );
  //     }
  //   } catch (e) {
  //     log("❌ Save address error: $e");
  //     appToast(
  //       error: true,
  //       title: "Error",
  //       content: "Something went wrong",
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> saveAddress() async {
  isLoading.value = true;

  final body = {
    "name": nameController.text.trim(),
    "addressLine1": streetNameController.text.trim(),
    "city": cityController.text.trim(),
    "state": stateController.text.trim(),
    "country": countryController.text.trim(),
    "pincode": zipController.text.trim(),
    "phoneNumber": phoneController.text.trim(),
    "isDefault": true,
  };

  try {
    // ✅ SAFE CONTROLLER ACCESS (THIS FIXES THE ERROR)
    final ManageAddressController manageController =
        Get.isRegistered<ManageAddressController>()
            ? Get.find<ManageAddressController>()
            : Get.put(ManageAddressController());

    bool success;

    // ---------- EDIT ----------
    if (isEdit.value && addressId != null) {
      success = await manageController.editAddress(
        addressId: addressId!,
        body: body,
      );
    }
    // ---------- ADD ----------
    else {
      success = await manageController.addAddress(body);
    }

    if (success) {
      appToast(
        title: "Success",
        content: isEdit.value
            ? "Address updated successfully"
            : "Address added successfully",
      );

      clearForm();
      Get.back();
    } else {
      appToast(
        error: true,
        title: "Error",
        content: isEdit.value
            ? "Failed to update address"
            : "Failed to add address",
      );
    }
  } catch (e, stack) {
    log("❌ Save address error: $e");
    log("🧱 StackTrace: $stack");

    appToast(
      error: true,
      title: "Error",
      content: "Something went wrong",
    );
  } finally {
    isLoading.value = false;
  }
}


  void clearForm() {
  nameController.clear();
  streetNameController.clear();
  cityController.clear();
  stateController.clear();
  countryController.clear();
  zipController.clear();
  phoneController.clear();

  isEdit.value = false;
  addressId = null;
}

@override
  void onClose() {
    clearForm();
    super.onClose();
  }

}
