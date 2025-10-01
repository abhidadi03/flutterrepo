import '../repository/otp_repository.dart';

class SendOtpUsecase {
  final OtpRepository _otpRepository;

  SendOtpUsecase(this._otpRepository);

  Future<bool> sendOtp(String phone) async {
    return await _otpRepository.sendOtp(phone);
  }
}
