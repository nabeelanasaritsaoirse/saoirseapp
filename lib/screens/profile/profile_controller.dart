import 'dart:developer';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../main.dart';
import '../../models/delete_acc_model.dart';
import '../../models/profile_response.dart';
import '../../services/profile_service.dart';
import '../../services/wishlist_service.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_toast.dart';
import '../dashboard/dashboard_controller.dart';
import '../notification/notification_controller.dart';
import '../onboard/onboard_screen.dart';

class ProfileController extends GetxController {
  final WishlistService _wishlistService = WishlistService();
  final ProfileService _profileService = ProfileService();

  final formKey = GlobalKey<FormState>();
  // ================== TEXT CONTROLLERS (For Edit Profile) ==================
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController =
      TextEditingController(); // READ ONLY

  final TextEditingController phoneNumberController = TextEditingController();
  RxBool showEmailField = false.obs;
  RxBool showPhoneField = false.obs;
  // ================== IMAGE PICKER ==================
  final ImagePicker _picker = ImagePicker();
  Rx<File?> profileImage = Rx<File?>(null);

  // ------------------ COUNTRY ------------------
  Rx<Country?> country = Rx<Country?>(null);

  RxInt wishlistCount = 0.obs;
  Rx<UserProfileModel?> profile = Rx<UserProfileModel?>(null);
  var isLoading = false.obs;
  var errorMessage = "".obs;

  /// API response holder for delete-account info
  final deleteAccountData = Rxn<DeleteAccountModel>();

  /// Convenient getters for UI
  bool get isDeleteInfoSuccess => deleteAccountData.value?.success ?? false;

  DeletionInfo? get deletionInfo => deleteAccountData.value?.deletionInfo;

  DataCounts? get dataCounts => deletionInfo?.dataCounts;

  @override
  void onInit() {
    _setInitialCountryFromCode('+91');
    fetchWishlistCount();
    fetchUserProfile();
    fetchDeleteInfo();

    super.onInit();
  }

  final myOrders = [
    {"icon": AppAssets.pending_payment, "title": "Pending Payment"},
    {"icon": AppAssets.order_history, "title": "Order History"},
    {"icon": AppAssets.wishlist, "title": "Wishlist"},
    {"icon": AppAssets.active_oders, "title": "Active Orders"},
    {"icon": AppAssets.transactions, "title": "Transactions"},
    {"icon": AppAssets.delivered, "title": "Delivered"},
    // {"icon": AppAssets.customer_care, "title": "Customer Care"},
  ];

  final settings = [
    // {"icon": AppAssets.password_security, "title": "Password & security"},
    {"icon": AppAssets.kyc, "title": "KYC"},
    {"icon": AppAssets.manage_accounts, "title": "Manage Account"},
    {"icon": AppAssets.address, "title": "Manage Address"},
    {"icon": AppAssets.privacy_policy, "title": "Privacy Policy"},
    {"icon": AppAssets.terms_condition, "title": "Terms & Condition"},
    // {"icon": AppAssets.faq, "title": "FAQ"},
    // {"icon": AppAssets.about, "title": "About EPI"},

    {"icon": AppAssets.logout, "title": "Log Out"},
    {"icon": AppAssets.delete_account, "title": "Delete\nAccount"},
  ];

  Future<DeleteAccountModel?> fetchDeleteInfo() async {
    try {
      isLoading.value = true;

      final response = await _profileService.getDeleteInfo();

      if (response.success) {
        deleteAccountData.value = response;
        return response;
      }
    } finally {
      isLoading.value = false;
    }

    return null;
  }

  /// Retry handler (optional)
  void retry() {
    fetchDeleteInfo();
  }

  Future<void> fetchWishlistCount() async {
    final count = await _wishlistService.getWishlistCount();
    wishlistCount.value = count ?? 0;
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading(true);

      final result = await _profileService.fetchProfile();

      if (result != null) {
        profile.value = result;

        // Set Text Fields
        fullNameController.text = result.user.name;
        emailController.text = result.user.email;
        phoneNumberController.text = result.user.phoneNumber;
      }
    } finally {
      isLoading(false);
    }
  }

// ================== PICK PROFILE IMAGE ==================
  Future<void> pickProfileImage() async {
    // bool granted = await _requestGalleryPermission();
    // if (!granted) return;

    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image != null) {
      profileImage.value = File(image.path);
      // await uploadUserProfilePicture(image.path);
    }
  }

// // ================== NEW METHOD (fixed name) ==================
//   // ================== UPLOAD USER PROFILE PICTURE ==================
//   Future<void> uploadUserProfilePicture(String imagePath) async {
//     if (imagePath.isEmpty) {
//       appToast(
//           error: true, title: "Error", content: "Invalid image selected");
//       return;
//     }

//     // Show loader
//     isLoading(true);

//     try {
//       final userId = profile.value?.user.id;

//       if (userId == null) {

//         appToast(error: true, title: "Error", content: "User not found");
//         return;
//       }

//       final success =
//           await _profileService.updateProfilePicture(userId, imagePath);

//       if (success) {
//         appToast(
//           title: "Success",
//           content: "Profile picture updated successfully",
//         );

//         await fetchUserProfile();
//       } else {
//         appToast(
//           error: true,
//           title: "Failed",
//           content: "Unable to upload profile picture",
//         );
//       }
//     } catch (e) {

//       appToast(error: true, title: "Error", content: "Something went wrong");
//     } finally {
//       // hide loader after everything
//       isLoading(false);
//     }
//   }

  // ================== GALLERY PERMISSION ==================
  // Future<bool> _requestGalleryPermission() async {
  //   if (Platform.isAndroid) {
  //     final photos = await Permission.photos.request();
  //     final storage = await Permission.storage.request();

  //     if (photos.isGranted || storage.isGranted) return true;

  //     if (photos.isPermanentlyDenied || storage.isPermanentlyDenied) {
  //       openAppSettings();
  //     }
  //     return false;
  //   }

  //   final ios = await Permission.photos.request();
  //   if (ios.isGranted) return true;

  //   if (ios.isPermanentlyDenied) openAppSettings();
  //   return false;
  // }

// ------------------ COUNTRY SETUP ------------------
  void _setInitialCountryFromCode(String code) {
    final cleanCode = code.replaceAll("+", "").trim();

    Country? parsed = CountryParser.tryParsePhoneCode(cleanCode);

    parsed ??= CountryParser.tryParseCountryCode(cleanCode.toUpperCase());

    parsed ??= CountryParser.tryParseCountryCode('IN');

    country.value = parsed;
  }

  void updateCountry(Country selectedCountry) {
    country.value = selectedCountry;
  }

  String get fullPhoneNumber {
    final c = country.value;
    if (c == null) return '';
    return '+${c.phoneCode}${phoneNumberController.text}';
  }

  // ------------------ VALIDATIONS ------------------
  String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Full name is required";
    }
    if (value.trim().length < 3) {
      return "Name must be at least 3 characters";
    }
    if (!RegExp(r"^[a-zA-Z ]+$").hasMatch(value.trim())) {
      return "Only alphabets allowed";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    final emailRegex = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$");
    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number is required";
    }
    if (!RegExp(r"^[0-9]+$").hasMatch(value)) {
      return "Only numbers allowed";
    }
    if (value.length < 6) {
      return "Number too short";
    }
    if (value.length > 15) {
      return "Number too long";
    }
    return null;
  }

//-------------------------------------------------------------------------------------------------------------------------------------
  // this is for resetting form data when edit profile screen is (opened)
  void resetFormData() {
    final user = profile.value?.user;
    if (user != null) {
      fullNameController.text = user.name;
      emailController.text = user.email;
      phoneNumberController.text = user.phoneNumber;
    }
    profileImage.value = null;
  }

  // This method updates both the username and profile picture if (provided)
  Future<void> updateUserName() async {
    final name = fullNameController.text.trim();

    if (name.isEmpty) {
      appToast(error: true, title: "Error", content: "Name cannot be empty");
      return;
    }

    final userId = profile.value?.user.id;
    if (userId == null) {
      appToast(error: true, title: "Error", content: "User not found");
      return;
    }

    try {
      isLoading(true);

      // Upload image if selected
      if (profileImage.value != null) {
        final imageUpdated = await _profileService.updateProfilePicture(
          userId,
          profileImage.value!.path,
        );

        if (!imageUpdated) {
          appToast(
            error: true,
            title: "Failed",
            content: "Unable to update profile picture",
          );
          // return;
        }
      }

      // Update name here
      final success = await _profileService.updateUserName(userId, name);

      if (success) {
        appToast(title: "Success", content: "Profile updated successfully");
        await fetchUserProfile();
        Get.back();
      } else {
        appToast(error: true, title: "Failed", content: "Update failed");
      }
    } catch (e) {
      appToast(error: true, title: "Error", content: "Something went wrong");
    } finally {
      isLoading(false);
    }
  }

// upload profile picture only (if needed)
  Future<void> uploadUserProfilePicture(String imagePath) async {
    if (imagePath.isEmpty) {
      appToast(
        error: true,
        title: "Error",
        content: "Invalid image selected",
      );
      return;
    }

    final userId = profile.value?.user.id;
    if (userId == null) {
      appToast(error: true, title: "Error", content: "User not found");
      return;
    }

    try {
      final success = await _profileService.updateProfilePicture(
        userId,
        imagePath,
      );

      if (!success) {
        appToast(
          error: true,
          title: "Failed",
          content: "Unable to upload profile picture",
        );
      }
    } catch (e) {
      appToast(error: true, title: "Error", content: "Something went wrong");
    }
  }

  // void confirmLogout() {
  //   Get.defaultDialog(
  //     title: "Logout",
  //     middleText: "Are you sure you want to exit?",
  //     textConfirm: "Yes",
  //     textCancel: "No",
  //     confirmTextColor: Colors.white,
  //     buttonColor: AppColors.primaryColor,
  //     cancelTextColor: AppColors.primaryColor,
  //     onConfirm: () async {
  //       await Get.find<NotificationController>().removeFCM();
  //       await FirebaseMessaging.instance.deleteToken();

  //       Get.back(); // close dialog
  //       await logoutUser();
  //     },
  //   );
  // }

  // Future<void> logoutUser() async {
  //   try {
  //     isLoading(true);

  //     bool success = await _profileService.logout();

  //     if (success) {
  //       // CLEAR STORAGE
  //       await storage.erase();
  //       appToast(content: "Logged out successfully!");

  //       // GO TO ONBOARD SCREEN
  //       Get.offAll(() => OnBoardScreen());
  //     } else {
  //       appToast(content: "Logout failed!", error: true);
  //     }
  //   } catch (e) {

  //     appToast(content: "Something went wrong", error: true);
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  void confirmLogout() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to exit?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primaryColor,
      cancelTextColor: AppColors.primaryColor,
      onConfirm: () {
        Get.back(); // close dialog
        if (Get.isRegistered<DashboardController>()) {
          Get.find<DashboardController>().selectedIndex.value = 0;
        }
        // Navigate immediately
        Get.offAll(() => OnBoardScreen());

        // Perform logout in background
        logoutUserInBackground();
      },
    );
  }

  Future<void> logoutUserInBackground() async {
    try {
      // Remove FCM from backend
      if (Get.isRegistered<NotificationController>()) {
        await Get.find<NotificationController>().removeFCM();
      }

      // Delete local FCM token
      if (Platform.isAndroid) {
        await FirebaseMessaging.instance.deleteToken();
      }

      // Call logout API (optional but recommended)

      await _profileService.logout();

      // Clear storage
      await storage.erase();

      // // Clear controllers
      // Get.deleteAll(force: true);

      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> deleteAccount() async {
    deleteAccountData.value = null;

    fetchDeleteInfo();

    Get.defaultDialog(
      title: "Delete Account",
      content: Obx(() {
        final info = deletionInfo;

        if (info == null) {
          return appLoader();
        }

        final items = info.dataToBeDeleted;
        final note = info.note;
        final retention = info.retentionPeriod;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            appText(
              "The following data will be deleted:",
              fontWeight: FontWeight.w600,
              color: AppColors.grey,
            ),
            SizedBox(height: 8.h),
            ...items.map(
              (e) => Padding(
                padding: EdgeInsets.symmetric(vertical: 2.w),
                child: appText(
                  "• $e",
                  fontWeight: FontWeight.w600,
                  color: AppColors.mediumGray,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            if (retention.isNotEmpty)
              appText(
                "Data retention: $retention",
                fontSize: 12.sp,
                color: AppColors.grey,
              ),
            if (note.isNotEmpty) ...[
              SizedBox(height: 4.h),
              appText(
                note,
                fontSize: 12.sp,
                color: AppColors.grey,
              ),
            ],
            SizedBox(height: 16.h),
            appText(
              "This action is permanent. Are you sure you want to delete your account?",
              //  fontSize: 12, color: AppColors.grey,
            ),
          ],
        );
      }),
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: AppColors.white,
      buttonColor: AppColors.primaryColor,
      cancelTextColor: AppColors.primaryColor,
      onConfirm: () {
        Get.back();
        confirmDeleteAccount();
      },
    );
  }

  Future<void> confirmDeleteAccount() async {
    final userId = profile.value?.user.id;

    if (userId == null) {
      log("User not found=========User id is null");
      return;
    }

    try {
      isLoading(true);

      final success = await _profileService.requestAccountDeletion(userId);

      if (success) {
        log("==========================>Your account deletion request has been submitted successfully.");

        Get.offAll(() => OnBoardScreen());
        await logoutUserInBackground();
      } else {
        log("==========================>Unable to request account deletion");
      }
    } catch (e) {
      log("==========================>Something went wrong");
    } finally {
      isLoading(false);
    }
  }

//-------------------------------------------------------------------------------------------------------------------------------------
  // ================== CLEANUP ==================
  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    super.onClose();
  }
}
