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
  TextEditingController pinController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  RxString addressType = "home".obs;
  RxBool isDefaultAddress = false.obs;
  bool initialIsDefault = false;

  RxBool isLoading = false.obs;
  RxBool isEdit = false.obs;
  String? addressId;

  @override
  void onInit() {
    super.onInit();
    countryController.text = "India";
  }

  void setEditAddress(Address address) {
    isEdit.value = true;
    addressId = address.id;

    nameController.text = address.name;
    streetNameController.text = address.addressLine1;
    addressLine2Controller.text = address.addressLine2;
    landmarkController.text = address.landmark;
    cityController.text = address.city;
    stateController.text = address.state;
    countryController.text =
        address.country.isEmpty ? "India" : address.country;
    pinController.text = address.pincode;
    phoneController.text = address.phoneNumber;

    addressType.value = address.addressType;

    isDefaultAddress.value = address.isDefault;

    initialIsDefault = address.isDefault;
  }

  Future<void> saveAddress() async {
    if (isLoading.value) {
      debugPrint("⛔ Save address already in progress");
      return;
    }

    isLoading.value = true;

    final body = {
      "name": nameController.text.trim(),
      "addressLine1": streetNameController.text.trim(),
      "addressLine2": addressLine2Controller.text.trim().isEmpty
          ? ""
          : addressLine2Controller.text.trim(),
      "city": cityController.text.trim(),
      "state": stateController.text.trim(),
      "country": countryController.text.trim().isEmpty
          ? "India"
          : countryController.text.trim(),
      "pincode": pinController.text.trim(),
      "phoneNumber": phoneController.text.trim(),
      "landmark": landmarkController.text.trim().isEmpty
          ? ""
          : landmarkController.text.trim(),
      "addressType": addressType.value,
      "isDefault": isDefaultAddress.value,
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
    addressLine2Controller.clear();
    landmarkController.clear();
    cityController.clear();
    stateController.clear();
    pinController.clear();
    phoneController.clear();

    countryController.text = "India"; // ✅ DEFAULT INDIA AGAIN
    addressType.value = "home";
    isDefaultAddress.value = false;
    isEdit.value = false;
    addressId = null;
  }

  @override
  void onClose() {
    clearForm();
    super.onClose();
  }
}
