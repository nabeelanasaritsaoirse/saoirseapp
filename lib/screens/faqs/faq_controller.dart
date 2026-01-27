import 'package:get/get.dart';
import 'package:saoirse_app/models/faq_model.dart';
import 'package:saoirse_app/services/faq_service.dart';

class FaqController extends GetxController {
  final FaqService _service = FaqService();

  /// FAQ list
  final RxList<FaqModel> faqList = <FaqModel>[].obs;

  /// Expanded FAQ index (-1 = none)
  final RxInt expandedIndex = (-1).obs;

  /// Loading state
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFaqs();
  }

  /// Fetch FAQ from API
  Future<void> fetchFaqs() async {
    try {
      isLoading.value = true;

      /// Service returns List<FaqModel>
      final List<FaqModel> result =
          await _service.getFAQ();

      faqList.assignAll(result);
    } catch (e) {
      // Optional error handling
      // Get.snackbar(
      //   'Error',
      //   e.toString(),
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    } finally {
      isLoading.value = false;
    }
  }

  /// Expand / collapse FAQ
  void toggleExpand(int index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = -1;
    } else {
      expandedIndex.value = index;
    }
  }

  /// Optional: close all FAQs
  void collapseAll() {
    expandedIndex.value = -1;
  }
}




