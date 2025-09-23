





// aaaa















// class CommonPhoneField extends StatefulWidget {
//   final Function(String phone) onSendOtp;
//   final Function(String phone, String otp) onVerifyOtp;

//   const CommonPhoneField({
//     Key? key,
//     required this.onSendOtp,
//     required this.onVerifyOtp,
//   }) : super(key: key);

//   @override
//   State<CommonPhoneField> createState() => _CommonPhoneField();
// }

// class _CommonPhoneField extends State<CommonPhoneField> {
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _otpController = TextEditingController();

//   bool _otpSent = false;

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<OtpBloc, OtpState>(
//       listener: (context, state) {
//         if (state is OtpSentState) {
//           setState(() => _otpSent = true);
//         } else if (state is OtpVerifiedState) {
//           // OTP verified successfully
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("OTP Verified Successfully!")),
//           );
//         } else if (state is OtpErrorState) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.message)),
//           );
//         }
//       },
//       builder: (context, state) {
//         final isLoading = state is OtpLoadingState;

//         return Column(
//           children: [
//             TextFormField(
//               controller: _phoneController,
//               keyboardType: TextInputType.phone,
//               decoration: InputDecoration(
//                 prefixIcon: const Icon(Icons.phone),
//                 hintText: "Phone Number",
//                 filled: true,
//                 fillColor: Colors.purple.shade50,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             if (_otpSent)
//               TextFormField(
//                 controller: _otpController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   prefixIcon: const Icon(Icons.lock),
//                   hintText: "Enter OTP",
//                   filled: true,
//                   fillColor: Colors.purple.shade50,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//             SizedBox(
//               width: 350,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: isLoading
//                     ? null
//                     : () {
//                         if (_otpSent) {
//                           widget.onVerifyOtp(
//                             _phoneController.text.trim(),
//                             _otpController.text.trim(),
//                           );
//                         } else {
//                           widget.onSendOtp(_phoneController.text.trim());
//                         }
//                       },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.purple,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: isLoading
//                     ? const CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: Colors.white,
//                       )
//                     : Text(
//                         _otpSent ? "Verify OTP" : "Send OTP",
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }






// class OtpBloc extends Bloc<PhoneValidationEvent, OtpState> {
//   final OtpRepository repository;
//   final SendOtpUsecase sendOtp;
//   final FirebaseOtpService firebaseService;

//   String? _verificationId;

//   OtpBloc({
//     required this.repository,
//     required this.sendOtp,
//     required this.firebaseService,
//   }) : super(OtpInitial()) {
//     on<SendOtp>(_onSendOtp);
//     on<VerifyOtp>(_onVerifyOtp);
//   }

//   Future<void> _onSendOtp(SendOtp event, Emitter<OtpState> emit) async {
//     emit(OtpLoading());
//     try {
//       final userExists = await sendOtp.sendOtp(event.phone);
//       if (userExists) {
//         await firebaseService.sendOtp(
//           event.phone,
//           verificationCompleted: (credential) async {
//             await FirebaseAuth.instance.signInWithCredential(credential);
//             emit(OtpVerified());
//           },
//           verificationFailed: (e) {
//             emit(OtpFailure("Firebase error: ${e.message}"));
//           },
//           codeSent: (verificationId) {
//             _verificationId = verificationId;
//             emit(OtpSent());
//           },
//         );
//       } else {
//         emit(UserNotFound());
//       }
//     } catch (e) {
//       emit(OtpFailure(e.toString()));
//     }
//   }

//   Future<void> _onVerifyOtp(VerifyOtp event, Emitter<OtpState> emit) async {
//     if (_verificationId == null) {
//       emit(OtpFailure("No verificationId found"));
//       return;
//     }

//     try {
//       await firebaseService.verifyOtp(_verificationId!, event.otp);
//       emit(OtpVerified());
//     } catch (e) {
//       emit(OtpFailure("OTP verification failed: $e"));
//     }
//   }
// }

