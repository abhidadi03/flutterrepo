import 'package:myfirstapp/features/user/auth/data/models/user_model.dart';
import 'package:myfirstapp/features/user/data/models/user_model.dart';

import '../repository/auth_repository.dart';

class LoginUseCase {
  // final AuthRepository repository;

  // LoginUseCase(this.repository);
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);
  Future<LoginedUser?> execute(String email, String password) async {
    // return repository.login(email, password);
    return await _authRepository.loginWithEmailPassword(email, password);
  }

  Future<ValidateUserResponse?> validateUser(String email) async {
    return await _authRepository.validateUser(email);
  }

  Future<ValidateUserResponse?> validatePhone(String phone) async {
    return await _authRepository.validatePhone(phone);
  }
  // Future<ValidateUserResponse> validateUser(String email) async {
  //   return await _authRepository.validateUser(email);
  // }
}
