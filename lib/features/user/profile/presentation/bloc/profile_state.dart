import 'package:myfirstapp/features/user/profile/data/models/UserModel.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

// class profileSuccess extends ProfileState {
//   final String firebase_uid;
//   final String name;
//   final String phone_no;
//   final int id;
//   final String email;
//   profileSuccess(
//       this.firebase_uid, this.email, this.id, this.name, this.phone_no);
// }

class ProfileSuccess extends ProfileState {
  final Profile user;
  ProfileSuccess(this.user);
}

class ProfileError extends ProfileState {
  final message;
  ProfileError(this.message);
}
