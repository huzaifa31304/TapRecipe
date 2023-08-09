import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tap_recipe/Screens/forgot_pass_page.dart';
import 'package:tap_recipe/components/square_title.dart';
import 'package:tap_recipe/services/auth_service.dart';
import '../components/text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {

  //text editing controllers
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  //Log user in method
  void LogUserIn() async{

    //show loading circle
    showDialog(
      context: context,
      builder: (context){
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //try login
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller.text,
        password: passwordcontroller.text,
      );
      //pop loading circle
      Navigator.pop(context);

    }on FirebaseAuthException catch(e){
      //pop loading circle
      Navigator.pop(context);

      //show error meessage
      showErrorMessage(e.code);
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
              child: Text("Invalid \nemail or password")
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
                SizedBox(height: 30),

                Container(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                      radius: 70.0,
                      child: Image.asset('resources/images/cheflogo.png')
                  ),
                ),
                SizedBox(height: 10),
                // Hello message
                Text(
                  "Don't Starve: Just Fetch",
                  style: GoogleFonts.pacifico(
                    //fontWeight: FontWeight.,
                    fontSize: 23,
                    color: Colors.red[900],
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  'Log in to your account',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20),

                // email textfield
                text_field(
                  hintText: "email",
                  obscureText: false,
                  controller: emailcontroller,
                ),

                SizedBox(height: 10),

                //password textfield
                text_field(
                  hintText: "password",
                  obscureText: true,
                  controller: passwordcontroller,
                ),
                SizedBox(height: 7),

                //forgot password
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: Text(
                            "Forgot Password?",
                  style : TextStyle(
                        color: Colors.white,
                  fontStyle: FontStyle.italic),
                        ),
                        onTap: (){
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context){
                            return ForgotPasswordPage();
                          },
                          ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

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
                          'Log in',
                          style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    onTap: LogUserIn,
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

                const SizedBox(height:15),

                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      // google button
                      SquareTile(
                          onTap: () => AuthService().signInWithGoogle(),
                          imagePath: 'resources/images/google_pic.jpg'
                      ),

                      SizedBox(width: 25),
                    ]
                ),

                const SizedBox(height: 20),

                //not a member reg now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   const Text('Not a member? ',
                      style: TextStyle(
                        color: Colors.white,
                        //    fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    GestureDetector(
                     child: Text('Register now',
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
