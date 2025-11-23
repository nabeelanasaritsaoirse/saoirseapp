// ignore_for_file: file_names

import 'package:get/get.dart';

import '../../models/address_response.dart';
import '../../services/address_service.dart';

class SelectAddressController extends GetxController {
  var isLoading = false.obs;
  var addressList = <Address>[].obs;
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    isLoading.value = true;

    final response = await AddressService.getAllAddresses();

    if (response != null && response.success) {
      addressList.assignAll(response.addresses);
    }

    isLoading.value = false;
  }

  void selectAddress(int index) {
    selectedIndex.value = index;
  }
}
