import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/common_button.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Welcome To EDU",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Opacity(
                  opacity: 0.8,
                  child: Image.asset(
                    "assets/images/welcome.png",
                    height: 380,
                    width: 410,
                    fit: BoxFit.contain,
                  ),
                )),
            const SizedBox(height: 15),
            // ElevatedButton(
            //     onPressed: () {
            //       context.push('/login');
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.purple,
            //       foregroundColor: Colors.white,
            //       minimumSize: Size(250, 50),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(30),
            //       ),
            //     ),
            //     child: const Text(
            //       "Login",
            //       style: TextStyle(fontSize: 15),
            //     )),
            CommonButton(text: "LOGIN", onPressed: () => context.go('/login')),
            const SizedBox(height: 15),
            CommonButton(
              text: "SIGNUP",
              onPressed: () => context.go('/signup'),
              backgroundColor: Colors.purple.shade200,
              textColor: Colors.black,
            ),
            // ElevatedButton(
            //     onPressed: () {
            //       context.push('/signup');
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.purple.shade50,
            //       foregroundColor: Colors.black,
            //       minimumSize: Size(250, 50),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(30),
            //       ),
            //     ),
            //     child: Text("Signup"))
          ],
        )
      ])),
    );
  }
}
