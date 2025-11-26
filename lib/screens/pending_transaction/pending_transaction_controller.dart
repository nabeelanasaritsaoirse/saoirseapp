import 'package:get/get.dart';

class PendingTransactionController extends GetxController {
  final RxList<Map<String, dynamic>> transactions = <Map<String, dynamic>>[
    {
      "title": "Mitzie organic Mitzie organic",
      "subtitle": "Red | 1TB",
      "price": 999,
      "image":
          "https://images.unsplash.com/photo-1549049950-48d5887197a0?auto=format&fit=crop&q=60&w=600",
      "isSelected": true.obs,
    },
    {
      "title": "Boat wear",
      "subtitle": "Red | 1TB",
      "price": 100,
      "image":
          "https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&q=60&w=600",
      "isSelected": true.obs,
    },
    {
      "title": "GUCCI",
      "subtitle": "Red | 1TB",
      "price": 566,
      "image":
          'https://plus.unsplash.com/premium_photo-1664392147011-2a720f214e01?auto=format&fit=crop&q=60&w=600',
      "isSelected": true.obs,
    },
    {
      "title": "Sony camera",
      "subtitle": "Gray | 512GB",
      "price": 15000,
      "image":
          'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?auto=format&fit=crop&q=60&w=600',
      "isSelected": true.obs,
    },
  ].obs;

  void toggleSelection(int index) {
    final RxBool isSelected = transactions[index]['isSelected'];
    isSelected.value = !isSelected.value;
  }

  int get totalAmount {
    int total = 0;
    for (int i = 0; i < transactions.length; i++) {
      final RxBool isSelected = transactions[i]['isSelected'];
      if (isSelected.value) {
        total += transactions[i]['price'] as int;
      }
    }
    return total;
  }
}
