import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tap_recipe/Screens/home.dart';
import 'package:tap_recipe/Screens/homepage.dart';
import 'package:tap_recipe/Screens/login_or_register_page.dart';
import 'package:tap_recipe/Screens/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:StreamBuilder<User?> (
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {

          //user logged in
          if (snapshot.hasData) {
            return Home();
          }

          //user not logged in
          else {
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
