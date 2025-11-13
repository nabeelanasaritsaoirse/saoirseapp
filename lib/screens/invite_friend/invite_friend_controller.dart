import 'package:get/get.dart';
import 'package:saoirse_app/models/invite_friend_product_model.dart';

class InviteFriendController extends GetxController {
  final products = <InviteFriendProductModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInviteFriendProducts();
  }

  Future<void> fetchInviteFriendProducts() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));

      final productList = [
        InviteFriendProductModel(
          productName: "SIP Product P1",
          productId: "#36562X",
          date: "30/10/2025",
          amount: 45638,
          pendingCount: 2,
          pendingLabel: "Pending",
          dailySip: 100,
          commissionPerDay: 50,
          totalEarnings: 250,
        ),
        InviteFriendProductModel(
          productName: "SIP Product P2",
          productId: "#56512P",
          date: "25/11/2025",
          amount: 25999,
          pendingCount: 0,
          pendingLabel: "Pending",
          dailySip: 80,
          commissionPerDay: 40,
          totalEarnings: 160,
        ),
      ];

      products.assignAll(productList);
    } catch (e) {
     
    } finally {
      isLoading.value = false;
    }
  }
}
