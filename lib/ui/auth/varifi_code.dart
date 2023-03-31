import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasrproject/posts/post_screen.dart';
import 'package:firebasrproject/widgets/round_botton_widget.dart';
import 'package:flutter/material.dart';

class VerifyCodeScreen extends StatefulWidget {
  VerifyCodeScreen({Key? key, required this.verifyCodeId}) : super(key: key);
  final String? verifyCodeId;
  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final verificationCodeController = TextEditingController();
  bool loading = false;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("verify"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            TextFormField(
              controller: verificationCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "6 digit code"),
            ),
            SizedBox(
              height: 80,
            ),
            RoundButtonWidget(
                title: "verify",
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  final credential = PhoneAuthProvider.credential(verificationId: widget.verifyCodeId.toString(), smsCode: verificationCodeController.text);

                  try {
                    auth.signInWithCredential(credential);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen()));
                  } catch (e) {
                    setState(() {
                      loading = false;
                    });
                  }
                })
          ],
        ),
      ),
    );
  }
}
