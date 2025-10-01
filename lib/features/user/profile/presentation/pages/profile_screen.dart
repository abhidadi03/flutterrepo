import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myfirstapp/features/user/auth/presentation/pages/auth_signup.dart';
import 'package:myfirstapp/features/user/phone_validation/presentation/widgets/common_phone_field.dart';
import 'package:myfirstapp/features/user/profile/data/models/UserModel.dart';
import 'package:myfirstapp/features/user/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../../../phone_validation/presentation/widgets/common_phone_field.dart';
import '../../../phone_validation/presentation/bloc/phone_validation_bloc.dart';
import '../../../phone_validation/presentation/bloc/phone_validation_event.dart';
import '../../../phone_validation/presentation/bloc/phone_validation_state.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final storage = const FlutterSecureStorage();
  String? token;
  String? _verificationId;
  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchProfile();
  }

  Future<void> _loadTokenAndFetchProfile() async {
    String? storedToken = await storage.read(key: 'id_token');
    if (storedToken != null) {
      setState(() {
        token = storedToken;
      });
      context
          .read<ProfileBloc>()
          .add(FetchProfile(token: "Bearer $storedToken"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileSuccess) {
            print('came');
            final profile = state.user;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name: ${profile.name ?? ''}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("Email: ${profile.email ?? ''}",
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      profile.phoneNo != null && profile.phoneNo!.isNotEmpty
                          ? Text("Phone: ${profile.phoneNo ?? ''}",
                              style: const TextStyle(fontSize: 16))
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Scaffold(
                                      appBar: AppBar(
                                          title: const Text("Link Phone")),
                                      body: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: CommonPhoneField(
                                          onSendOtp: (phone) {
                                            context.read<OtpBloc>().add(SendOtp(
                                                phone: phone, isLinking: true));
                                            print('send otp to $phone');
                                          },
                                          onVerifyOtp: (phone, otp) {
                                            print("into Onverified");
                                            final state =
                                                context.read<OtpBloc>().state;
                                            print("stateeeee:$state");
                                            if (state is OtpSentSuccess) {
                                              _verificationId =
                                                  state.verificationId;
                                            } else if (state
                                                is ResendOtpSuccess) {
                                              _verificationId =
                                                  state.verificationId;
                                            }
                                            print(
                                                "verificationCode:$_verificationId");
                                            context.read<OtpBloc>().add(
                                                VerifyOtp(
                                                    verficationId:
                                                        _verificationId!,
                                                    otp: otp,
                                                    isLinking: true));
                                          },
                                          onResendOtp: (phone, resendToken) {
                                            print('resend otp for $phone');
                                          },
                                          onVerfiedOtp: (phone) {
                                            print('verified $phone');
                                            Navigator.pop(context, phone);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ).then((phone) {
                                  if (phone != null) {
                                    // update your profile.phoneNo in state
                                    context.read<ProfileBloc>().add(
                                        FetchProfile(token: "Bearer $token"));
                                  }
                                });
                              },
                              child: const Text(
                                "Link phone",
                                style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                    ],
                  ),
                ),
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
