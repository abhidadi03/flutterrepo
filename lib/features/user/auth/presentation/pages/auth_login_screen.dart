import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myfirstapp/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:myfirstapp/features/user/auth/presentation/bloc/auth_event.dart';
import 'package:myfirstapp/features/user/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/widgets/common_button.dart';
import '../../../../../common/widgets/common_phone_field.dart';
import '../../../send_otp/presentation/bloc/phone_validation_state.dart';
import '../../../send_otp/presentation/bloc/phone_validation_bloc.dart';
import '../../../send_otp/presentation/bloc/phone_validation_event.dart';
import '../../../verify_otp/presentation/bloc/verify_otp_bloc.dart';
// import '../../../verify_otp/presentation/bloc/verify_otp_event.dart';
import '../../../verify_otp/presentation/bloc/verify_otp_state.dart';

class NewLoginScreen extends StatefulWidget {
  const NewLoginScreen({super.key});

  @override
  State<NewLoginScreen> createState() => _NewLoginScreen();
}

class _NewLoginScreen extends State<NewLoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool showPassword = true;
  bool loginWithPhone = true;
  String? _verificationId;
  @override
  void _submitForm() {
    print("came");
    if (_formkey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      print('login email:$email');
      print('password:$password');
      context.read<AuthBloc>().add(LoginRequested(email, password));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Login Sucess")));
                context.go('/users');
              } else if (state is AuthFailed) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is AuthInavliduser) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User not found")));
              }
            },
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "LOGIN ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Image.asset("assets/images/login_image.png"),
                  const SizedBox(height: 30),
                  if (!loginWithPhone) ...[
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: _emailController,
                        validator: (value) =>
                            value!.isEmpty ? "Enter your email" : null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          hintText: "Email",
                          filled: true,
                          fillColor: Colors.purple.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    // ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: _passwordController,
                        validator: (value) =>
                            value!.isEmpty ? "Enter password" : null,
                        obscureText: showPassword,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            hintText: "Password",
                            filled: true,
                            fillColor: Colors.purple.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                                icon: Icon(showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility))),
                      ),
                    ),
                    const SizedBox(height: 35),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                          return CommonButton(
                            text: "LOGIN",
                            onPressed: _submitForm,
                            isLoading: state is AuthLoading ? true : false,
                          );
                        })
                      ],
                    ),
                  ] else ...[
                    CommonPhoneField(
                      onSendOtp: (phone) {
                        print('into print:$phone');
                        context.read<OtpBloc>().add(SendOtp(phone: phone));
                      },
                      onVerifyOtp: (phone, otp) {
                        final state = context.read<OtpBloc>().state;
                        print("stateeeee:$state");
                        if (state is OtpSent) {
                          _verificationId = state.VerficationId;
                        }
                        print("verificationCode:$_verificationId");
                        context.read<OtpBloc>().add(VerfiyOtp(
                            verficationId: _verificationId!, otp: otp));
                      },
                    ),
                  ],
                  const SizedBox(height: 25),
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
                                "Login with email and passowrd",
                                style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                              )
                            : const Text(
                                "Login with phone",
                                style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                              ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      GestureDetector(
                          onTap: () {
                            context.push('/forgot-password');
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          )),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          print("register");
                          context.go('/signup');
                          // context.go('/initial-screen');
                        },
                        child: const Text(
                          "Signup",
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
