import "package:myfirstapp/features/user/auth/data/models/user_model.dart";

import "../../../data/models/user_model.dart";

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final LoginedUser user;
  AuthAuthenticated(this.user);
}

class AuthFailed extends AuthState {
  final String message;
  AuthFailed(this.message);
}

class AuthInavliduser extends AuthState {}

class AuthValidUser extends AuthState {}

class PhoneValidationFailure extends AuthState {}

class AuthPhoneValidated extends AuthState {}
