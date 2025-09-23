import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class LoginedUser {
  final int? id;
  @JsonKey(defaultValue: 'No Name')
  final String? name;
  @JsonKey(defaultValue: '')
  final String? email;

  LoginedUser({required this.id, required this.name, required this.email});

  factory LoginedUser.fromJson(Map<String, dynamic> json) =>
      _$LoginedUserFromJson(json);

  Map<String, dynamic> toJson() => _$LoginedUserToJson(this);
}

@JsonSerializable()
class ValidateUserResponse {
  // @JsonKey(name: 'detail')
  final String detail;
  final bool value;
  ValidateUserResponse({required this.detail, required this.value});

  factory ValidateUserResponse.fromJson(Map<String, dynamic> json) =>
      _$ValidateUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ValidateUserResponseToJson(this);
}

@JsonSerializable(includeIfNull: false)
class ResetPasswordRequest {
  final String? email;
  final String? phone;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordRequest({
    this.email,
    this.phone,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);
}

@JsonSerializable()
class ResetPasswordResponse {
  final String detail;

  ResetPasswordResponse({required this.detail});

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordResponseToJson(this);
}
