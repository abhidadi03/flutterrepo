import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:myfirstapp/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstapp/features/user/auth/presentation/bloc/auth_state.dart';
import 'package:myfirstapp/features/user/send_otp/presentation/bloc/phone_validation_bloc.dart';
import 'package:myfirstapp/features/user/send_otp/presentation/bloc/phone_validation_state.dart';
import '../../features/user/auth/presentation/bloc/auth_event.dart';
import '../../features/user/send_otp/data/sources/sendotp_firebase.dart';

class CommonPhoneField extends StatefulWidget {
  final Function(String phone) onSendOtp;
  final Function(String phone, String otp) onVerifyOtp;

  const CommonPhoneField({
    Key? key,
    required this.onSendOtp,
    required this.onVerifyOtp,
  }) : super(key: key);

  @override
  State<CommonPhoneField> createState() => _CommonPhoneField();
}

class _CommonPhoneField extends State<CommonPhoneField> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _otpSent = false;
  bool _isLoading = false;
  String? _verificationId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocListener<OtpBloc, OtpState>(
            listener: (context, state) async {
              if (state is OtpSent) {
                setState(() {
                  _otpSent = true;
                });
              } else if (state is UserNotFound) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User not found")));
              } else if (state is OtpVerified) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Login Success")));
                context.push('/users');
              } else if (state is VerifyOtpFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
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
                            print("button pressed");
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
                }),
              ),
            ]))
      ],
    );
  }
}
