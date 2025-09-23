import '../repository/user_repository.dart';
import '../../data/models/user_model.dart';

class UpdateUserUseCase {
  final UserRepository repository;
  UpdateUserUseCase(this.repository);
  Future<UserModel> call(
      {required int id, required String name, required String email}) {
    return repository.updateUser(id: id, name: name, email: email);
  }
}
