class UserProfileModel {
  final bool success;
  final UserData user;

  UserProfileModel({
    required this.success,
    required this.user,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      success: json["success"] ?? false,
      user: json["user"] != null
          ? UserData.fromJson(json["user"])
          : UserData.empty(),
    );
  }
}

class UserData {
  final Wallet wallet;
  final KycDetails kycDetails;
  final ChatSettings chatSettings;
  final NotificationPreferences notificationPreferences;
  final DeletionRequest? deletionRequest;

  final String fcmToken;
  final String id;
  final String name;
  final String email;
  final String profilePicture;
  final String firebaseUid;
  final String phoneNumber;
  final String deviceToken;

  final List<dynamic> wishlist;

  final bool isAgree;

  final ReferredBy? referredBy;
  final List<dynamic> referredUsers;

  final int referralLimit;
  final String role;
  final bool isActive;

  final num totalEarnings;
  final num availableBalance;

  final List<Address> addresses;

  final List<dynamic> kycDocuments;
  final List<dynamic> bankDetails;
  final List<dynamic> savedPlans;

  final String createdAt;
  final String updatedAt;
  final String referralCode;
  final String authMethod;

  final int unreadMessageCount;

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
    required this.wishlist,
    required this.isAgree,
    required this.referredBy,
    required this.referredUsers,
    required this.referralLimit,
    required this.role,
    required this.isActive,
    required this.totalEarnings,
    required this.availableBalance,
    required this.addresses,
    required this.kycDocuments,
    required this.bankDetails,
    required this.savedPlans,
    required this.createdAt,
    required this.updatedAt,
    required this.referralCode,
    required this.authMethod,
    required this.unreadMessageCount,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      wallet: json["wallet"] != null
          ? Wallet.fromJson(json["wallet"])
          : Wallet.empty(),

      kycDetails: json["kycDetails"] != null
          ? KycDetails.fromJson(json["kycDetails"])
          : KycDetails.empty(),

      chatSettings: json["chatSettings"] != null
          ? ChatSettings.fromJson(json["chatSettings"])
          : ChatSettings.empty(),

      notificationPreferences: json["notificationPreferences"] != null
          ? NotificationPreferences.fromJson(json["notificationPreferences"])
          : NotificationPreferences.empty(),

      deletionRequest: json["deletionRequest"] != null
          ? DeletionRequest.fromJson(json["deletionRequest"])
          : null,

      fcmToken: json["fcmToken"] ?? "",
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      profilePicture: json["profilePicture"] ?? "",
      firebaseUid: json["firebaseUid"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      deviceToken: json["deviceToken"] ?? "",

      wishlist: json["wishlist"] ?? [],
      isAgree: json["isAgree"] ?? false,

      referredBy: json["referredBy"] != null
          ? ReferredBy.fromJson(json["referredBy"])
          : null,

      referredUsers: json["referredUsers"] ?? [],

      referralLimit: json["referralLimit"] ?? 0,
      role: json["role"] ?? "",
      isActive: json["isActive"] ?? false,

      totalEarnings: json["totalEarnings"] ?? 0,
      availableBalance: json["availableBalance"] ?? 0,

      addresses: json["addresses"] != null
          ? (json["addresses"] as List)
              .map((e) => Address.fromJson(e))
              .toList()
          : [],

      kycDocuments: json["kycDocuments"] ?? [],
      bankDetails: json["bankDetails"] ?? [],
      savedPlans: json["savedPlans"] ?? [],

      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      referralCode: json["referralCode"] ?? "",
      authMethod: json["authMethod"] ?? "",
      unreadMessageCount: json["unreadMessageCount"] ?? 0,
    );
  }

  /// EMPTY FALLBACK (never crashes)
  factory UserData.empty() {
    return UserData(
      wallet: Wallet.empty(),
      kycDetails: KycDetails.empty(),
      chatSettings: ChatSettings.empty(),
      notificationPreferences: NotificationPreferences.empty(),
      deletionRequest: null,
      fcmToken: "",
      id: "",
      name: "",
      email: "",
      profilePicture: "",
      firebaseUid: "",
      phoneNumber: "",
      deviceToken: "",
      wishlist: [],
      isAgree: false,
      referredBy: null,
      referredUsers: [],
      referralLimit: 0,
      role: "",
      isActive: false,
      totalEarnings: 0,
      availableBalance: 0,
      addresses: [],
      kycDocuments: [],
      bankDetails: [],
      savedPlans: [],
      createdAt: "",
      updatedAt: "",
      referralCode: "",
      authMethod: "",
      unreadMessageCount: 0,
    );
  }
}

/// ----------------------
/// WALLET
/// ----------------------
class Wallet {
  final num balance;
  final List<dynamic> transactions;

  Wallet({
    required this.balance,
    required this.transactions,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      balance: json["balance"] ?? 0,
      transactions: json["transactions"] ?? [],
    );
  }

  factory Wallet.empty() => Wallet(balance: 0, transactions: []);
}

/// ----------------------
/// KYC DETAILS
/// ----------------------
class KycDetails {
  final String aadharCardNumber;
  final String panCardNumber;
  final bool aadharVerified;
  final bool panVerified;

  KycDetails({
    required this.aadharCardNumber,
    required this.panCardNumber,
    required this.aadharVerified,
    required this.panVerified,
  });

  factory KycDetails.fromJson(Map<String, dynamic> json) {
    return KycDetails(
      aadharCardNumber: json["aadharCardNumber"] ?? "",
      panCardNumber: json["panCardNumber"] ?? "",
      aadharVerified: json["aadharVerified"] ?? false,
      panVerified: json["panVerified"] ?? false,
    );
  }

  factory KycDetails.empty() => KycDetails(
        aadharCardNumber: "",
        panCardNumber: "",
        aadharVerified: false,
        panVerified: false,
      );
}

/// ----------------------
/// CHAT SETTINGS
/// ----------------------
class ChatSettings {
  final bool allowMessages;
  final List<dynamic> blockedUsers;

  ChatSettings({
    required this.allowMessages,
    required this.blockedUsers,
  });

  factory ChatSettings.fromJson(Map<String, dynamic> json) {
    return ChatSettings(
      allowMessages: json["allowMessages"] ?? true,
      blockedUsers: json["blockedUsers"] ?? [],
    );
  }

  factory ChatSettings.empty() =>
      ChatSettings(allowMessages: true, blockedUsers: []);
}

/// ----------------------
/// NOTIFICATION PREFS
/// ----------------------
class NotificationPreferences {
  final bool orderUpdates;
  final bool paymentAlerts;
  final bool promotionalOffers;
  final bool pushEnabled;
  final bool systemNotifications;

  NotificationPreferences({
    required this.orderUpdates,
    required this.paymentAlerts,
    required this.promotionalOffers,
    required this.pushEnabled,
    required this.systemNotifications,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      orderUpdates: json["orderUpdates"] ?? false,
      paymentAlerts: json["paymentAlerts"] ?? false,
      promotionalOffers: json["promotionalOffers"] ?? false,
      pushEnabled: json["pushEnabled"] ?? false,
      systemNotifications: json["systemNotifications"] ?? false,
    );
  }

  factory NotificationPreferences.empty() => NotificationPreferences(
        orderUpdates: false,
        paymentAlerts: false,
        promotionalOffers: false,
        pushEnabled: false,
        systemNotifications: false,
      );
}

/// ----------------------
/// DELETION REQUEST
/// ----------------------
class DeletionRequest {
  final String status;

  DeletionRequest({required this.status});

  factory DeletionRequest.fromJson(Map<String, dynamic> json) {
    return DeletionRequest(
      status: json["status"] ?? "",
    );
  }
}

/// ----------------------
/// REFERRED BY
/// ----------------------
class ReferredBy {
  final String id;
  final String name;
  final String email;

  ReferredBy({
    required this.id,
    required this.name,
    required this.email,
  });

  factory ReferredBy.fromJson(Map<String, dynamic> json) {
    return ReferredBy(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
    );
  }
}

/// ----------------------
/// ADDRESS
/// ----------------------
class Address {
  final String name;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String country;
  final String phoneNumber;
  final bool isDefault;
  final String addressType;
  final String landmark;

  final String createdAt;
  final String updatedAt;
  final String id;

  Address({
    required this.name,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    required this.country,
    required this.phoneNumber,
    required this.isDefault,
    required this.addressType,
    required this.landmark,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      name: json["name"] ?? "",
      addressLine1: json["addressLine1"] ?? "",
      addressLine2: json["addressLine2"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      pincode: json["pincode"] ?? "",
      country: json["country"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      isDefault: json["isDefault"] ?? false,
      addressType: json["addressType"] ?? "",
      landmark: json["landmark"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      id: json["_id"] ?? "",
    );
  }
}










// import 'dart:convert';

// UserProfileModel userProfileModelFromJson(String str) =>
//     UserProfileModel.fromJson(json.decode(str));

// class UserProfileModel {
//   bool success;
//   UserData user;

//   UserProfileModel({required this.success, required this.user});

//   factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
//       UserProfileModel(
//         success: json["success"],
//         user: UserData.fromJson(json["user"]),
//       );
// }

// class UserData {
//   Wallet wallet;
//   KycDetails kycDetails;
//   ChatSettings chatSettings;
//   NotificationPreferences notificationPreferences;
//   DeletionRequest deletionRequest;
//   String? fcmToken;
//   String id;
//   String name;
//   String email;
//   String profilePicture;
//   String firebaseUid;
//   String phoneNumber;
//   String? deviceToken;
//   bool isAgree;
//   int? referralLimit;
//   String? role;
//   bool isActive;
//   int? totalEarnings;
//   int availableBalance;
//   List<dynamic> wishlist;
//   List<dynamic> addresses;
//   List<dynamic> kycDocuments;
//   List<dynamic> bankDetails;
//   List<dynamic> savedPlans;
//   List<dynamic> referredUsers;
//   String? referredBy;
//   DateTime createdAt;
//   DateTime updatedAt;
//   String referralCode;
//   String? authMethod;
//   int? unreadMessageCount;

//   UserData({
//     required this.wallet,
//     required this.kycDetails,
//     required this.chatSettings,
//     required this.notificationPreferences,
//     required this.deletionRequest,
//     required this.fcmToken,
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.profilePicture,
//     required this.firebaseUid,
//     required this.phoneNumber,
//     required this.deviceToken,
//     required this.isAgree,
//     required this.referralLimit,
//     required this.role,
//     required this.isActive,
//     required this.totalEarnings,
//     required this.availableBalance,
//     required this.wishlist,
//     required this.addresses,
//     required this.kycDocuments,
//     required this.bankDetails,
//     required this.savedPlans,
//     required this.referredUsers,
//     required this.referredBy,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.referralCode,
//     required this.authMethod,
//     required this.unreadMessageCount,
//   });

//   factory UserData.fromJson(Map<String, dynamic> json) => UserData(
//         wallet: Wallet.fromJson(json["wallet"]),
//         kycDetails: KycDetails.fromJson(json["kycDetails"]),
//         chatSettings: ChatSettings.fromJson(json["chatSettings"]),
//         notificationPreferences:
//             NotificationPreferences.fromJson(json["notificationPreferences"]),
//         deletionRequest: DeletionRequest.fromJson(json["deletionRequest"]),
//         fcmToken: json["fcmToken"],
//         id: json["_id"],
//         name: json["name"],
//         email: json["email"] ?? '',
//         profilePicture: json["profilePicture"] ?? '',
//         firebaseUid: json["firebaseUid"],
//         phoneNumber: json["phoneNumber"],
//         deviceToken: json["deviceToken"],
//         isAgree: json["isAgree"],
//         referralLimit: json["referralLimit"],
//         role: json["role"],
//         isActive: json["isActive"],
//         totalEarnings: json["totalEarnings"],
//         availableBalance: json["availableBalance"],
//         wishlist: List<dynamic>.from(json["wishlist"]),
//         addresses: List<dynamic>.from(json["addresses"]),
//         kycDocuments: List<dynamic>.from(json["kycDocuments"]),
//         bankDetails: List<dynamic>.from(json["bankDetails"]),
//         savedPlans: List<dynamic>.from(json["savedPlans"]),
//         referredUsers: List<dynamic>.from(json["referredUsers"]),
//         referredBy: json["referredBy"],
//         createdAt: DateTime.parse(json["createdAt"]),
//         updatedAt: DateTime.parse(json["updatedAt"]),
//         referralCode: json["referralCode"],
//         authMethod: json["authMethod"],
//         unreadMessageCount: json["unreadMessageCount"],
//       );
// }

// class Wallet {
//   int balance;
//   List<dynamic> transactions;

//   Wallet({required this.balance, required this.transactions});

//   factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
//         balance: json["balance"],
//         transactions: List<dynamic>.from(json["transactions"]),
//       );
// }

// class KycDetails {
//   String aadharCardNumber;
//   String panCardNumber;
//   bool aadharVerified;
//   bool panVerified;

//   KycDetails({
//     required this.aadharCardNumber,
//     required this.panCardNumber,
//     required this.aadharVerified,
//     required this.panVerified,
//   });

//   factory KycDetails.fromJson(Map<String, dynamic> json) => KycDetails(
//         aadharCardNumber: json["aadharCardNumber"],
//         panCardNumber: json["panCardNumber"],
//         aadharVerified: json["aadharVerified"],
//         panVerified: json["panVerified"],
//       );
// }

// class ChatSettings {
//   bool allowMessages;
//   List<dynamic> blockedUsers;

//   ChatSettings({
//     required this.allowMessages,
//     required this.blockedUsers,
//   });

//   factory ChatSettings.fromJson(Map<String, dynamic> json) => ChatSettings(
//         allowMessages: json["allowMessages"],
//         blockedUsers: List<dynamic>.from(json["blockedUsers"]),
//       );
// }

// class NotificationPreferences {
//   bool orderUpdates;
//   bool paymentAlerts;
//   bool promotionalOffers;
//   bool pushEnabled;
//   bool systemNotifications;

//   NotificationPreferences({
//     required this.orderUpdates,
//     required this.paymentAlerts,
//     required this.promotionalOffers,
//     required this.pushEnabled,
//     required this.systemNotifications,
//   });

//   factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
//       NotificationPreferences(
//         orderUpdates: json["orderUpdates"],
//         paymentAlerts: json["paymentAlerts"],
//         promotionalOffers: json["promotionalOffers"],
//         pushEnabled: json["pushEnabled"],
//         systemNotifications: json["systemNotifications"],
//       );
// }

// class DeletionRequest {
//   String status;

//   DeletionRequest({required this.status});

//   factory DeletionRequest.fromJson(Map<String, dynamic> json) =>
//       DeletionRequest(status: json["status"]);
// }
