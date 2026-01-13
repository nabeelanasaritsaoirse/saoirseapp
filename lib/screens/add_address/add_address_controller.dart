import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/address_response.dart';
import '../../widgets/app_toast.dart';
import '../manage_address/manage_address_controller.dart';
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
  //     "country": countryController.text.trim(),
  //     "pincode": zipController.text.trim(),
  //     "phoneNumber": phoneController.text.trim(),
  //     "isDefault": true,
  //   };

  //   try {
  //     // ✅ SAFE CONTROLLER ACCESS (THIS FIXES THE ERROR)
  //     final ManageAddressController manageController =
  //         Get.isRegistered<ManageAddressController>()
  //             ? Get.find<ManageAddressController>()
  //             : Get.put(ManageAddressController());
  //     final SelectAddressController selectAddressController =
  //         Get.isRegistered<SelectAddressController>()
  //             ? Get.find<SelectAddressController>()
  //             : Get.put(SelectAddressController());

  //     bool success;

  //     // ---------- EDIT ----------
  //     if (isEdit.value && addressId != null) {
  //       success = await manageController.editAddress(
  //         addressId: addressId!,
  //         body: body,
  //       );
  //       await manageController.fetchAddresses();
  //     }
  //     // ---------- ADD ----------
  //     else {
  //       success = await manageController.addAddress(body);
  //       await selectAddressController.fetchAddresses();
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
  // 🔒 PREVENT MULTIPLE CALLS
  if (isLoading.value) {
    debugPrint("⛔ Save address already in progress");
    return;
  }

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
    final ManageAddressController manageController =
        Get.isRegistered<ManageAddressController>()
            ? Get.find<ManageAddressController>()
            : Get.put(ManageAddressController());

    final SelectAddressController selectAddressController =
        Get.isRegistered<SelectAddressController>()
            ? Get.find<SelectAddressController>()
            : Get.put(SelectAddressController());

    bool success;

    // ---------- EDIT ----------
    if (isEdit.value && addressId != null) {
      success = await manageController.editAddress(
        addressId: addressId!,
        body: body,
      );
      await manageController.fetchAddresses();
    }
    // ---------- ADD ----------
    else {
      success = await manageController.addAddress(body);
      await selectAddressController.fetchAddresses();
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
  } catch (e) {
    appToast(
      error: true,
      title: "Error",
      content: "Something went wrong",
    );
  } finally {
    isLoading.value = false; // 🔓 UNLOCK
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
