abstract class VerifyOtpEvent {}

class ValidateOtp extends VerifyOtpEvent {
  final String email;
  final String otp;
  ValidateOtp(this.email, this.otp);
}
