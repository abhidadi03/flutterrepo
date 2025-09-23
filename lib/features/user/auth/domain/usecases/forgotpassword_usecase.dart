import '../repository/ForgotPassword_repository.dart';

class ForgotpasswordUsecase {
  final ForgotpasswordRepository _passwordRepository;

  ForgotpasswordUsecase(this._passwordRepository);
  Future<String> execute(String email) async {
    return await _passwordRepository.forgotPassword(email);
  }

  // Future<String> validateOtp(String email, String otp) async {
  //   return await _passwordRepository.validateOtp(email, otp);
  // }
}
