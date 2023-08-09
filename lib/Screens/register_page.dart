import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tap_recipe/services/auth_service.dart';
import '../components/square_title.dart';
import '../components/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Register_Page extends StatefulWidget {
  final Function()? onTap;
  const Register_Page({super.key, required this.onTap}) ;

  @override
  State<Register_Page> createState() => _Register_PageState();
}

class _Register_PageState extends State<Register_Page> {

  //text editing contr
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final confirmpasswordcontroller = TextEditingController();

  //Reg user methods

  void RegUser() async{

    //loading circle
    showDialog(
      context: context,
      builder: (context){
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    //pop loading circle
    Navigator.pop(context);

    //try creating the user
    try {
      // check if pass is confirmed
      if(passwordcontroller.text==confirmpasswordcontroller.text )
      {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailcontroller.text,
            password: passwordcontroller.text
        );
      }else
      {
        //show error message, pass don't match
        showErrorMessage("Passwords don't match");
      }

    } on FirebaseAuthException catch (e){
      //pop loading circle

      //Navigator.push(context, MaterialPageRoute(builder: (c)=> Register_Page(onTap: widget.onTap)));
      showErrorMessage(e.code);
      //show error meessage

    }
  }

  //wrong email message popup
  void showErrorMessage(String message){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Center
            (
              child: Text(
                "Invalid email"
              )
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),

                Container(
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 70.0,
                      child: Image.asset('resources/images/cheflogo.png')
                  ),
                ),

                SizedBox(height: 15),
                Text(
                  "Let's create an account for you",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 25),

                // email textfield
                text_field(
                  hintText: "new email",
                  obscureText: false,
                  controller: emailcontroller,
                ),

                SizedBox(height: 15),

                //password textfield
                text_field(
                  hintText: "new password",
                  obscureText: true,
                  controller: passwordcontroller,
                ),
                SizedBox(height: 15),

                //confirm password
                text_field(
                  hintText: "re enter new password",
                  obscureText: true,
                  controller: confirmpasswordcontroller,
                ),

                SizedBox(height: 15),

                //log in button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: InkWell(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    onTap: RegUser,
                  ),
                ),
                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // google button
                      SquareTile(
                          onTap: () => AuthService().signInWithGoogle(),
                          imagePath: 'resources/images/google_pic.jpg'
                      ),

                      SizedBox(width: 25),
                    ]
                ),

                SizedBox(height: 16),

                //not a member reg now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ',
                      style: TextStyle(
                        color: Colors.white,
                        //    fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    GestureDetector(
                      child: Text('login now',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: widget.onTap,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
