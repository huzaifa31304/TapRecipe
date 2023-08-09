
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tap_recipe/components/text_field.dart';

class ForgotPasswordPage extends StatefulWidget {

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailcontroller = TextEditingController();

  void dispose(){
    emailcontroller.dispose();
    super.dispose();
  }

  Future passwordReset()async{
    try{
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailcontroller.text.trim());
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          content: Text("Password Reset link send! Check Your email"),
        );
      },
    );
    }on FirebaseAuthException catch (e){
      print(e);
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          },
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Reset Password",
          style: GoogleFonts.dancingScript(
          fontSize: 26,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          )
              ),
            ]
        ),
      ),

        body: Column(
        children: [
          SizedBox(height: 50),
          Text("Enter your email here!",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          ),

          SizedBox(height: 20),

          text_field(
              hintText: "email",
              obscureText: false,
            controller: emailcontroller,
          ),

          SizedBox(height: 10),

          MaterialButton(
            onPressed: passwordReset,
            child: Text("Reset",
            style: TextStyle(
              color: Colors.black
            ),
            ),
            color: Colors.grey[350]
          )
      ],
    ),
    );
  }
}
