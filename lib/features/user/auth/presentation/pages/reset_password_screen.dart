import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstapp/features/user/auth/presentation/bloc/forgotemail_bloc.dart';
import 'package:myfirstapp/features/user/auth/presentation/bloc/forgotemail_state.dart';
import 'package:myfirstapp/features/user/auth/presentation/pages/verify_email.dart';
import 'package:myfirstapp/main.dart';
import '../bloc/forgotemail_event.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? email;
  final String? phone;
  const ResetPasswordScreen({Key? key, this.email, this.phone})
      : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreen();
}

class _ResetPasswordScreen extends State<ResetPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isButtonEnabled = false;
  bool showNewpassword = true;
  bool showConfirmPassword = true;
  void initState() {
    super.initState();
    newPasswordController.addListener(_updateButtonState);
    confirmPasswordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled = newPasswordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty;
    });
  }

  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Reset Password",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
            context.go('/login');
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: newPasswordController,
                obscureText: showNewpassword,
                decoration: InputDecoration(
                    labelText: "Enter New Password",
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showNewpassword = !showNewpassword;
                          });
                        },
                        icon: Icon(showNewpassword
                            ? Icons.visibility_off
                            : Icons.visibility))),
                validator: (value) =>
                    value!.isEmpty ? "Enter New Password" : null,
              ),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: showConfirmPassword,
                decoration: InputDecoration(
                    labelText: "Enter Confirm Password",
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showConfirmPassword = !showConfirmPassword;
                          });
                        },
                        icon: Icon(showConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility))),
                validator: (value) =>
                    value!.isEmpty ? "Enter Confirm Password" : null,
              ),
              const SizedBox(height: 20),
              BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                  builder: (context, state) {
                return ElevatedButton(
                    onPressed: isButtonEnabled
                        ? () {
                            final newpassword =
                                newPasswordController.text.trim();
                            final confirmPassword =
                                confirmPasswordController.text.trim();
                            if (newpassword != confirmPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Confirm Password should match with the New Password")));
                              return;
                            }
                            if (newpassword.isNotEmpty &&
                                confirmPassword.isNotEmpty) {
                              context.read<ForgotPasswordBloc>().add(
                                  ResetPassword(
                                      email: widget.email,
                                      phone: widget.phone,
                                      newPassword: newpassword,
                                      confirmPassword: confirmPassword));
                            }
                          }
                        : null,
                    child: state is ForgotPasswordLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.blueAccent,
                            ),
                          )
                        : const Text("Reset Password"));
              })
            ],
          ),
        ),
      ),
    );
  }
}
