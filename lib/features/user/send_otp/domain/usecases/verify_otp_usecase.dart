import '../repository/otp_repository.dart';

class VerifyOtpUsecase {
  final OtpRepository otpRepository;
  VerifyOtpUsecase(this.otpRepository);

  Future<void> execute({required String verificationId, required String otp}) {
    return otpRepository.verifyOtp(verificationId: verificationId, otp: otp);
  }
}
