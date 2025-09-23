import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstapp/features/user/send_otp/data/sources/sendotp_firebase.dart';
import 'phone_validation_event.dart';
import 'phone_validation_state.dart';
import '../../../send_otp/data/repository/otp_repository_impl.dart';
import '../../../send_otp/domain/usecases/send_otp_usecase.dart';
import '../../../send_otp/domain/repository/otp_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../../domain/usecases/verify_otp_usecase.dart';

class OtpBloc extends Bloc<PhoneValidationEvent, OtpState> {
  final OtpRepository repository;
  final SendOtpUsecase sendOtp;
  final FirebaseOtpService firebaseOtpService;
  final VerifyOtpUsecase verifyOtpUsecase;
  String? _verificationId;
  OtpBloc(
      {required this.repository,
      required this.sendOtp,
      required this.firebaseOtpService,
      required this.verifyOtpUsecase})
      : super(OtpInitial()) {
    on<SendOtp>(_onSendOtp);
    on<VerfiyOtp>(_onVerifyOtp);
  }
  Future<void> _onSendOtp(SendOtp event, Emitter<OtpState> emit) async {
    emit(OtpLoading());
    try {
      final user = await sendOtp.sendOtp(event.phone);
      if (!user) {
        emit(UserNotFound());
        return;
      }
      final completer = Completer<String>();

      await firebaseOtpService.sendOtp(
        event.phone,
        verificationCompleted: (credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          emit(OtpVerified());
        },
        verificationFailed: (e) {
          emit(OtpVerificationFailed(e.message ?? "Firebase error"));
        },
        codeSent: (verificationId) {
          completer.complete(verificationId);
          emit(OtpSentSuccess());
        },
      );
      final verificationId = await completer.future;
      print("verifcation12345!:${verificationId}");
      emit(OtpSent(verificationId));
    } catch (e) {
      emit(OtpSentStateFailed(e.toString()));
    }
  }

  Future<void> _onVerifyOtp(VerfiyOtp event, Emitter<OtpState> emit) async {
    print("what");
    emit(VerifyOtpLoading());
    try {
      await verifyOtpUsecase.execute(
          verificationId: event.verficationId, otp: event.otp);
      emit(OtpVerified());
    } catch (e) {
      emit(VerifyOtpFailure(e.toString()));
      // emit(OtpVerficationFailed());
    }
  }
}
