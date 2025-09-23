import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myfirstapp/config/routes/app_routes.dart';
import 'package:myfirstapp/features/user/domain/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstapp/features/user/send_otp/presentation/bloc/phone_validation_bloc.dart';
import 'package:myfirstapp/features/user/presentation/bloc/user_bloc.dart';
import 'package:provider/provider.dart';
import 'core/resources/service_locator.dart';
import 'package:myfirstapp/features/user/auth/presentation/pages/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myfirstapp/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:myfirstapp/features/user/auth/presentation/bloc/forgotemail_bloc.dart';
// final getIt = GetIt.instance;
// void setupLocator() {
//   getIt.registerLazySingleton<UserRepository>(() => UserRepository());
//   getIt.registerFactory<UserBloc>(() => UserBloc(getIt<UserRepository>()));
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp((MultiProvider(
    providers: [
      Provider<UserRepository>(create: (_) => getIt<UserRepository>()),
      BlocProvider<UserBloc>(create: (_) => getIt<UserBloc>()),
      BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>()),
      BlocProvider(create: (_) => getIt<ForgotPasswordBloc>()),
      BlocProvider<OtpBloc>(create: (_) => getIt<OtpBloc>()),
    ],
    child: const MyApp(),
  )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      // home: HomePage(),
      routerConfig: approuter,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  // void initState() {
  //   super.initState();
  //   context.read<UserBloc>().add(FetchUsers());
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const MyLoginScreen(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () async {
            context.push('/add-user');
          }),
    );
  }
}
