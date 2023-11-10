import 'dart:async';
import 'package:finallyfirebase/ui/firestore/firestore_list_screen.dart';
import 'package:finallyfirebase/ui/posts/postsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finallyfirebase/ui/auth/loginscreen.dart';
import 'package:flutter/material.dart';

class SplashServices {
  isLogin(BuildContext context) {
    //instance of firebase auth
    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if (user != null) {
      Timer(
          const Duration(seconds: 3),
          () =>
              // Navigator.push(
              // context, MaterialPageRoute(builder: (context) => PostsScreen()))
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => FirestoreScreen()))
      );
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen())));
    }
  }
}
