import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/address_service.dart';
import '../../models/address_response.dart';

class ManageAddressController extends GetxController {
  // ---------------- STATE ----------------
  RxBool isLoading = false.obs;
  RxList<Address> addressList = <Address>[].obs;

  // ---------------- LIFECYCLE ----------------
  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  // ---------------- FETCH ADDRESSES ----------------

  Future<void> fetchAddresses() async {
    try {
      isLoading.value = true;

      final response = await AddressService.getAllAddresses();

      if (response != null && response.success == true) {
        addressList.assignAll(response.addresses);
      } else {
        addressList.clear();
      }
    } catch (e) {
      addressList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------- ADD ADDRESS ----------------
  Future<bool> addAddress(Map<String, dynamic> body) async {
    try {
      isLoading.value = true;

      final success = await AddressService.addAddress(body);

      if (success) {
        await fetchAddresses(); // refresh list after add
        return true;
      }
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  // ---------------- EDIT ADDRESS ----------------
  Future<bool> editAddress({
    required String addressId,
    required Map<String, dynamic> body,
  }) async {
    try {
      isLoading.value = true;

      final bool success = await AddressService.editAddress(
        addressId: addressId,
        body: body,
      );

      if (!success) return false;

      final int index =
          addressList.indexWhere((address) => address.id == addressId);

      if (index != -1) {
        final Address oldAddress = addressList[index];

        addressList[index] = oldAddress.copyWith(
          name: body['name'],
          addressLine1: body['addressLine1'],
          addressLine2: body['addressLine2'],
          city: body['city'],
          state: body['state'],
          pincode: body['pincode'],
          country: body['country'],
          phoneNumber: body['phoneNumber'],
          addressType: body['addressType'],
          landmark: body['landmark'],
          isDefault: body['isDefault'],
          updatedAt: DateTime.now(),
        );
      }

      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------- DELETE ADDRESS ----------------
  // Future<bool> deleteAddress(String addressId) async {
  //   try {
  //     isLoading.value = true;

  //     final success = await AddressService.deleteAddress(addressId: addressId);

  //     if (success) {
  //       addressList.removeWhere((a) => a.id == addressId);
  //       return true;
  //     }
  //   } finally {
  //     isLoading.value = false;
  //   }
  //   return false;
  // }

  Future<bool> deleteAddress(String addressId) async {
  try {
    isLoading.value = true;

    /// 🔍 CHECK IF DELETED ADDRESS IS DEFAULT
    final deletedAddress = addressList
        .firstWhereOrNull((element) => element.id == addressId);

    final wasDefault = deletedAddress?.isDefault ?? false;

    final success = await AddressService.deleteAddress(
      addressId: addressId,
    );

    if (success) {

      /// REMOVE FROM LOCAL LIST
      addressList.removeWhere((a) => a.id == addressId);

      /// 🚨 IF DEFAULT ADDRESS DELETED
      if (wasDefault && addressList.isNotEmpty) {

        /// MAKE FIRST ADDRESS DEFAULT
        await editAddress(
          addressId: addressList.first.id,
          body: {
            "isDefault": true,
          },
        );

        /// 🔥 REFRESH UI
        await fetchAddresses();
      }

      return true;
    }

  } catch (e) {
    debugPrint("Delete Address Error: $e");
  } finally {
    isLoading.value = false;
  }

  return false;
}

  // ---------------- REFRESH ----------------
  Future<void> refreshAddresses() async {
    await fetchAddresses();
  }
}
