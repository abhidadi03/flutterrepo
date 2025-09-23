// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class CommonPhoneAuthWidget extends StatefulWidget {
//   final Function(String phone) onVerified;
//   final Color backgroundColor;
//   final Color textColor;

//   const CommonPhoneAuthWidget({
//     Key? key,
//     required this.onVerified,
//     this.backgroundColor = Colors.purple,
//     this.textColor = Colors.white,
//   }) : super(key: key);

//   @override
//   State<CommonPhoneAuthWidget> createState() => _CommonPhoneAuthWidgetState();
// }

// class _CommonPhoneAuthWidgetState extends State<CommonPhoneAuthWidget> {
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _otpController = TextEditingController();

//   String? _verificationId;
//   bool _otpSent = false;
//   bool _isLoading = false;

//   Future<void> _sendOtp() async {
//     setState(() => _isLoading = true);
//     await FirebaseAuth.instance.verifyPhoneNumber(
//       phoneNumber: _phoneController.text.trim(),
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await FirebaseAuth.instance.signInWithCredential(credential);
//         widget.onVerified(_phoneController.text.trim());
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error: ${e.message}")),
//         );
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         setState(() {
//           _verificationId = verificationId;
//           _otpSent = true;
//           _isLoading = false;
//         });
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         _verificationId = verificationId;
//       },
//     );
//   }

//   Future<void> _verifyOtp() async {
//     if (_verificationId == null) return;
//     setState(() => _isLoading = true);

//     try {
//       final credential = PhoneAuthProvider.credential(
//         verificationId: _verificationId!,
//         smsCode: _otpController.text.trim(),
//       );

//       await FirebaseAuth.instance.signInWithCredential(credential);
//       widget.onVerified(_phoneController.text.trim());
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Invalid OTP")),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Phone Input
//         TextFormField(
//           controller: _phoneController,
//           keyboardType: TextInputType.phone,
//           decoration: InputDecoration(
//             prefixIcon: const Icon(Icons.phone),
//             hintText: "Phone Number",
//             filled: true,
//             fillColor: Colors.purple.shade50,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(30),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),

//         // OTP Input (only after sending OTP)
//         if (_otpSent)
//           TextFormField(
//             controller: _otpController,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//               prefixIcon: const Icon(Icons.lock),
//               hintText: "Enter OTP",
//               filled: true,
//               fillColor: Colors.purple.shade50,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(30),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//           ),
//         if (_otpSent) const SizedBox(height: 20),

//         // Button
//         SizedBox(
//           width: 350,
//           height: 50,
//           child: ElevatedButton(
//             onPressed: _isLoading
//                 ? null
//                 : _otpSent
//                     ? _verifyOtp
//                     : _sendOtp,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: widget.backgroundColor,
//               foregroundColor: widget.textColor,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             ),
//             child: _isLoading
//                 ? const CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: Colors.white,
//                   )
//                 : Text(
//                     _otpSent ? "Verify OTP" : "Send OTP",
//                     style: const TextStyle(
//                         fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//           ),
//         ),
//       ],
//     );
//   }
// }
