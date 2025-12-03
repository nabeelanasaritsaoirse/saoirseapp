// // To parse this JSON data, do
// //
// //     final kycPostModel = kycPostModelFromJson(jsonString);

// import 'dart:convert';

// KycPostModel kycPostModelFromJson(String str) =>
//     KycPostModel.fromJson(json.decode(str));

// String kycPostModelToJson(KycPostModel data) => json.encode(data.toJson());

// class KycPostModel {
//   bool success;
//   String message;
//   String status;

//   KycPostModel({
//     required this.success,
//     required this.message,
//     required this.status,
//   });

//   factory KycPostModel.fromJson(Map<String, dynamic> json) => KycPostModel(
//         success: json["success"],
//         message: json["message"],
//         status: json["status"],
//       );

//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "message": message,
//         "status": status,
//       };
// }
