import '../entities/otp_result.dart';

abstract class OtpRepository {
  Future<bool> sendOtp(String phone);
  Future<void> verifyOtp({required String verificationId, required String otp});
  Future<OtpResult> resendOtp({required String phone, int? resendToken});
  Future<String> phoneLink({required String phone});
}
