import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasrproject/utils/utils.dart';
import 'package:firebasrproject/widgets/round_botton_widget.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(hintText: "email"),
            ),
            SizedBox(
              height: 20,
            ),
            RoundButtonWidget(
              title: "send",
              onTap: () {
                auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value) {
                  Utils().toastMessage("send to email");
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
