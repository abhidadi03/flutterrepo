abstract class VerifyOtpEvent {}

class VerfiyOtp extends VerifyOtpEvent {
  final String phone;
  final String otp;
  VerfiyOtp({required this.phone, required this.otp});
}
