abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpSent extends OtpState {
  final String VerficationId;
  OtpSent(this.VerficationId);
}

class OtpSentStateFailed extends OtpState {
  final String message;
  OtpSentStateFailed(this.message);
}

class PhoneVerfied extends OtpState {
  final String message;
  PhoneVerfied(this.message);
}

class UserNotFound extends OtpState {}

class UserFound extends OtpState {}

class OtpVerified extends OtpState {}

class OtpVerificationFailed extends OtpState {
  final String message;
  OtpVerificationFailed(this.message);
}

class OtpSentSuccess extends OtpState {}

class VerifyOtpInitial extends OtpState {}

class VerifyOtpLoading extends OtpState {}

class VerifyOtpSuccess extends OtpState {}

class VerifyOtpFailure extends OtpState {
  final String message;
  VerifyOtpFailure(this.message);
}

class OtpVerficationFailed extends OtpState {}
