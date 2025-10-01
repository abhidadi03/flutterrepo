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

class FireBasePhoneUpdated extends OtpState {}

class UserNotFound extends OtpState {}

class UserExists extends OtpState {}

class UserFound extends OtpState {}

class OtpVerified extends OtpState {}

class OtpVerificationFailed extends OtpState {
  final String message;
  OtpVerificationFailed(this.message);
}

class OtpSentSuccess extends OtpState {
  final String verificationId;
  final int? resendToken;
  OtpSentSuccess({required this.verificationId, this.resendToken});
}

class VerifyOtpInitial extends OtpState {}

class VerifyOtpLoading extends OtpState {}

class VerifyOtpSuccess extends OtpState {}

class VerifyOtpFailure extends OtpState {
  final String message;
  VerifyOtpFailure(this.message);
}

class OtpVerficationFailed extends OtpState {}

class ResendOtpLoading extends OtpState {}

class ResendOtpSuccess extends OtpState {
  final String verificationId;
  int? resendToken;
  ResendOtpSuccess({required this.verificationId, this.resendToken});
}

class ResendOtpFailed extends OtpState {}
