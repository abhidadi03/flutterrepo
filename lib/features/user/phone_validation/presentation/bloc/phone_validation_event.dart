abstract class PhoneValidationEvent {}

class SendOtp extends PhoneValidationEvent {
  final String phone;
  final bool isLinking;
  SendOtp({required this.phone, this.isLinking = false});
}

class VerifyOtp extends PhoneValidationEvent {
  final String verficationId;
  final String otp;
  final bool isLinking;
  final String? token;
  VerifyOtp(
      {required this.verficationId,
      required this.otp,
      this.isLinking = false,
      this.token});
}

class ResendOtp extends PhoneValidationEvent {
  final String phone;
  final int? resendToken;
  ResendOtp({required this.phone, this.resendToken});
}

class OtpCodeSent extends PhoneValidationEvent {
  final String verificationId;
  final int? resendToken;

  OtpCodeSent(this.verificationId, this.resendToken);
}
