import 'package:myfirstapp/features/user/phone_validation/domain/repository/otp_repository.dart';

import '../sources/otp_api.dart';
import '../sources/sendotp_firebase.dart';
import 'dart:async';
import '../../../phone_validation/domain/entities/otp_result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OtpRepositoryImpl implements OtpRepository {
  final OtpApi otpApi;
  final FirebaseOtpService firebaseOtpService;
  OtpRepositoryImpl({required this.otpApi, required this.firebaseOtpService});

  @override
  Future<bool> sendOtp(String phone) async {
    final response = await otpApi.validateUser({'phone_no': phone});
    return response.value;
  }

  @override
  Future<void> verifyOtp(
      {required String verificationId, required String otp}) {
    return firebaseOtpService.verifyOtp(verificationId, otp);
  }

  @override
  Future<String> phoneLink({required String phone}) async {
    final token = await const FlutterSecureStorage().read(key: 'id_token');
    return otpApi.phoneLink({'phone': phone}, "Bearer $token");
  }

  @override
  Future<OtpResult> resendOtp({required String phone, int? resendToken}) async {
    final completer = Completer<OtpResult>();

    await firebaseOtpService.resendOtp(
      phone,
      resendToken: resendToken,
      verificationCompleted: (credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        completer.completeError(e);
      },
      codeSent: (verificationId, newResendToken) {
        final result = OtpResult(
          verificationId: verificationId,
          resendToken: newResendToken,
        );
        completer.complete(result);
      },
    );

    return completer.future;
  }
}
