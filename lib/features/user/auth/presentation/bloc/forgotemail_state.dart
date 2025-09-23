abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {}

class ForgotPassowrdFailure extends ForgotPasswordState {
  final String detail;
  ForgotPassowrdFailure(this.detail);
}

class ResetPasswordSuccess extends ForgotPasswordState {
  final String message;
  ResetPasswordSuccess(this.message);
}

class OTPSent extends ForgotPasswordState {}

class OTPVerified extends ForgotPasswordState {}
