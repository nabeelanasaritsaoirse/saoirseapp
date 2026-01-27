import 'dart:developer';

import 'package:get/get.dart';
import 'package:saoirse_app/models/faq_model.dart';
import 'package:saoirse_app/services/faq_service.dart';

class FaqController extends GetxController {
  final FaqService _service = FaqService();

  final RxList<FaqModel> faqList = <FaqModel>[].obs;

  final RxInt expandedIndex = (-1).obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFaqs();
  }

  Future<void> fetchFaqs() async {
    try {
      isLoading.value = true;

      final List<FaqModel> result = await _service.getFAQ();

      faqList.assignAll(result);
    } catch (e) {
      // Get.snackbar(
      //   'Error',
      //   e.toString(),
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void toggleExpand(int index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = -1;
    } else {
      expandedIndex.value = index;
    }
  }

  void collapseAll() {
    expandedIndex.value = -1;
  }
}
