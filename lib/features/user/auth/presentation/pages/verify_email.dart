import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstapp/common/widgets/common_button.dart';
import 'package:myfirstapp/features/user/auth/presentation/bloc/forgotemail_state.dart';
import 'package:myfirstapp/features/user/presentation/pages/user_form.dart';
import '../bloc/forgotemail_event.dart';
import '../bloc/forgotemail_state.dart';
import '../bloc/forgotemail_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/common_phone_field.dart';
import '.././../../../../features/user/data/models/reset_password_args.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool loginWithPhone = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: const Material(
          type: MaterialType.transparency,
          child: Text(
            "Forgot password",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is OTPSent) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("OTP sent successfully")));
            context.push('/verify-otp', extra: emailController.text);
          } else if (state is ForgotPassowrdFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.detail)));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!loginWithPhone) ...[
                TextFormField(
                  controller: emailController,
                  decoration:
                      const InputDecoration(labelText: "Enter your email"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter your email" : null,
                ),
                const SizedBox(height: 26),
                BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        final email = emailController.text.trim();
                        print("email---$email");
                        if (email.isNotEmpty) {
                          context
                              .read<ForgotPasswordBloc>()
                              .add(PasswordRequested(email));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please enter your email")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                      child: state is ForgotPasswordLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.blueAccent,
                              ),
                            )
                          : const Text("Send OTP"),
                    );
                  },
                ),
              ] else ...[
                // CommonPhoneField(onVerified: (phone) {
                //   print("verified");
                // }, navigation: (context, phone) {
                //   context.go('/reset-password',
                //       extra: ResetPasswordArgs(phone: phone));
                // }),
              ],
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        loginWithPhone = !loginWithPhone;
                      });
                    },
                    child: loginWithPhone
                        ? const Text(
                            "verify with email",
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          )
                        : const Text(
                            "verify with phone",
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
