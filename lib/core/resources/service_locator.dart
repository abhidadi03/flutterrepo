import 'package:dio/dio.dart';
import 'package:myfirstapp/core/resources/dio_client.dart';
import 'package:myfirstapp/features/user/auth/data/sources/firebase_auth.dart';
import 'package:myfirstapp/features/user/auth/domain/usecases/reset_password_usercase.dart';
import 'package:myfirstapp/features/user/data/repository/user_repository_impl.dart';
import 'package:myfirstapp/features/user/data/sources/user_api.dart';
import 'package:myfirstapp/features/user/domain/usecases/create_user.dart';
import 'package:myfirstapp/features/user/domain/usecases/delete_user.dart';
import 'package:myfirstapp/features/user/domain/usecases/edit_user.dart';
import 'package:myfirstapp/features/user/domain/usecases/fetch_users.dart';
import 'package:myfirstapp/features/user/send_otp/data/sources/otp_api.dart';
import 'package:myfirstapp/features/user/send_otp/domain/usecases/send_otp_usecase.dart';
import 'package:myfirstapp/features/user/send_otp/domain/usecases/verify_otp_usecase.dart';
import 'package:myfirstapp/features/user/send_otp/presentation/bloc/phone_validation_bloc.dart';
import 'package:myfirstapp/features/user/send_otp/presentation/bloc/phone_validation_event.dart';

import '../../features/user/domain/repository/user_repository.dart';
import '../../features/user/presentation/bloc/user_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../features/user/auth/domain/repository/auth_repository.dart';
import '../../features/user/auth/data/repository/auth_repository_impl.dart';
import '../../features/user/auth/presentation/bloc/auth_bloc.dart';
import '../../features/user/auth/domain/usecases/login_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/user/auth/presentation/bloc/forgotemail_bloc.dart';
import '../../features/user/auth/domain/usecases/forgotpassword_usecase.dart';
import '../../features/user/auth/domain/repository/ForgotPassword_repository.dart';
import '../../features/user/auth/data/repository/forgotpassword_repository_impl.dart';
import '../../features/user/auth/domain/usecases/validate_otp_usercase.dart';
import '../../features/user/auth/domain/usecases/reset_password_usercase.dart';
import '../../features/user/send_otp/data/repository/otp_repository_impl.dart';
import '../../features/user/send_otp/domain/repository/otp_repository.dart';
import '../../features/user/send_otp/presentation/bloc/phone_validation_event.dart';
// import '../../features/user/send_otp.dart/data/sources/sendotp_firebase.dart';
import '../../features/user/send_otp/data/sources/sendotp_firebase.dart';

final getIt = GetIt.instance;
void setupLocator() {
  getIt.registerLazySingleton<Dio>(() => DioClient.createDio());
  getIt.registerLazySingleton<AuthApi>(() => AuthApi(getIt<Dio>()));
  // getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(userApi: getIt<UserApi>()),
  );
  getIt.registerLazySingleton<UserApi>(() => UserApi(getIt<Dio>()));

  getIt.registerLazySingleton<ForgotpasswordRepository>(
      () => ForgotpasswordRepositoryImpl(getIt<UserApi>()));

  getIt.registerLazySingleton<ForgotpasswordUsecase>(
      () => ForgotpasswordUsecase(getIt<ForgotpasswordRepository>()));
  getIt.registerLazySingleton<ValidateOtpUsercase>(
      () => ValidateOtpUsercase(getIt<ForgotpasswordRepository>()));

  getIt.registerLazySingleton<ResetPasswordUsercase>(
    () => ResetPasswordUsercase(getIt<ForgotpasswordRepository>()),
  );

  getIt.registerFactory<ForgotPasswordBloc>(
    () => ForgotPasswordBloc(getIt<ForgotpasswordUsecase>(),
        getIt<ValidateOtpUsercase>(), getIt<ResetPasswordUsercase>()),
  );

  // getIt.registerFactory<ForgotPasswordBloc>(
  //     () => ForgotPasswordBloc(getIt<ForgotpasswordUsecase>()));
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(FirebaseAuth.instance, getIt<AuthApi>()));
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerFactory(() => AuthBloc(getIt<LoginUseCase>()));
  // getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRepository>()));
  // getIt.registerLazySingleton<AuthBloc>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton(() => FetchUsersUseCase(getIt<UserRepository>()));
  getIt.registerLazySingleton(() => UpdateUserUseCase(getIt<UserRepository>()));
  getIt.registerLazySingleton(() => DeleteUserUseCase(getIt<UserRepository>()));
  getIt.registerLazySingleton(() => CreateUserUseCase(getIt<UserRepository>()));

  getIt.registerFactory(() => UserBloc(
        repository: getIt<UserRepository>(),
        fetchUsers: getIt<FetchUsersUseCase>(),
        createUser: getIt<CreateUserUseCase>(),
        updateUser: getIt<UpdateUserUseCase>(),
        deleteUser: getIt<DeleteUserUseCase>(),
      ));
  // getIt.registerLazySingleton<OtpApi>(() => OtpApi());
  getIt.registerLazySingleton<OtpApi>(() => OtpApi(getIt<Dio>()));
  // getIt.registerLazySingleton<FirebaseOtpService>(() => FirebaseOtpService());

  getIt.registerLazySingleton<OtpRepository>(() => OtpRepositoryImpl(
      otpApi: getIt<OtpApi>(),
      firebaseOtpService: getIt<FirebaseOtpService>()));

  getIt.registerLazySingleton<SendOtpUsecase>(
    () => SendOtpUsecase(getIt<OtpRepository>()),
  );
  getIt.registerLazySingleton<VerifyOtpUsecase>(
    () => VerifyOtpUsecase(getIt<OtpRepository>()),
  );

  getIt.registerFactory(() => OtpBloc(
      repository: getIt<OtpRepository>(),
      sendOtp: getIt<SendOtpUsecase>(),
      firebaseOtpService: FirebaseOtpService(),
      verifyOtpUsecase: getIt<VerifyOtpUsecase>()));
  getIt.registerLazySingleton<FirebaseOtpService>(() => FirebaseOtpService());

  // final firebaseOtpService = getIt<FirebaseOtpService>();

  // getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRepository>()));
  // getIt.registerFactory<UserBloc>(() => UserBloc(getIt<UserRepository>()));
}
