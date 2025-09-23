import "package:myfirstapp/features/user/auth/data/models/user_model.dart";

import "../../../data/models/user_model.dart";

abstract class AuthRepository {
  Future<LoginedUser?> loginWithEmailPassword(String email, String password);
  // Future<void> logout();
  // UserModel? getCurrentUser();
  Future<ValidateUserResponse> validateUser(String email);
  Future<ValidateUserResponse> validatePhone(String phone);
}
