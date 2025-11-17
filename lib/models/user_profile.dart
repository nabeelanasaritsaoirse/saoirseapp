class UserProfile {
  String fullName;
  String countryCode;
  String phoneNumber;
  String email;
  String? profileImage;

  UserProfile({
    required this.fullName,
    required this.countryCode,
    required this.phoneNumber,
    required this.email,
    this.profileImage,
  });
}