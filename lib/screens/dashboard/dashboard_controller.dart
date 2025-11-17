import 'package:get/get.dart';

class DashboardController extends GetxController {
  // Observable index to track current tab
  var selectedIndex = 0.obs;

  // Function to change tab
  void changeTab(int index) {
    selectedIndex.value = index;
  }
}
