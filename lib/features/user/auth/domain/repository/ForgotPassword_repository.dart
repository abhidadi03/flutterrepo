import 'package:myfirstapp/features/user/auth/data/models/user_model.dart';

abstract class ForgotpasswordRepository {
  Future<String> forgotPassword(String email);
  Future<String> validateOtp(String email, String otp);
  Future<String> resetPassword(ResetPasswordRequest request);
}
