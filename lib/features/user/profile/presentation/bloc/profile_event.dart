abstract class ProfileEvent {}

class FetchProfile extends ProfileEvent {
  final String token;
  FetchProfile({required this.token});
}
