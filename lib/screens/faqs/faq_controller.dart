import 'dart:developer';

import 'package:get/get.dart';

import '../../models/faq_model.dart';
import '../../services/faq_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

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
     
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }


//------------contact support call-----------------
Future<void> contactSupportCall() async {
  try {
    final String number = dotenv.env['CUSTOMER_SUPPORT_NUMBER'] ?? '918089458905';
    final Uri phoneUri = Uri.parse('tel:$number');

    await launchUrl(phoneUri);
  } catch (e) {
    log('Error launching dialer: $e');
  }
}

  //------------contact support whatsapp-----------------
  Future<void> openWhatsAppSupport() async {
  try {
    final String number = dotenv.env['CUSTOMER_SUPPORT_NUMBER'] ?? '918089458905';
    const String message = "Hello, I need help regarding EPI services.";

    final Uri whatsappUri = Uri.parse(
      "https://wa.me/$number?text=${Uri.encodeComponent(message)}",
    );

    await launchUrl(
      whatsappUri,
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    log('Error launching WhatsApp: $e');
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
