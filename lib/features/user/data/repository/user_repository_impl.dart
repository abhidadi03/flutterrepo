import 'package:myfirstapp/features/user/data/sources/user_api.dart';
import '../../../../features/user/domain/repository/user_repository.dart';
import '../../data/models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserApi userApi;
  UserRepositoryImpl({required this.userApi});

  @override
  Future<List<UserModel>> fetchUsers() => userApi.getUsers();

  @override
  Future<Map<String, dynamic>> createUser(
      {required String name,
      required String email,
      required String password,
      required String phone}) {
    print('came inot impl');
    return userApi.createUser({
      'name': name,
      'email': email,
      'password': password,
      'phone_no': phone
    });
  }

  @override
  Future<UserModel> updateUser({required id, String? name, String? email}) {
    final body = {'name': name, 'email': email};
    return userApi.updateUser(id, body);
  }

  @override
  Future<void> deleteUser(int id) => userApi.deleteUser(id);

  // @override
  // Future<String>
}
