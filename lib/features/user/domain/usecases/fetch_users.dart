import '../../domain/repository/user_repository.dart';
import '../../data/models/user_model.dart';

class FetchUsersUseCase {
  final UserRepository repository;
  FetchUsersUseCase(this.repository);
  Future<List<UserModel>> call() {
    return repository.fetchUsers();
  }
}
