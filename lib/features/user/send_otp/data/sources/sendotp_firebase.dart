import 'package:firebase_auth/firebase_auth.dart';

class FirebaseOtpService {
  Future<void> sendOtp(
    String phone, {
    required Function(String verificationId) codeSent,
    required Function(FirebaseAuthException e) verificationFailed,
    required Function(PhoneAuthCredential credential) verificationCompleted,
  }) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: (verificationId, resendToken) {
        print("abc123456");
        print('verificationID:${verificationId}');
        codeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
    print('cm,,');
  }

  Future<void> verifyOtp(String verificationId, String otp) async {
    print("in verifying");
    final credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);
    await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
