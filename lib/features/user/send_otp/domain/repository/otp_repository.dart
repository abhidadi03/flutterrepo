abstract class OtpRepository {
  Future<bool> sendOtp(String phone);
  Future<void> verifyOtp({required String verificationId, required String otp});
}
