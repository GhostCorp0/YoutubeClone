import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: GestureDetector(
              onTap:() async{
                await GoogleSignIn.instance.signOut();
                await FirebaseAuth.instance.signOut();
              },
              child: Container(
                height: 47,
                width: 170,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12)
                  )
                ),
                child: Center(
                  child: Text("Log Out",style: TextStyle(
                    color: Colors.white,fontWeight: FontWeight.w500
                  ),),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
