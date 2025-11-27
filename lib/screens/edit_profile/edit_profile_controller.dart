// // ignore_for_file: prefer_conditional_assignment, avoid_print, depend_on_referenced_packages

// import 'dart:developer';
// import 'dart:io';
// import 'package:country_picker/country_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:mime/mime.dart';
// import 'package:http_parser/http_parser.dart';

// import '../../constants/app_constant.dart';
// import '../../constants/app_urls.dart';
// import '../../main.dart';
// import '../../models/user_profile.dart';
// import '../../services/api_service.dart';
// import '../../widgets/app_snackbar.dart';

// import 'package:http/http.dart' as http;

// class EditProfileController extends GetxController {
//   // ------------------ FORM KEYS ------------------
//   final formKey = GlobalKey<FormState>();

//   // ------------------ TEXT CONTROLLERS ------------------
//   final TextEditingController fullNameController = TextEditingController();
//   final TextEditingController phoneNumberController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();

//   // ------------------ IMAGE PICKER ------------------
//   final ImagePicker _picker = ImagePicker();
//   Rx<File?> profileImage = Rx<File?>(null);

//   // ------------------ COUNTRY ------------------
//   Rx<Country?> country = Rx<Country?>(null);

//   // ------------------ USER PROFILE  mock data ------------------
//   final Rx<UserProfile> userProfile = UserProfile(
//     fullName: 'Albert Dan J',
//     countryCode: '+91',
//     phoneNumber: '3533892939',
//     email: 'albert.dan.j@gmail.com',
//   ).obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _loadUserData();
//     _setInitialCountryFromCode(userProfile.value.countryCode);
//   }

//   // ------------------ IMAGE PICK ------------------
//   Future<void> pickProfileImage() async {
//     try {
//       bool granted = await _requestGalleryPermission();

//       if (!granted) {
//         appSnackbar(
//           error: true,
//           title: "Permission Required",
//           content: "Please allow gallery access to upload profile picture",
//         );
//         return;
//       }

//       final XFile? image = await _picker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 80,
//       );

//       if (image != null) {
//         profileImage.value = File(image.path);

//         /// AUTO UPLOAD AFTER PICK
//         await uploadProfileImage();
//       }
//     } catch (e) {
//       appSnackbar(
//           error: true, title: "Error", content: "Unable to open gallery");
//       print("Image Picker Error: $e");
//     }
//   }

//   // ------------------ UPLOAD PROFILE IMAGE (MAIN FUNCTION) ------------------
//   Future<void> uploadProfileImage() async {
//     if (profileImage.value == null) {
//       appSnackbar(error: true, title: "Error", content: "No image selected");
//       return;
//     }

//     // Read userId properly
//     String? userId = storage.read(AppConst.USER_ID);

//     if (userId == null || userId.isEmpty) {
//       log("❌ ERROR: User ID not found in storage");
//       return;
//     }

//     try {
//       final imageFile = profileImage.value!;

//       // Dynamic MIME type
//       final mime = lookupMimeType(imageFile.path)!.split('/');

//       // Create dynamic multipart file
//       final multipartFile = await http.MultipartFile.fromPath(
//         "image",
//         imageFile.path,
//         contentType: MediaType(mime[0], mime[1]),
//       );

//       final response = await APIService.uploadImageRequest(
//         url: "${AppURLs.PROFILE_UPDATE_API}$userId/profile-picture",
//         method: "PUT",
//         file: multipartFile,
//       );

//       if (response != null && response.statusCode == 200) {
//         appSnackbar(
//           title: "Success",
//           content: "Profile picture updated successfully",
//         );
//       } else {
//         appSnackbar(
//           error: true,
//           title: "Failed",
//           content: "Unable to upload image",
//         );
//       }
//     } catch (e) {
//       appSnackbar(
//         error: true,
//         title: "Error",
//         content: "Upload Failed",
//       );
//       print("UPLOAD IMAGE ERROR => $e");
//     }
//   }

//   // ------------------ COUNTRY SETUP ------------------
//   void _setInitialCountryFromCode(String code) {
//     final cleanCode = code.replaceAll("+", "").trim();

//     Country? parsed = CountryParser.tryParsePhoneCode(cleanCode);

//     if (parsed == null) {
//       parsed = CountryParser.tryParseCountryCode(cleanCode.toUpperCase());
//     }

//     parsed ??= CountryParser.tryParseCountryCode('IN');

//     country.value = parsed;
//   }

//   void updateCountry(Country selectedCountry) {
//     country.value = selectedCountry;
//   }

//   String get fullPhoneNumber {
//     final c = country.value;
//     if (c == null) return '';
//     return '+${c.phoneCode}${phoneNumberController.text}';
//   }

//   // ------------------ LOAD USER DATA ------------------
//   void _loadUserData() {
//     fullNameController.text = userProfile.value.fullName;
//     phoneNumberController.text = userProfile.value.phoneNumber;
//     emailController.text = userProfile.value.email;
//   }

//   // ------------------ VALIDATIONS ------------------
//   String? validateFullName(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return "Full name is required";
//     }
//     if (value.trim().length < 3) {
//       return "Name must be at least 3 characters";
//     }
//     if (!RegExp(r"^[a-zA-Z ]+$").hasMatch(value.trim())) {
//       return "Only alphabets allowed";
//     }
//     return null;
//   }

//   String? validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return "Email is required";
//     }
//     final emailRegex = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$");
//     if (!emailRegex.hasMatch(value)) {
//       return "Enter a valid email";
//     }
//     return null;
//   }

//   String? validatePhone(String? value) {
//     if (value == null || value.isEmpty) {
//       return "Phone number is required";
//     }
//     if (!RegExp(r"^[0-9]+$").hasMatch(value)) {
//       return "Only numbers allowed";
//     }
//     if (value.length < 6) {
//       return "Number too short";
//     }
//     if (value.length > 15) {
//       return "Number too long";
//     }
//     return null;
//   }

//   // ------------------ SAVE CHANGES ------------------
//   void saveChanges() {
//     if (!formKey.currentState!.validate()) {
//       appSnackbar(
//           error: true, title: "Error", content: "Please correct the errors");
//       return;
//     }

//     userProfile.update((profile) {
//       profile?.fullName = fullNameController.text.trim();
//       profile?.countryCode = "+${country.value?.phoneCode}";
//       profile?.phoneNumber = phoneNumberController.text.trim();
//       profile?.email = emailController.text.trim();
//     });

//     appSnackbar(title: "Success", content: "Profile updated successfully");
//     Get.back();
//   }

//   // ------------------ PERMISSION ------------------
//   Future<bool> _requestGalleryPermission() async {
//     if (Platform.isAndroid) {
//       final photosStatus = await Permission.photos.request();
//       if (photosStatus.isGranted) return true;

//       final storageStatus = await Permission.storage.request();
//       if (storageStatus.isGranted) return true;

//       if (photosStatus.isPermanentlyDenied ||
//           storageStatus.isPermanentlyDenied) {
//         openAppSettings();
//       }

//       return false;
//     }

//     final iosStatus = await Permission.photos.request();
//     if (iosStatus.isGranted) return true;

//     if (iosStatus.isPermanentlyDenied) {
//       openAppSettings();
//     }

//     return false;
//   }

//   // ------------------ CLEANUP ------------------
//   @override
//   void onClose() {
//     fullNameController.dispose();
//     phoneNumberController.dispose();
//     emailController.dispose();
//     super.onClose();
//   }
// }
