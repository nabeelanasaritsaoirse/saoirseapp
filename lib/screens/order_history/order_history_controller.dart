import 'package:get/get.dart';

import '../../models/order_model.dart';

class OrderHistoryController extends GetxController {
  var orders = <OrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    //--------Temporary Data--------
    orders.value = [
      OrderModel(
        id: 'IKD384',
        name: 'Iphone 12',
        color: 'Red',
        storage: '512GB',
        price: 53000,
        qty: 1,
        image: 'assets/images/iphone_red.png',
        dailyPlan: '₹100/120 Days',
        status: 'Investing',
        openDate: '30/10/2025',
        closeDate: '30/10/2027',
        invested: 5100,
      ),
      OrderModel(
        id: 'IKD385',
        name: 'Iphone 12',
        color: 'Red',
        storage: '512GB',
        price: 53000,
        qty: 1,
        image: 'assets/images/iphone_red.png',
        dailyPlan: '₹100/120 Days',
        status: 'Investing',
        openDate: '30/10/2025',
        closeDate: '30/10/2027',
        invested: 5100,
      ),
    ];
  }
}
