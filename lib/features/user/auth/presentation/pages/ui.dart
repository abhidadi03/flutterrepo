// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../models/user_model.dart';

// class UserChart extends StatelessWidget {
//   final List<UserModel> users;

//   const UserChart({super.key, required this.users});

//   @override
//   Widget build(BuildContext context) {
//     int activeCount = users.where((u) => u.is_active).length;
//     int inactiveCount = users.length - activeCount;

//     return SizedBox(
//       height: 200,
//       child: PieChart(
//         PieChartData(
//           sections: [
//             PieChartSectionData(
//               value: activeCount.toDouble(),
//               color: Colors.green,
//               title: 'Active\n$activeCount',
//               radius: 60,
//               titleStyle: TextStyle(
//                   fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//             PieChartSectionData(
//               value: inactiveCount.toDouble(),
//               color: Colors.red,
//               title: 'Inactive\n$inactiveCount',
//               radius: 60,
//               titleStyle: TextStyle(
//                   fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//           ],
//           sectionsSpace: 2,
//           centerSpaceRadius: 30,
//         ),
//       ),
//     );
//   }
// }

// Future<void> _onVerifyOtp(VerifyOtp event, Emitter<OtpState> emit) async {
//   emit(VerifyOtpLoading());

//   try {
//     User? user = FirebaseAuth.instance.currentUser;

//     if (event.isLinking && user != null) {
//       // Don't sign in again — just link
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: event.verficationId,
//         smsCode: event.otp,
//       );

//       try {
//         await user.linkWithCredential(credential);
//         print("Phone linked successfully: ${user.phoneNumber}");
//       } on FirebaseAuthException catch (e) {
//         if (e.code == 'provider-already-linked') {
//           await user.updatePhoneNumber(credential);
//           print("Phone updated successfully: ${user.phoneNumber}");
//         } else {
//           rethrow;
//         }
//       }

//       await user.reload();
//       user = FirebaseAuth.instance.currentUser;

//       if (user?.phoneNumber != null) {
//         await phoneLinkingUsecase.phoneLink(phone: user!.phoneNumber!);
//         print("Phone linking usecase called with: ${user.phoneNumber}");
//       } else {
//         print("Phone number is still null after linking.");
//       }
//     } else {
//       // If not linking, sign in normally
//       await verifyOtpUsecase.execute(
//         verificationId: event.verficationId,
//         otp: event.otp,
//       );
//       user = FirebaseAuth.instance.currentUser;
//     }

//     if (user != null) {
//       String? idToken = await user.getIdToken();
//       print("Token in bloc: $idToken");
//       final storage = FlutterSecureStorage();
//       await storage.write(key: 'id_token', value: idToken);
//     }

//     emit(OtpVerified());
//   } catch (e) {
//     print("Error during OTP verification: ${e.toString()}");
//     emit(VerifyOtpFailure(e.toString()));
//   }
// }

// Future<void> _onVerifyOtp(VerfiyOtp event, Emitter<OtpState> emit) async {
//   print("what");
//   emit(VerifyOtpLoading());
//   try {
//     await verifyOtpUsecase.execute(
//         verificationId: event.verficationId, otp: event.otp);
//     User? user = FirebaseAuth.instance.currentUser;
//     if (event.isLinking) {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         PhoneAuthCredential credential = PhoneAuthProvider.credential(
//           verificationId: event.verficationId,
//           smsCode: event.otp,
//         );

//         await user.linkWithCredential(credential);
//         await phoneLinkingUsecase.phoneLink(phone: user.phoneNumber!);
//         print("Phone linked successfully: ${user.phoneNumber}");
//       }
//     }
//     if (user != null) {
//       String? idToken = await user.getIdToken();
//       print("tken in bloc:${idToken}");
//       final storage = FlutterSecureStorage();
//       await storage.write(key: 'id_token', value: idToken);
//     }
//     emit(OtpVerified());
//   } catch (e) {
//     print(e.toString());
//     emit(VerifyOtpFailure(e.toString()));
//     // emit(OtpVerficationFailed());
//   }
// }
