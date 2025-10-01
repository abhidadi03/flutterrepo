import '../repository/otp_repository.dart';

class PhoneLinkingUsecase {
  final OtpRepository _otpRepository;
  PhoneLinkingUsecase(this._otpRepository);

  Future<String> phoneLink({required String phone}) async {
    return await _otpRepository.phoneLink(phone: phone);
  }
}
