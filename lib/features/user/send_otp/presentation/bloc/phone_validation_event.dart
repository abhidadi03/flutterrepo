abstract class PhoneValidationEvent {}

class SendOtp extends PhoneValidationEvent {
  final String phone;
  SendOtp({required this.phone});
}

class VerfiyOtp extends PhoneValidationEvent {
  final String verficationId;
  final String otp;
  VerfiyOtp({required this.verficationId, required this.otp});
}
