import '../../../profile/data/models/UserModel.dart';

abstract class ProfileRepository {
  Future<Profile> fetchProfile(String token);
}
