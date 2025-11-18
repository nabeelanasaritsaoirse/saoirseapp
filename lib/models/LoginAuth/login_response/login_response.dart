import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  bool? success;
  String? message;
  Data? data;

  LoginResponse({this.success, this.message, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return _$LoginResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  LoginResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) {
    return LoginResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
