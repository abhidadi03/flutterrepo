import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myfirstapp/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:myfirstapp/features/user/auth/presentation/bloc/auth_event.dart';
import 'package:myfirstapp/features/user/auth/presentation/bloc/auth_state.dart';
import 'package:go_router/go_router.dart';
import 'package:myfirstapp/features/user/presentation/bloc/user_bloc.dart';
import 'package:myfirstapp/features/user/presentation/bloc/user_event.dart';
import 'package:myfirstapp/features/user/presentation/bloc/user_state.dart';
import '../../../../../common/widgets/common_button.dart';

class AuthSignup extends StatefulWidget {
  const AuthSignup({super.key});

  @override
  State<AuthSignup> createState() => _AuthSignup();
}

class _AuthSignup extends State<AuthSignup> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phonenoController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool showPassword = true;
  final RegExp passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$',
  );
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  void _submitForm() {
    print("came");
    if (_formkey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final name = _nameController.text.trim();
      final phoneno = _phonenoController.text.trim();
      print('login email:$email');
      print('password:$password');
      context.read<UserBloc>().add(CreateUser(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          phone: _phonenoController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserCreated) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('User registered Successfully')));
                context.go('/login');
              } else if (state is UserError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
                print('erro while creating:${state.message}');
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
                      "SIGNUP",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Image.asset(
                    "assets/images/welcome2.png",
                    height: 300,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: _nameController,
                      validator: (value) => value!.length < 3
                          ? "Name should contain min. 3 characters"
                          : null,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        hintText: "Name",
                        filled: true,
                        fillColor: Colors.purple.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        // value!.isEmpty ? "Enter your email" : null,
                        if (value == null || value.isEmpty) {
                          return "Enter email";
                        }
                        if (!emailRegex.hasMatch(value)) {
                          return "Enter valid email eg:(test@gmail.com)";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.mail),
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
                      validator: (value) {
                        // value!.isEmpty ? "Enter password" : null,
                        if (value == null || value.isEmpty) {
                          return "Enter password";
                        }
                        if (!passwordRegex.hasMatch(value)) {
                          return "Password must be 8+ chars, include upper, lower, number & special char";
                        }
                        return null;
                      },
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
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: _phonenoController,
                      validator: (value) =>
                          // {
                          value!.isEmpty ? "Enter your email" : null,
                      // if (value == null || value.isEmpty) {
                      //   return "Enter email";
                      // }
                      // if (!emailRegex.hasMatch(value)) {
                      //   return "Enter valid email eg:(test@gmail.com)";
                      // }
                      // return null;
                      // },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.mail),
                        hintText: "Phone",
                        filled: true,
                        fillColor: Colors.purple.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                        // return ElevatedButton(
                        //     onPressed: _submitForm,
                        //     style: ElevatedButton.styleFrom(
                        //         backgroundColor: Colors.purple,
                        //         foregroundColor: Colors.white,
                        //         minimumSize: Size(350, 50),
                        //         shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(30))),
                        //     child: state is UserLoading
                        //         ? const SizedBox(
                        //             width: 20,
                        //             height: 20,
                        //             child: CircularProgressIndicator(
                        //               strokeWidth: 2,
                        //               color: Colors.white,
                        //             ),
                        //           )
                        //         : const Text("Submit"));
                        return CommonButton(
                          text: "SIGNUP",
                          onPressed: _submitForm,
                          isLoading: state is UserLoading ? true : false,
                        );
                      })
                    ],
                  ),
                  const SizedBox(height: 45),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? "),
                      GestureDetector(
                        onTap: () {
                          context.go('/login');
                        },
                        child: const Text(
                          "Sign in",
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
