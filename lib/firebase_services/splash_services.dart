import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasrproject/fireStore/firestore_list_screen.dart';
import 'package:firebasrproject/posts/post_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ui/auth/login_screen.dart';

class SplashServices {
  final auth = FirebaseAuth.instance;
  void isLogin(BuildContext context) {
    final user = auth.currentUser;

    if (user != null) {
      Timer(Duration(seconds: 2), () => Navigator.push(context, MaterialPageRoute(builder: (context) => FireStoreScreen())));
    } else {
      Timer(Duration(seconds: 2), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      });
    }
  }
}
