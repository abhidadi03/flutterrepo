import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstapp/features/user/phone_validation/data/sources/sendotp_firebase.dart';
import 'package:myfirstapp/features/user/phone_validation/domain/usecases/resend_otp_usecase.dart';
import 'phone_validation_event.dart';
import 'phone_validation_state.dart';
import '../../../phone_validation/data/repository/otp_repository_impl.dart';
import '../../../phone_validation/domain/usecases/send_otp_usecase.dart';
import '../../../phone_validation/domain/repository/otp_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../../phone_validation/domain/entities/otp_result.dart';
import '../../domain/usecases/resend_otp_usecase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/usecases/phone_linking_usecase.dart';

class OtpBloc extends Bloc<PhoneValidationEvent, OtpState> {
  final OtpRepository repository;
  final SendOtpUsecase sendOtp;
  final FirebaseOtpService firebaseOtpService;
  final VerifyOtpUsecase verifyOtpUsecase;
  final ResendOtpUsecase resendOtpUsecase;
  final PhoneLinkingUsecase phoneLinkingUsecase;
  String? _verificationId;
  OtpBloc({
    required this.repository,
    required this.sendOtp,
    required this.firebaseOtpService,
    required this.verifyOtpUsecase,
    required this.resendOtpUsecase,
    required this.phoneLinkingUsecase,
  }) : super(OtpInitial()) {
    on<SendOtp>(_onSendOtp);
    on<VerifyOtp>(_onVerifyOtp);
    on<ResendOtp>(_onResendOtp);
    on<OtpCodeSent>(_onOtpCodeSent);
  }
  Future<void> _onSendOtp(SendOtp event, Emitter<OtpState> emit) async {
    emit(OtpLoading());
    try {
      final user = await sendOtp.sendOtp(event.phone);
      if (!user && !event.isLinking) {
        emit(UserNotFound());
        return;
      }
      if (user && event.isLinking) {
        emit(UserExists());
        return;
      }
      await firebaseOtpService.sendOtp(
        event.phone,
        verificationCompleted: (credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          emit(OtpVerified());
        },
        verificationFailed: (e) {
          emit(OtpVerificationFailed(e.message ?? "Firebase error"));
        },
        codeSent: (verificationId, resendToken) {
          add(OtpCodeSent(verificationId, resendToken));
        },
      );
    } catch (e) {
      emit(OtpSentStateFailed(e.toString()));
    }
  }

  Future<void> _onOtpCodeSent(OtpCodeSent event, Emitter<OtpState> emit) async {
    emit(OtpSentSuccess(
      verificationId: event.verificationId,
      resendToken: event.resendToken,
    ));
  }

  Future<void> _onVerifyOtp(VerifyOtp event, Emitter<OtpState> emit) async {
    emit(VerifyOtpLoading());

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (event.isLinking && user != null) {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: event.verficationId,
          smsCode: event.otp,
        );

        try {
          await user.linkWithCredential(credential);
          emit(FireBasePhoneUpdated());
          print("Phone linked successfully: ${user.phoneNumber}");
        } on FirebaseAuthException catch (e) {
          if (e.code == 'provider-already-linked') {
            // await user.updatePhoneNumber(credential);
            print("Phone updated successfully: ${user.phoneNumber}");
          } else {
            rethrow;
          }
        }

        await user.reload();
        user = FirebaseAuth.instance.currentUser;

        if (user?.phoneNumber != null) {
          await phoneLinkingUsecase.phoneLink(phone: user!.phoneNumber!);
          print("Phone linking usecase called with: ${user.phoneNumber}");
        } else {
          print("Phone number is still null after linking.");
        }
      } else {
        await verifyOtpUsecase.execute(
          verificationId: event.verficationId,
          otp: event.otp,
        );
        user = FirebaseAuth.instance.currentUser;
      }
      if (user != null) {
        String? idToken = await user.getIdToken();
        print("Token in bloc: $idToken");
        final storage = const FlutterSecureStorage();
        await storage.write(key: 'id_token', value: idToken);
      }

      emit(OtpVerified());
    } catch (e) {
      print("Error during OTP verification: ${e.toString()}");
      emit(VerifyOtpFailure(e.toString()));
    }
  }

  Future<void> _onResendOtp(ResendOtp event, Emitter<OtpState> emit) async {
    emit(ResendOtpLoading());
    try {
      final OtpResult result = await resendOtpUsecase.resendOtp(
          phone: event.phone, resendToken: event.resendToken);
      emit(ResendOtpSuccess(
          verificationId: result.verificationId,
          resendToken: result.resendToken));
    } catch (e) {
      emit(VerifyOtpFailure(e.toString()));
    }
  }
}
