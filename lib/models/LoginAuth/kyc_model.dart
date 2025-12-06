import 'dart:convert';

KycModel kycModelFromJson(String str) => KycModel.fromJson(json.decode(str));

String kycModelToJson(KycModel data) => json.encode(data.toJson());

class KycModel {
  bool kycExists;
  String status;
  String? rejectionNote;
  List<KycDocument>? documents;

  KycModel({
    required this.kycExists,
    required this.status,
    this.rejectionNote,
    this.documents,
  });

  factory KycModel.fromJson(Map<String, dynamic> json) => KycModel(
        kycExists: json["kycExists"] ?? false,
        status: json["status"] ?? "not_submitted",
        rejectionNote: json["rejectionNote"],
        documents: json["documents"] == null
            ? null
            : List<KycDocument>.from(
                json["documents"].map((x) => KycDocument.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "kycExists": kycExists,
        "status": status,
        "rejectionNote": rejectionNote,
        "documents": documents == null
            ? null
            : List<dynamic>.from(documents!.map((x) => x.toJson())),
      };
}

class KycDocument {
  String type;
  String? frontUrl;
  String? backUrl;

  KycDocument({
    required this.type,
    this.frontUrl,
    this.backUrl,
  });

  factory KycDocument.fromJson(Map<String, dynamic> json) => KycDocument(
        type: json["type"],
        frontUrl: json["frontUrl"],
        backUrl: json["backUrl"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "frontUrl": frontUrl,
        "backUrl": backUrl,
      };
}


// import 'dart:convert';

// KycModel kycModelFromJson(String str) => KycModel.fromJson(json.decode(str));

// String kycModelToJson(KycModel data) => json.encode(data.toJson());

// class KycModel {
//     bool kycExists;
//     String status;

//     KycModel({
//         required this.kycExists,
//         required this.status,
//     });

//     factory KycModel.fromJson(Map<String, dynamic> json) => KycModel(
//         kycExists: json["kycExists"],
//         status: json["status"],
//     );

//     Map<String, dynamic> toJson() => {
//         "kycExists": kycExists,
//         "status": status,
//     };
// }
