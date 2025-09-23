import '../repository/user_repository.dart';
import '../../data/models/user_model.dart';

class CreateUserUseCase {
  final UserRepository repository;
  CreateUserUseCase(this.repository);
  Future<Map<String, dynamic>> call(
      {required String name,
      required String email,
      required String password,
      required String phone}) {
    return repository.createUser(
        name: name, email: email, password: password, phone: phone);
  }
}
