import 'package:myfirstapp/features/user/auth/data/models/user_model.dart';

import '../repository/ForgotPassword_repository.dart';

class ResetPasswordUsercase {
  final ForgotpasswordRepository _passwordRepository;

  ResetPasswordUsercase(this._passwordRepository);
  Future<String> call(ResetPasswordRequest request) async {
    return await _passwordRepository.resetPassword(request);
  }
}
