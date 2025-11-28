import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));

class UserProfileModel {
  bool success;
  UserData user;

  UserProfileModel({required this.success, required this.user});

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        success: json["success"],
        user: UserData.fromJson(json["user"]),
      );
}

class UserData {
  Wallet wallet;
  KycDetails kycDetails;
  ChatSettings chatSettings;
  NotificationPreferences notificationPreferences;
  DeletionRequest deletionRequest;
  String? fcmToken;
  String id;
  String name;
  String email;
  String profilePicture;
  String firebaseUid;
  String phoneNumber;
  String? deviceToken;
  bool isAgree;
  int? referralLimit;
  String? role;
  bool isActive;
  int? totalEarnings;
  int availableBalance;
  List<dynamic> wishlist;
  List<dynamic> addresses;
  List<dynamic> kycDocuments;
  List<dynamic> bankDetails;
  List<dynamic> savedPlans;
  List<dynamic> referredUsers;
  String? referredBy;
  DateTime createdAt;
  DateTime updatedAt;
  String referralCode;
  String? authMethod;
  int? unreadMessageCount;

  UserData({
    required this.wallet,
    required this.kycDetails,
    required this.chatSettings,
    required this.notificationPreferences,
    required this.deletionRequest,
    required this.fcmToken,
    required this.id,
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.firebaseUid,
    required this.phoneNumber,
    required this.deviceToken,
    required this.isAgree,
    required this.referralLimit,
    required this.role,
    required this.isActive,
    required this.totalEarnings,
    required this.availableBalance,
    required this.wishlist,
    required this.addresses,
    required this.kycDocuments,
    required this.bankDetails,
    required this.savedPlans,
    required this.referredUsers,
    required this.referredBy,
    required this.createdAt,
    required this.updatedAt,
    required this.referralCode,
    required this.authMethod,
    required this.unreadMessageCount,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        wallet: Wallet.fromJson(json["wallet"]),
        kycDetails: KycDetails.fromJson(json["kycDetails"]),
        chatSettings: ChatSettings.fromJson(json["chatSettings"]),
        notificationPreferences:
            NotificationPreferences.fromJson(json["notificationPreferences"]),
        deletionRequest: DeletionRequest.fromJson(json["deletionRequest"]),
        fcmToken: json["fcmToken"],
        id: json["_id"],
        name: json["name"],
        email: json["email"] ?? '',
        profilePicture: json["profilePicture"] ?? '',
        firebaseUid: json["firebaseUid"],
        phoneNumber: json["phoneNumber"],
        deviceToken: json["deviceToken"],
        isAgree: json["isAgree"],
        referralLimit: json["referralLimit"],
        role: json["role"],
        isActive: json["isActive"],
        totalEarnings: json["totalEarnings"],
        availableBalance: json["availableBalance"],
        wishlist: List<dynamic>.from(json["wishlist"]),
        addresses: List<dynamic>.from(json["addresses"]),
        kycDocuments: List<dynamic>.from(json["kycDocuments"]),
        bankDetails: List<dynamic>.from(json["bankDetails"]),
        savedPlans: List<dynamic>.from(json["savedPlans"]),
        referredUsers: List<dynamic>.from(json["referredUsers"]),
        referredBy: json["referredBy"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        referralCode: json["referralCode"],
        authMethod: json["authMethod"],
        unreadMessageCount: json["unreadMessageCount"],
      );
}

class Wallet {
  int balance;
  List<dynamic> transactions;

  Wallet({required this.balance, required this.transactions});

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        balance: json["balance"],
        transactions: List<dynamic>.from(json["transactions"]),
      );
}

class KycDetails {
  String aadharCardNumber;
  String panCardNumber;
  bool aadharVerified;
  bool panVerified;

  KycDetails({
    required this.aadharCardNumber,
    required this.panCardNumber,
    required this.aadharVerified,
    required this.panVerified,
  });

  factory KycDetails.fromJson(Map<String, dynamic> json) => KycDetails(
        aadharCardNumber: json["aadharCardNumber"],
        panCardNumber: json["panCardNumber"],
        aadharVerified: json["aadharVerified"],
        panVerified: json["panVerified"],
      );
}

class ChatSettings {
  bool allowMessages;
  List<dynamic> blockedUsers;

  ChatSettings({
    required this.allowMessages,
    required this.blockedUsers,
  });

  factory ChatSettings.fromJson(Map<String, dynamic> json) => ChatSettings(
        allowMessages: json["allowMessages"],
        blockedUsers: List<dynamic>.from(json["blockedUsers"]),
      );
}

class NotificationPreferences {
  bool orderUpdates;
  bool paymentAlerts;
  bool promotionalOffers;
  bool pushEnabled;
  bool systemNotifications;

  NotificationPreferences({
    required this.orderUpdates,
    required this.paymentAlerts,
    required this.promotionalOffers,
    required this.pushEnabled,
    required this.systemNotifications,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      NotificationPreferences(
        orderUpdates: json["orderUpdates"],
        paymentAlerts: json["paymentAlerts"],
        promotionalOffers: json["promotionalOffers"],
        pushEnabled: json["pushEnabled"],
        systemNotifications: json["systemNotifications"],
      );
}

class DeletionRequest {
  String status;

  DeletionRequest({required this.status});

  factory DeletionRequest.fromJson(Map<String, dynamic> json) =>
      DeletionRequest(status: json["status"]);
}
