class AddressResponse {
  final bool success;
  final List<Address> addresses;

  AddressResponse({
    required this.success,
    required this.addresses,
  });

  factory AddressResponse.fromJson(Map<String, dynamic> json) {
    return AddressResponse(
      success: json['success'] ?? false,
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => Address.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'addresses': addresses.map((e) => e.toJson()).toList(),
    };
  }
}

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
  final DateTime createdAt;
  final DateTime updatedAt;
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
      name: json['name'] ?? '',
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      country: json['country'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      isDefault: json['isDefault'] ?? false,
      addressType: json['addressType'] ?? '',
      landmark: json['landmark'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'country': country,
      'phoneNumber': phoneNumber,
      'isDefault': isDefault,
      'addressType': addressType,
      'landmark': landmark,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '_id': id,
    };
  }

  Address copyWith({
    String? name,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? pincode,
    String? country,
    String? phoneNumber,
    bool? isDefault,
    String? addressType,
    String? landmark,
    DateTime? updatedAt,
  }) {
    return Address(
      id: id,
      name: name ?? this.name,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      country: country ?? this.country,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isDefault: isDefault ?? this.isDefault,
      addressType: addressType ?? this.addressType,
      landmark: landmark ?? this.landmark,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
