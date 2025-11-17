import 'dart:convert';
import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:saoirse_app/models/user_profile.dart';
import 'package:saoirse_app/widgets/app_snackbar.dart';

class EditProfileController extends GetxController {
  // ------------------ FORM KEYS ------------------
  final formKey = GlobalKey<FormState>();

  // ------------------ TEXT CONTROLLERS ------------------
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // ------------------ IMAGE PICKER ------------------
  final ImagePicker _picker = ImagePicker();
  Rx<File?> profileImage = Rx<File?>(null);

  // ------------------ COUNTRY ------------------
  Rx<Country?> country = Rx<Country?>(null);

  // ------------------ USER PROFILE  mock data ------------------
  final Rx<UserProfile> userProfile = UserProfile(
    fullName: 'Albert Dan J',
    countryCode: '+91',
    phoneNumber: '3533892939',
    email: 'albert.dan.j@gmail.com',
  ).obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _setInitialCountryFromCode(userProfile.value.countryCode);
  }

  // ------------------ IMAGE PICK ------------------
  Future<void> pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        profileImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar("Error", "Unable to open gallery",
          backgroundColor: Colors.red, colorText: Colors.white);
      print("Image Picker Error: $e");
    }
  }

  // ------------------ COUNTRY SETUP ------------------
  void _setInitialCountryFromCode(String code) {
    final cleanCode = code.replaceAll("+", "").trim();

    Country? parsed = CountryParser.tryParsePhoneCode(cleanCode);

    if (parsed == null) {
      parsed = CountryParser.tryParseCountryCode(cleanCode.toUpperCase());
    }

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

  // ------------------ LOAD USER DATA ------------------
  void _loadUserData() {
    fullNameController.text = userProfile.value.fullName;
    phoneNumberController.text = userProfile.value.phoneNumber;
    emailController.text = userProfile.value.email;
  }

  // ------------------ VALIDATIONS ------------------

  /// FULL NAME VALIDATION
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

  /// EMAIL VALIDATION
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

  /// PHONE NUMBER VALIDATION
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

  // ------------------ SAVE CHANGES ------------------

  void saveChanges() {
    // Validate the form
    if (!formKey.currentState!.validate()) {
      appSnackbar(
          error: true, title: "Error", content: "Please correct the errors");
      return;
    }

    userProfile.update((profile) {
      profile?.fullName = fullNameController.text.trim();
      profile?.countryCode = "+${country.value?.phoneCode}";
      profile?.phoneNumber = phoneNumberController.text.trim();
      profile?.email = emailController.text.trim();
    });

    appSnackbar(title: "Success", content: "Profile updated successfully");
  }

  // ------------------ CLEANUP ------------------
  @override
  void onClose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    super.onClose();
  }

 
}
