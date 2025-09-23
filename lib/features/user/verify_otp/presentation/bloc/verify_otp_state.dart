abstract class VerifyOtpState {}

class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpLoading extends VerifyOtpState {}

class OtpVerficationFailed extends VerifyOtpState {
  final String message;
  OtpVerficationFailed(this.message);
}
