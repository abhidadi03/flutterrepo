import '../../data/models/user_model.dart';

abstract class UserRepository {
  Future<List<UserModel>> fetchUsers();
  Future<Map<String, dynamic>> createUser(
      {required String name,
      required String email,
      required String password,
      required String phone});
  Future<UserModel> updateUser({required int id, String? name, String? email});
  Future<void> deleteUser(int id);
}









// class UserRepository {
//   final UserApi _userApi;
//   UserRepository(Dio dio)
//       : _userApi = UserApi(dio, baseUrl: "http://10.0.2.2:8000");
//   final Dio _dio = DioClient.createDio();

//   Future<List<UserModel>> fetchUsers() => _userApi.getUsers();
//   Future<UserModel> createUser({required String name, required email}) {
//     print('came inot repo');
//     return _userApi.createUser({'name': name, 'email': email});
//   }

//   Future<UserModel> updateUser(int id, String? name, String? email) {
//     final body = {'name': name, 'email': email};
//     return _userApi.updateUser(id, body);
//   }

//   Future<void> deleteUser(int id) => _userApi.deleteUser(id);
// }


  // Future<List<UserModel>> fetchUsers() async {
  //   try {
  //     final response = await _dio.get("/users");
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = response.data;
  //       print('data');
  //       return data.map((e) => UserModel.fromJson(e)).toList();
  //     } else {
  //       print('exception raised');
  //       throw Exception('failed to load users');
  //     }
  //   } on DioException catch (e) {
  //     throw Exception(e.message);
  //   }
  // }
  // Future<String?> createuser(
  //     {required String name, required String email}) async {
  //   print('came into creating userrrrrrr');
  //   final response = await http.post(Uri.parse("$baseUrl/users"),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({'name': name, 'email': email}));
  //   print('input:$name');
  //   print('email:$email');
  //   if (response.statusCode == 200) {
  //     print('user created ');
  //     return null;
  //   } else {
  //     print('failed to create user');
  //     // return false;
  //     final errorMessage = response.body.isNotEmpty
  //         ? jsonDecode(response.body)['detail']
  //         : 'failed to create user';
  //     // print('$errorMessage');
  //     print('errormessage:$errorMessage');
  //     // return errorMessage;
  //     throw Exception(errorMessage);
  //   }
  // }

  // Future<bool?> deleteUser(int id) async {
  //   print('id in the delete:$id');
  //   final response = await http.delete(Uri.parse('$baseUrl/users/$id'));
  //   print('response:${response.body}');
  //   if (response.statusCode == 200) {
  //     return true;
  //   }
  // }

  // Future<String?> updateUser({int? id, String? name, String? email}) async {
  //   final response = await http.put(Uri.parse("$baseUrl/users/$id"),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({'name': name, 'email': email}));
  //   print('input:$name');
  //   print('email:$email');
  //   if (response.statusCode == 200) {
  //     print('user updated ');
  //     return null;
  //   } else {
  //     print('failed to create user');
  //     final errorMessage =
  //         response.body.isNotEmpty ? response.body : 'failed to create user';
  //     return errorMessage;
  //   }
  // }

