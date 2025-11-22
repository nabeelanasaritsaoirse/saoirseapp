import 'package:get/get.dart';
import 'package:saoirse_app/models/address_response.dart';
import 'package:saoirse_app/services/address_service.dart';

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
