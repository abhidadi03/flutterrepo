import 'package:myfirstapp/features/user/send_otp/domain/repository/otp_repository.dart';

import '../sources/otp_api.dart';
import '../sources/sendotp_firebase.dart';

class OtpRepositoryImpl implements OtpRepository {
  final OtpApi otpApi;
  final FirebaseOtpService firebaseOtpService;
  OtpRepositoryImpl({required this.otpApi, required this.firebaseOtpService});

  @override
  Future<bool> sendOtp(String phone) async {
    final response = await otpApi.validateUser({'phone_no': phone});
    return response.value;
  }

  Future<void> verifyOtp(
      {required String verificationId, required String otp}) {
    return firebaseOtpService.verifyOtp(verificationId, otp);
  }
}
