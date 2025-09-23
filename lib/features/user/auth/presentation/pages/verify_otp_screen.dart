import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstapp/config/routes/app_routes.dart';
import '../../../auth/presentation/bloc/forgotemail_bloc.dart';
import '../../../auth/presentation/bloc/forgotemail_state.dart';
import '../../../auth/presentation/bloc/forgotemail_event.dart';
import 'package:go_router/go_router.dart';
import '../../../../user/data/models/reset_password_args.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  const VerifyOtpScreen({Key? key, required this.email}) : super(key: key);
  // const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreen();
}

class _VerifyOtpScreen extends State<VerifyOtpScreen> {
  final TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(
          "Verify OTP",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is OTPVerified) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("OTP verified successfully")));
            // context.push("/reset-password", extra: widget.email);
            context.push("/reset-password",
                extra: ResetPasswordArgs(email: widget.email));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: otpController,
                decoration: const InputDecoration(labelText: "Enter OTP"),
                validator: (value) => value!.isEmpty ? "Enter OTP" : null,
              ),
              const SizedBox(height: 20),
              BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                  builder: (context, state) {
                return ElevatedButton(
                    onPressed: () {
                      final otp = otpController.text.trim();
                      if (otp.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Enter OTP")));
                        return;
                      }
                      if (otp.isNotEmpty) {
                        context
                            .read<ForgotPasswordBloc>()
                            .add(ValidateOtp(email: widget.email, otp: otp));
                      }
                    },
                    child: state is ForgotPasswordLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text("Verify OTP"));
              })
            ],
          ),
        ),
      ),
    );
  }
}
