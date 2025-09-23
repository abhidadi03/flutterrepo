import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstapp/features/user/auth/data/models/user_model.dart';
import 'package:myfirstapp/features/user/auth/presentation/bloc/auth_event.dart';
import 'package:myfirstapp/features/user/auth/presentation/bloc/auth_state.dart';
import '../../domain/usecases/login_usecase.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc(this.loginUseCase) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LoginWithPhone>(_onLoginWithPhone);
  }
  Future<void> _onLoginWithPhone(
      LoginWithPhone event, Emitter<AuthState> emit) async {
    print('in ');
    try {
      final ValidateUserResponse =
          await loginUseCase.validatePhone(event.phone);
      if (ValidateUserResponse?.value != true) {
        emit(PhoneValidationFailure());
        return;
      }
      emit(AuthPhoneValidated());
    } catch (e, s) {
      print('stacktrace: $s');

      if (e is DioException) {
        final errorMessage =
            e.response?.data['detail'] ?? 'Something went wrong';
        emit(AuthFailed(errorMessage));
      } else {
        emit(AuthFailed(e.toString()));
      }
    }
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final validationResponse = await loginUseCase.validateUser(event.email);
      print("existEmail:$validationResponse");
      if (validationResponse?.value != true) {
        emit(AuthInavliduser());
        return;
      }
      final user = await loginUseCase.execute(event.email, event.password);
      print('in usecase:$user');
      if (user != null) {
        print('in usecase:$user');
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthFailed('Invalid credentials'));
      }
    } catch (e, s) {
      print('stacktrace: $s');

      if (e is DioException) {
        final errorMessage =
            e.response?.data['detail'] ?? 'Something went wrong';
        emit(AuthFailed(errorMessage));
      } else {
        emit(AuthFailed(e.toString()));
      }
    }
    // on DioException catch (e) {
    //   print("error in the bloc:$e");
    //   if (e.response?.statusCode == 404) {
    //     emit(AuthInavliduser());
    //   }
    //   emit(AuthFailed(e.toString()));
    // }
  }
}
