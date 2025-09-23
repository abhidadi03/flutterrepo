abstract class PasswordEvent {}

class PasswordRequested extends PasswordEvent {
  final String email;
  PasswordRequested(this.email);
}

// class ValidateOtp extends PasswordEvent {
//   final String email;
//   final String otp;
//   ValidateOtp(this.email, this.otp);
// }

class ValidateOtp extends PasswordEvent {
  final String email;
  final String otp;
  ValidateOtp({required this.email, required this.otp});
}

class ResetPassword extends PasswordEvent {
  final String? email;
  final String? phone;
  final String newPassword;
  final String confirmPassword;
  ResetPassword(
      {this.email,
      this.phone,
      required this.newPassword,
      required this.confirmPassword});
}
