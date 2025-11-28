// ignore_for_file: avoid_print

import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/app_assets.dart';
import '../../models/profile_response.dart';
import '../../services/profile_service.dart';
import '../../services/wishlist_service.dart';
import '../../widgets/app_snackbar.dart';

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
  var profile = Rxn<UserProfileModel>();
  var isLoading = false.obs;
  var errorMessage = "".obs;

  @override
  void onInit() {
    _setInitialCountryFromCode('+91');
    fetchWishlistCount();
    fetchUserProfile();
    super.onInit();
  }

  final myOrders = [
    {"icon": AppAssets.pending_payment, "title": "Pending Payment"},
    {"icon": AppAssets.order_history, "title": "Order History"},
    {"icon": AppAssets.wishlist, "title": "Wishlist"},
    {"icon": AppAssets.transactions, "title": "Transactions"},
    {"icon": AppAssets.delivered, "title": "Delivered"},
    // {"icon": AppAssets.customer_care, "title": "Customer Care"},
  ];

  final settings = [
    // {"icon": AppAssets.password_security, "title": "Password & security"},
    {"icon": AppAssets.privacy_policy, "title": "Privacy Policy"},
    {"icon": AppAssets.terms_condition, "title": "Terms & Condition"},
    // {"icon": AppAssets.faq, "title": "FAQ"},
    // {"icon": AppAssets.about, "title": "About EPI"},
    {"icon": AppAssets.logout, "title": "Log Out"},
  ];

  Future<void> fetchWishlistCount() async {
    final count = await _wishlistService.getWishlistCount();
    wishlistCount.value = count ?? 0;
  }

  //Fetch Profile
  Future<void> fetchUserProfile() async {
    try {
      print("------------------------------------------");
      print(" Fetching user profile...");
      isLoading(true);

      final response = await _profileService.fetchProfile();

      if (response == null) {
        print("ERROR: Unable to fetch profile");
        errorMessage("Unable to fetch profile");
      } else {
        print(" PROFILE UPDATED IN CONTROLLER");
        print("Name         : ${response.user.name}");
        print("Email        : ${response.user.email}");
        print("Phone        : ${response.user.phoneNumber}");
        print("------------------------------------------");
        // SET TEXT CONTROLLERS
        profile.value = response;

        fullNameController.text = response.user.name;
        emailController.text = response.user.email;
        phoneNumberController.text = response.user.phoneNumber;
        // ------------ FIELD VISIBILITY LOGIC ------------
        final email = response.user.email;
        final phone = response.user.phoneNumber;

        showEmailField.value = email.isNotEmpty;
        showPhoneField.value = phone.isNotEmpty;

        print("Show Email Field: ${showEmailField.value}");
        print("Show Phone Field: ${showPhoneField.value}");
      }
    } catch (e) {
      print(" Exception Occurred: $e");
      errorMessage("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  // // ================== UPDATE USERNAME ONLY ==================
  // Future<void> updateUserName() async {
  //   if (fullNameController.text.trim().isEmpty) {
  //     appToast(error: true, title: "Error", content: "Name cannot be empty");
  //     return;
  //   }

  //   try {
  //     isLoading(true);
  //     final userId = profile.value?.user.id;
  //     final token = storage.read(AppConst.ACCESS_TOKEN);

  //     final response = await APIService.putRequest(
  //       url: AppURLs.USER_UPDATE_API + userId!, //  CORRECT ENDPOINT
  //       headers: {
  //         "Authorization": "Bearer $token",
  //         "Content-Type": "application/json",
  //       },
  //       body: {
  //         "name": fullNameController.text.trim(), // ONLY NAME
  //       },
  //       onSuccess: (data) => data,
  //     );

  //     print("Update Response => $response");

  //     if (response != null && response["success"] == true) {
  //       appToast(title: "Success", content: "Name updated");
  //       await fetchUserProfile();

  //       Get.back(); // Go back to Profile Screen
  //     } else {
  //       appToast(error: true, title: "Failed", content: "Update failed");
  //     }
  //   } catch (e) {
  //     print("UPDATE NAME ERROR => $e");
  //     appToast(error: true, title: "Error", content: "Something went wrong");
  //   } finally {
  //     isLoading(false);
  //   }
  // }

// ================== PICK PROFILE IMAGE ==================
  Future<void> pickProfileImage() async {
    try {
      bool granted = await _requestGalleryPermission();
      if (!granted) return;

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        profileImage.value = File(image.path);
        // await uploadUserProfilePicture(image.path);----------(commendd for auto upload)
      }
    } catch (e) {
      print("PICK IMAGE ERROR: $e");
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
//         print("UserID not found");
//         appToast(error: true, title: "Error", content: "User not found");
//         return;
//       }

//       print(" Uploading profile image for user: $userId");

//       final success =
//           await _profileService.updateProfilePicture(userId, imagePath);

//       if (success) {
//         appToast(
//           title: "Success",
//           content: "Profile picture updated successfully",
//         );

//         print(" Refreshing user profile...");
//         await fetchUserProfile();
//       } else {
//         appToast(
//           error: true,
//           title: "Failed",
//           content: "Unable to upload profile picture",
//         );
//       }
//     } catch (e) {
//       print(" Controller Error: $e");
//       appToast(error: true, title: "Error", content: "Something went wrong");
//     } finally {
//       // hide loader after everything
//       isLoading(false);
//     }
//   }

  // ================== GALLERY PERMISSION ==================
  Future<bool> _requestGalleryPermission() async {
    if (Platform.isAndroid) {
      final photos = await Permission.photos.request();
      final storage = await Permission.storage.request();

      if (photos.isGranted || storage.isGranted) return true;

      if (photos.isPermanentlyDenied || storage.isPermanentlyDenied) {
        openAppSettings();
      }
      return false;
    }

    final ios = await Permission.photos.request();
    if (ios.isGranted) return true;

    if (ios.isPermanentlyDenied) openAppSettings();
    return false;
  }

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
