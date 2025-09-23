// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginedUser _$LoginedUserFromJson(Map<String, dynamic> json) => LoginedUser(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String? ?? 'No Name',
      email: json['email'] as String? ?? '',
    );

Map<String, dynamic> _$LoginedUserToJson(LoginedUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
    };

ValidateUserResponse _$ValidateUserResponseFromJson(
        Map<String, dynamic> json) =>
    ValidateUserResponse(
      detail: json['detail'] as String,
      value: json['value'] as bool,
    );

Map<String, dynamic> _$ValidateUserResponseToJson(
        ValidateUserResponse instance) =>
    <String, dynamic>{
      'detail': instance.detail,
      'value': instance.value,
    };

ResetPasswordRequest _$ResetPasswordRequestFromJson(
        Map<String, dynamic> json) =>
    ResetPasswordRequest(
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      newPassword: json['newPassword'] as String,
      confirmPassword: json['confirmPassword'] as String,
    );

Map<String, dynamic> _$ResetPasswordRequestToJson(
        ResetPasswordRequest instance) =>
    <String, dynamic>{
      if (instance.email case final value?) 'email': value,
      if (instance.phone case final value?) 'phone': value,
      'newPassword': instance.newPassword,
      'confirmPassword': instance.confirmPassword,
    };

ResetPasswordResponse _$ResetPasswordResponseFromJson(
        Map<String, dynamic> json) =>
    ResetPasswordResponse(
      detail: json['detail'] as String,
    );

Map<String, dynamic> _$ResetPasswordResponseToJson(
        ResetPasswordResponse instance) =>
    <String, dynamic>{
      'detail': instance.detail,
    };
