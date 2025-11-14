import 'package:get/get.dart';

import '../../models/cart_model.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;

  @override
  void onInit() {
    super.onInit();

    /// TEMP DATA (Replace with API later)
    cartItems.value = [
      CartItem(
        name: "Iphone 14",
        color: "Red",
        storage: "1TB",
        price: 53999,
        quantity: 1,
        image: "assets/images/iphone_red.png",
        plan: "₹100/200 Day",
      ),
      CartItem(
        name: "Samsung Tab S3",
        color: "Grey",
        storage: "512GB",
        price: 24000,
        quantity: 1,
        image: "assets/images/tablet.png",
        plan: "₹150/100 Day",
      ),
    ];
  }

  void increaseQty(int index) {
    cartItems[index].quantity++;
    cartItems.refresh();
  }

  void decreaseQty(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
      cartItems.refresh();
    }
  }

  void removeItem(int index) {
    cartItems.removeAt(index);
  }

  int get totalAmount {
    int sum = 0;
    for (var item in cartItems) {
      sum += item.price * item.quantity;
    }
    return sum;
  }
}
