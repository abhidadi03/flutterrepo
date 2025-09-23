import 'package:dio/dio.dart';
import 'package:myfirstapp/features/user/auth/data/models/user_model.dart';

import '../../../../user/auth/domain/repository/ForgotPassword_repository.dart';
import '../../../../user/data/sources/user_api.dart';
import '../../../auth/domain/usecases/forgotpassword_usecase.dart';

class ForgotpasswordRepositoryImpl implements ForgotpasswordRepository {
  @override
  final UserApi _userApi;
  ForgotpasswordRepositoryImpl(this._userApi);
  Future<String> forgotPassword(String email) async {
    print("email--$email");
    try {
      final response = await _userApi.sendOtp({'email': email});
      return response;
    } catch (e) {
      print('error in the impl:$e');
      // throw Exception("failed:$e");
      throw e;
      // return e;
    }
  }

  Future<String> validateOtp(String email, String otp) async {
    try {
      final response = await _userApi.verifyOtp({'email': email, 'otp': otp});
      return response;
    } catch (e) {
      print("error in the validate otp");
      // throw Exception("failed:$e");
      throw e;
    }
  }

  Future<String> resetPassword(ResetPasswordRequest request) async {
    try {
      print("requesttttt -- ${request.email}");
      print("requesttttt -- ${request.newPassword}");
      print("requesttttt -- ${request.confirmPassword}");
      print("request1 -- ${request.toJson()}");
      final response = await _userApi.resetpassword(request.toJson());
      // return response["detail"] as String;
      return response.detail;
    } catch (e) {
      print("error uin impl ${e.toString()}");
      throw Exception("failed:$e");
    }
  }
}
