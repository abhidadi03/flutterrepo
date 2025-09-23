import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstapp/features/user/domain/usecases/create_user.dart';
import 'package:myfirstapp/features/user/domain/usecases/delete_user.dart';
import 'package:myfirstapp/features/user/domain/usecases/edit_user.dart';
import 'package:myfirstapp/features/user/domain/usecases/fetch_users.dart';
import 'user_event.dart';
import 'user_state.dart';
import '../../domain/repository/user_repository.dart';
import 'package:dio/dio.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;
  final FetchUsersUseCase fetchUsers;
  final UpdateUserUseCase updateUser;
  final DeleteUserUseCase deleteUser;
  final CreateUserUseCase createUser;

  UserBloc(
      {required this.repository,
      required this.deleteUser,
      required this.createUser,
      required this.fetchUsers,
      required this.updateUser})
      : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<CreateUser>(_onCreateUser);
    on<DeleteUser>(_ondeleteUser);
    on<UpdateUser>(_onupdateuser);
  }

  Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final users = await fetchUsers();
      print('1');
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onCreateUser(CreateUser event, Emitter<UserState> emit) async {
    print('2');
    emit(UserLoading());
    try {
      // await repository.createUser(name: event.name, email: event.email);
      await createUser(
          name: event.name,
          email: event.email,
          password: event.password,
          phone: event.phone);

      // emit(UserLoaded(updatedUsers));
      emit(UserCreated());
      final updatedUsers = await repository.fetchUsers();
      emit(UserLoaded(updatedUsers));
    }
    // catch (e, s) {
    //   print('error:$s');
    //   // emit(UserError(e.toString().replaceFirst('Exception:', '')));
    //   emit(UserError(e.toString()));
    // }
    catch (e, s) {
      print('stacktrace: $s');

      if (e is DioException) {
        // Extract the response message from the server
        final errorMessage =
            e.response?.data['detail'] ?? 'Something went wrong';
        emit(UserError(errorMessage));
      } else {
        emit(UserError(e.toString()));
      }
    }
  }

  Future<int?> _ondeleteUser(DeleteUser event, Emitter<UserState> emit) async {
    try {
      print('in bloc');
      // await repository.deleteUser(event.id);
      await deleteUser(event.id);
      // final users = await repository.fetchUsers();
      final users = await fetchUsers();
      emit(UserDeleted());
      emit(UserLoaded(users));
      // emit(UserDeleted());
    } catch (e) {
      emit(UserError(e.toString()));
    }
    return null;
  }

  Future<void> _onupdateuser(UpdateUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      // await repository.updateUser(event.id, event.name, event.email);
      await updateUser(id: event.id, name: event.name, email: event.email);
      emit(UserUpdated());
      final users = await repository.fetchUsers();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
