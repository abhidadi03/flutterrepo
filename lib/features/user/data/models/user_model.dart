import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final int id;
  final String name;
  final String email;
  final bool is_active;
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.is_active,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

class UserChartData {
  final String status;
  final int count;
  UserChartData(this.status, this.count);
}

class ApiResponse {
  final String detail;

  ApiResponse({required this.detail});

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      ApiResponse(detail: json['detail']);
}
