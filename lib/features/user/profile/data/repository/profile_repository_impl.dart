import '../../domain/repository/profile_repository.dart';
import '../sources/profile_auth.dart';
import '../models/UserModel.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileAuth profileAuth;
  ProfileRepositoryImpl({required this.profileAuth});

  @override
  Future<Profile> fetchProfile(String token) async {
    final response = await profileAuth.fetchProfile(token);
    print('final user${response}');
    return response;
  }
}
