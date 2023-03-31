import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasrproject/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/round_botton_widget.dart';

class SignUPScreen extends StatefulWidget {
  const SignUPScreen({Key? key}) : super(key: key);

  @override
  State<SignUPScreen> createState() => _SignUPScreenState();
}

class _SignUPScreenState extends State<SignUPScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool loading = false;
  void signUp() {
    setState(() {
      loading = true;
    });
    auth.createUserWithEmailAndPassword(email: emailController.text.toString(), password: passwordController.text.toString()).then((value) {
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
    //     .whenComplete(() {
    //   DocumentReference doc = FirebaseFirestore.instance.collection('Users').doc();
    //   Map<String, dynamic> data = {
    //     'id': doc.id,
    //     // "name": nameController.text,
    //     'email': emailController.text,
    //   };
    //   doc.set(data);
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    passwordController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "enter email";
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: InputDecoration(hintText: "email", prefixIcon: Icon(Icons.alternate_email)),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "enter email";
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(hintText: "password", prefixIcon: Icon(Icons.lock_open)),
              ),
              SizedBox(
                height: 50,
              ),
              RoundButtonWidget(
                title: "Sign up",
                loading: loading,
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    signUp();
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                      child: Text("Log in"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
