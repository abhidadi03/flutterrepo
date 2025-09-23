import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myfirstapp/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:myfirstapp/features/user/auth/presentation/bloc/auth_event.dart';
import 'package:myfirstapp/features/user/auth/presentation/bloc/auth_state.dart';
import 'package:myfirstapp/features/user/presentation/bloc/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstapp/features/user/presentation/pages/view_user_pages.dart';
import 'package:myfirstapp/main.dart';
import 'package:go_router/go_router.dart';
import './flutter_auth_ui.dart';

class MyLoginScreen extends StatefulWidget {
  const MyLoginScreen({super.key});

  @override
  State<MyLoginScreen> createState() => _MyLoginScreen();
}

class _MyLoginScreen extends State<MyLoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool showPassword = true;
  @override
  void _submitForm() {
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
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          title: const Text(
            "Login",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Login Sucess")));
                context.go('/users');
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => ViewUserPage()));
              } else if (state is AuthFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Login failed")));
              } else if (state is AuthInavliduser) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User not found")));
              }
            },
            child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: "Email"),
                      validator: (value) =>
                          value!.isEmpty ? "Enter your email" : null,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          labelText: "password",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              icon: Icon(showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility))),
                      obscureText: showPassword,
                      validator: (value) =>
                          value!.isEmpty ? "Enter your password" : null,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                          return ElevatedButton(
                              onPressed: _submitForm,
                              child: state is AuthLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text("Submit"));
                        }),
                        // Text("forgot password?"),
                        const SizedBox(height: 20),
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
                        ElevatedButton(
                            onPressed: () {
                              context.push('/initial-screen');
                            },
                            child: Text("dg"))
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                )),
          ),
        ));
  }
}
