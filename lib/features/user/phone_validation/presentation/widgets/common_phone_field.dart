import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:myfirstapp/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstapp/features/user/auth/presentation/bloc/auth_state.dart';
import 'package:myfirstapp/features/user/phone_validation/presentation/bloc/phone_validation_bloc.dart';
import 'package:myfirstapp/features/user/phone_validation/presentation/bloc/phone_validation_state.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../data/sources/sendotp_firebase.dart';

class CommonPhoneField extends StatefulWidget {
  final Function(String phone) onSendOtp;
  final Function(String phone, String otp) onVerifyOtp;
  final Function(String phone, int? resendToken)? onResendOtp;
  final void Function(String)? onVerfiedOtp;
  const CommonPhoneField(
      {Key? key,
      required this.onSendOtp,
      required this.onVerifyOtp,
      this.onResendOtp,
      this.onVerfiedOtp})
      : super(key: key);

  @override
  State<CommonPhoneField> createState() => _CommonPhoneField();
}

class _CommonPhoneField extends State<CommonPhoneField> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _otpSent = false;
  bool _isLoading = false;
  String? _verificationId;
  int? _resendToken;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocListener<OtpBloc, OtpState>(
            listener: (context, state) async {
              if (state is OtpSentSuccess) {
                print("came");
                setState(() {
                  _otpSent = true;
                  _verificationId = state.verificationId;
                  _resendToken = state.resendToken;
                });
              } else if (state is UserNotFound) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User not found")));
              } else if (state is UserExists) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Phone already exists")));
              } else if (state is OtpVerified) {
                // ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(content: Text("Login Success")));
                // context.push('/users');
                widget.onVerfiedOtp!.call(_phoneController.text.trim());
              } else if (state is VerifyOtpFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is ResendOtpSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("OTP send successfully")));
              } else if (state is FireBasePhoneUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Phone updated successfully")));
              }
            },
            child: Column(children: [
              SizedBox(
                width: 350,
                height: 50,
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone),
                    hintText: "Phone Number",
                    filled: true,
                    fillColor: Colors.purple.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (_otpSent)
                SizedBox(
                  width: 350,
                  height: 50,
                  child: TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      hintText: "Enter OTP",
                      filled: true,
                      fillColor: Colors.purple.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              SizedBox(
                width: 350,
                height: 50,
                child:
                    BlocBuilder<OtpBloc, OtpState>(builder: (context, state) {
                  final isLoading =
                      state is OtpLoading || state is VerifyOtpLoading;
                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_otpSent) {
                              if (_otpController.text.trim().length != 6) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "OTP should contain 6 digits")));
                                return;
                              }
                              widget.onVerifyOtp(
                                _phoneController.text.trim(),
                                _otpController.text.trim(),
                              );
                            } else {
                              if (_phoneController.text.trim().length != 13) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Phone should contain 10 digits")));
                                return;
                              }
                              widget.onSendOtp(_phoneController.text.trim());
                              // setState(() => _otpSent = true);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.purple,
                          )
                        : Text(
                            _otpSent ? "Verify OTP" : "Send OTP",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                  // const SizedBox(height: 10),
                }),
              ),
            ])),
        const SizedBox(height: 10),
        if (_otpSent) ...[
          GestureDetector(
            onTap: () {
              if (widget.onResendOtp != null) {
                widget.onResendOtp!(
                    _phoneController.text.trim(), _resendToken!);
              }
            },
            child: const Text(
              "Resend OTP",
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          )
        ],
      ],
    );
  }
}
