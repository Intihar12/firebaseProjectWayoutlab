import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasrproject/ui/auth/varifi_code.dart';
import 'package:firebasrproject/utils/utils.dart';
import 'package:firebasrproject/widgets/round_botton_widget.dart';
import 'package:flutter/material.dart';

class LoginWidthPhoneNumber extends StatefulWidget {
  const LoginWidthPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWidthPhoneNumber> createState() => _LoginWidthPhoneNumberState();
}

class _LoginWidthPhoneNumberState extends State<LoginWidthPhoneNumber> {
  final phoneController = TextEditingController();
  bool loading = false;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "+12 43434 5334"),
            ),
            SizedBox(
              height: 80,
            ),
            RoundButtonWidget(
                title: "Login",
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  auth.verifyPhoneNumber(
                      phoneNumber: phoneController.text,
                      verificationCompleted: (_) {
                        setState(() {
                          loading = false;
                        });
                      },
                      verificationFailed: (e) {
                        setState(() {
                          loading = false;
                        });
                        Utils().toastMessage(e.toString());
                      },
                      codeSent: (String verifyCationId, int? token) {
                        setState(() {
                          loading = false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerifyCodeScreen(
                                      verifyCodeId: verifyCationId,
                                    )));
                      },
                      codeAutoRetrievalTimeout: (e) {
                        setState(() {
                          loading = false;
                        });
                        Utils().toastMessage(e.toString());
                      });
                })
          ],
        ),
      ),
    );
  }
}
