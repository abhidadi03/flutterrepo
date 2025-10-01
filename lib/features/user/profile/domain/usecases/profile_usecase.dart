import 'package:myfirstapp/features/user/profile/data/models/UserModel.dart';

import '../repository/profile_repository.dart';

class ProfileUsecase {
  final ProfileRepository profileRepository;
  ProfileUsecase(this.profileRepository);

  Future<Profile> execute(String token) {
    return profileRepository.fetchProfile(token);
  }
}
