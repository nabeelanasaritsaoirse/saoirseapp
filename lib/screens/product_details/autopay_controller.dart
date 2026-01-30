// import 'package:get/get.dart';

// class AutopayController extends GetxController {
//   // ---------------- AUTOPAY ----------------
//   RxBool isAutopayEnabled = true.obs;

//   // ---------------- TIME PREFERENCE ----------------
//   final List<String> timeOptions = [
//     "MORNING, 6AM",
//     "MORNING, 8AM",
//     "AFTERNOON, 12PM",
//     "EVENING, 6PM",
//     "NIGHT, 9PM",
//   ];

//   RxString selectedTime = "MORNING, 6AM".obs;
//   RxBool isTimeDropdownOpen = false.obs;

//   // ---------------- WALLET RESERVES ----------------
//   RxString minBalanceLock = "".obs;
//   RxString lowBalanceThreshold = "".obs;

//   // ---------------- REMINDER ----------------
//   RxString reminderHours = "".obs;

//   // ---------------- NOTIFICATION PREFERENCES ----------------
//   RxBool notifySuccess = true.obs;
//   RxBool notifyFailed = true.obs;
//   RxBool notifyLowBalance = true.obs;
//   RxBool notifyDailyReminder = true.obs;

//   @override
//   void onInit() {
//     super.onInit();

//     // 🔥 LISTEN TO AUTOPAY SWITCH
//     ever(isAutopayEnabled, (bool enabled) {
//       if (enabled) {
//         // When Autopay ON → enable all notifications
//         _enableAllNotifications();
//       } else {
//         // When Autopay OFF → disable all notifications
//         _disableAllNotifications();
//       }
//     });
//   }

//   // ---------------- METHODS ----------------

//   void selectTime(String value) {
//     selectedTime.value = value;
//     isTimeDropdownOpen(false);
//   }

//   void _enableAllNotifications() {
//     notifySuccess.value = true;
//     notifyFailed.value = true;
//     notifyLowBalance.value = true;
//     notifyDailyReminder.value = true;
//   }

//   void _disableAllNotifications() {
//     notifySuccess.value = false;
//     notifyFailed.value = false;
//     notifyLowBalance.value = false;
//     notifyDailyReminder.value = false;
//   }
// }
