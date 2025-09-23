import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstapp/features/user/auth/data/models/user_model.dart';
import '../bloc/forgotemail_event.dart';
import '../bloc/forgotemail_state.dart';
import '../../domain/usecases/forgotpassword_usecase.dart';
import '../../../auth/domain/usecases/validate_otp_usercase.dart';
import '../../../auth/domain/usecases/validate_otp_usercase.dart';
import '../../../auth/domain/usecases/reset_password_usercase.dart';

class ForgotPasswordBloc extends Bloc<PasswordEvent, ForgotPasswordState> {
  final ForgotpasswordUsecase forgotpasswordUsecase;
  final ValidateOtpUsercase validateOtpUsercase;
  final ResetPasswordUsercase resetPasswordUsercase;
  ForgotPasswordBloc(this.forgotpasswordUsecase, this.validateOtpUsercase,
      this.resetPasswordUsercase)
      : super(ForgotPasswordInitial()) {
    on<PasswordRequested>(_onPasswordRequested);
    on<ValidateOtp>(_onvalidateOtp);
    on<ResetPassword>(_onResetPassword);
  }

  Future<void> _onPasswordRequested(
      PasswordRequested event, Emitter<ForgotPasswordState> emit) async {
    print("came into bloc");
    emit(ForgotPasswordLoading());
    try {
      final response = await forgotpasswordUsecase.execute(event.email);
      emit(OTPSent());
      return;
    } on DioException catch (e) {
      String errorMessage;

      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        print('1');
        errorMessage = data['detail'] ?? 'Something went wrong';
      } else if (data is String) {
        print('12');
        errorMessage = data;
      } else {
        errorMessage = 'Something went wrong';
      }

      print('Error message: $errorMessage');
      emit(ForgotPassowrdFailure(errorMessage));
    } catch (e) {
      emit(ForgotPassowrdFailure(e.toString()));
    }
  }

  Future<void> _onvalidateOtp(
      ValidateOtp event, Emitter<ForgotPasswordState> emit) async {
    print("came into verify");
    try {
      final response =
          await validateOtpUsercase.validateOtp(event.email, event.otp);
      emit(OTPVerified());
      return;
    } on DioException catch (e) {
      String errorMessage;

      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        print('1');
        errorMessage = data['detail'] ?? 'Something went wrong';
      } else if (data is String) {
        print('12');
        errorMessage = data;
      } else {
        errorMessage = 'Something went wrong';
      }

      print('Error message: $errorMessage');
      emit(ForgotPassowrdFailure(errorMessage));
    } catch (e) {
      // final errorMessage =
      //     e.response?.data?['detail'] ?? "something went wrong";
      emit(ForgotPassowrdFailure(e.toString()));
    }
  }

  Future<void> _onResetPassword(
      ResetPassword event, Emitter<ForgotPasswordState> emit) async {
    emit(ForgotPasswordLoading());
    try {
      final response = await resetPasswordUsercase.call(ResetPasswordRequest(
          email: event.email,
          phone: event.phone,
          newPassword: event.newPassword,
          confirmPassword: event.confirmPassword));
      emit(ResetPasswordSuccess(response));
    } catch (e) {
      print("error in bloc ${e.toString()}");
      emit(ForgotPassowrdFailure(e.toString()));
    }
  }
}
