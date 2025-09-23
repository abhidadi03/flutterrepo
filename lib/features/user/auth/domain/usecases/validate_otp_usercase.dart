import '../repository/ForgotPassword_repository.dart';

class ValidateOtpUsercase {
  final ForgotpasswordRepository _passwordRepository;
  ValidateOtpUsercase(this._passwordRepository);
  Future<String> validateOtp(String email, String otp) async {
    return await _passwordRepository.validateOtp(email, otp);
  }
}
