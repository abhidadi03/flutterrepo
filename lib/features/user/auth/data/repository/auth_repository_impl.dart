import 'package:myfirstapp/features/user/data/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/repository/auth_repository.dart';
import '../models/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../sources/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  final FirebaseAuth _firebaseAuth;
  final AuthApi authApi;

  AuthRepositoryImpl(this._firebaseAuth, this.authApi);
  // AuthRepositoryImpl(this._firebaseAuth);
  // AuthRepositoryImpl(this.authApi);
  Future<LoginedUser?> loginWithEmailPassword(
      String email, String password) async {
    try {
      final UserCredential usercredentials = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      // return UserCredential.user?.uid;
      final user = usercredentials.user;
      print("user in firebase$user");
      // final idToken = await user.getIdToken();
      if (user != null) {
        final storage = FlutterSecureStorage();
        // String? storedToken = await storage.read(key: 'id_token');
        final idToken = await user.getIdToken();
        await storage.write(key: 'id_token', value: idToken);
        print("tokennn----nn--:$idToken");

        return authApi.getUser("Bearer $idToken");
      }

      // return null;
    } catch (e) {
      print('Loginerror:$e');
      return null;
    }
  }

  Future<ValidateUserResponse> validateUser(String email) async {
    return await authApi.validateUser({"email": email});
  }

  Future<ValidateUserResponse> validatePhone(String phone) async {
    return await authApi.validateUserPhone({"phone_no": phone});
  }
}
