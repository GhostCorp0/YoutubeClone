import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(onTap:() async {
        await GoogleSignIn.instance.signOut();
        await FirebaseAuth.instance.signOut();
      },child: Center(child: Text("Home Page"))),
    );
  }
}
