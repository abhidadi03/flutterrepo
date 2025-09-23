// import 'package:flutter/material.dart';
import 'package:myfirstapp/features/user/auth/presentation/pages/auth_signup.dart';
import 'package:myfirstapp/features/user/auth/presentation/pages/flutter_auth_ui.dart';
import 'package:myfirstapp/features/user/auth/presentation/pages/login_screen.dart';
import 'package:myfirstapp/features/user/auth/presentation/pages/reset_password_screen.dart';

import '../../features/user/presentation/pages/user_form.dart';
import '../../features/user/presentation/pages/user_listing_page.dart';
import '../../features/user/presentation/pages/view_user_pages.dart';
import '../../main.dart';
import 'package:go_router/go_router.dart';
import '../../features/user/data/models/user_model.dart';
import '../../features/user/auth/presentation/pages/verify_email.dart';
import '../../features/user/auth/presentation/pages/verify_otp_screen.dart';
import '../../features/user/auth/presentation/pages/reset_password_screen.dart';
import '../../features/user/auth/presentation/pages/flutter_auth_ui.dart';
import '../../features/user/auth/presentation/pages/auth_login_screen.dart';
import '../../features/user/data/models/reset_password_args.dart';

final GoRouter approuter =
    GoRouter(initialLocation: '/initial-screen', routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const HomePage(),
  ),
  GoRoute(
    path: '/users-listing',
    builder: (context, state) => const MyUsers(),
  ),
  GoRoute(
    path: '/users',
    builder: (context, state) => const ViewUserPage(),
  ),
  GoRoute(
    path: '/edit-user',
    builder: (context, state) {
      final user = state.extra as UserModel?;
      return UserForm(user: user);
    },
  ),
  GoRoute(
      path: '/add-user',
      builder: (context, state) {
        return const UserForm();
      }),
  GoRoute(
      path: '/forgot-password',
      builder: (context, state) {
        return const ForgotPasswordScreen();
      }),
  GoRoute(
      path: '/verify-otp',
      builder: (context, state) {
        final email = state.extra as String;
        return VerifyOtpScreen(email: email);
      }),
  GoRoute(
    path: '/reset-password',
    builder: (context, state) {
      final args = state.extra as ResetPasswordArgs;
      // final email = state.extra as String? ?? "";
      return ResetPasswordScreen(email: args.email, phone: args.phone);
    },
  ),
  GoRoute(
      path: '/initial-screen',
      builder: (context, state) {
        return MyWidget();
      }),
  GoRoute(
    path: "/login",
    builder: (context, state) {
      return NewLoginScreen();
    },
  ),
  GoRoute(
      path: '/signup',
      builder: (context, state) {
        return AuthSignup();
      })
]);
