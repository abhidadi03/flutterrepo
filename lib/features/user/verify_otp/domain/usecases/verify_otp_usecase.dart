import '../repository/verify_otp_repository.dart';

class VerifyOtpUsecase {
  final VerifyOtpRepository _verifyOtpRepository;
  VerifyOtpUsecase(this._verifyOtpRepository);

  Future<String> verifyOtp(String phone, String otp) async {
    return await _verifyOtpRepository.verifyOtp(phone, otp);
  }
}
