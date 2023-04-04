import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasrproject/fireStore/firestore_list_screen.dart';
import 'package:firebasrproject/posts/post_screen.dart';
import 'package:firebasrproject/ui/auth/login_width_phone_number.dart';
import 'package:firebasrproject/ui/auth/sign_up_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebasrproject/upload_images/upload_images_screen.dart';
import '../ui/auth/login_screen.dart';

class SplashServices {
  final auth = FirebaseAuth.instance;
  void isLogin(BuildContext context) {
    final user = auth.currentUser;

    if (user != null) {
      Timer(Duration(seconds: 2), () => Navigator.push(context, MaterialPageRoute(builder: (context) => UploadImagesScreens())));
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadImagesScreens()));
    } else {
      Timer(Duration(seconds: 2), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      });
    }
  }
}
