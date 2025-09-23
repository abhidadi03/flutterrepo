abstract class UserEvent {}

class FetchUsers extends UserEvent {}

class CreateUser extends UserEvent {
  final String name;
  final String email;
  final String password;
  final String phone;
  CreateUser(
      {required this.name,
      required this.email,
      required this.password,
      required this.phone});
}

class DeleteUser extends UserEvent {
  final int id;
  DeleteUser({required this.id});
}

class UpdateUser extends UserEvent {
  final int id;
  final String name;
  final String email;
  UpdateUser({required this.id, required this.name, required this.email});
}
