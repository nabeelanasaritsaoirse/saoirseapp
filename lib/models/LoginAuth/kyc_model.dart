

import 'dart:convert';

KycModel kycModelFromJson(String str) => KycModel.fromJson(json.decode(str));

String kycModelToJson(KycModel data) => json.encode(data.toJson());

class KycModel {
    bool kycExists;
    String status;

    KycModel({
        required this.kycExists,
        required this.status,
    });

    factory KycModel.fromJson(Map<String, dynamic> json) => KycModel(
        kycExists: json["kycExists"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "kycExists": kycExists,
        "status": status,
    };
}
