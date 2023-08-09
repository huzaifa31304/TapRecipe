import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'forgot_pass_page.dart';


class profile_page extends StatefulWidget {
  profile_page({Key? key}) : super(key: key);

  @override
  State<profile_page> createState() => _profile_pageState();

}

class _profile_pageState extends State<profile_page> {

  final user= FirebaseAuth.instance.currentUser!;


  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black87.withOpacity(0.5),
          spreadRadius: 3,
          blurRadius: 7,
          offset: Offset(0, 5),
        )
      ],
    );
  }

  void logUserOut(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Hi! Chef",
                style: GoogleFonts.dancingScript(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          backgroundColor: Colors.black87,
        ),
        backgroundColor: Colors.grey[800],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [

                SizedBox(height: 45),

                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 45
                  ),
                  child: Container(
                    decoration: _buildDecoration(),
                    child: Row(
                      children: [

                        Expanded(
                          child: Center(
                            child: Container(
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Text('Logged IN AS',
                                    style: GoogleFonts.luckiestGuy(
                                        fontSize: 26,
                                        color: Colors.black,
                                       // fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text( user.email!,
                                    style: GoogleFonts.cairo(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w200
                                    ),

                                  ),
                                  SizedBox(height: 20),
                                  // TextButton(
                                  //   style: TextButton.styleFrom(
                                  //       backgroundColor: Colors.brown,
                                  //       foregroundColor: Colors.black,
                                  //       shadowColor: Colors.brown,
                                  //       elevation: 10,
                                  //       shape: BeveledRectangleBorder(
                                  //           borderRadius: BorderRadius.all(
                                  //               Radius.circular(5)
                                  //           )
                                  //       ),
                                  //       textStyle: TextStyle(
                                  //         fontSize: 15,
                                  //         fontWeight: FontWeight.bold,
                                  //       )
                                  //   ),
                                  //   onPressed: () {},
                                  //   child: Text('Edit Profile',
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 20
                  ),
                  child: InkWell(
                    onTap: () { Navigator.of(context).push
                      (
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage(),
                        )
                    );
                    },
                    child: Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.05,
                      decoration: _buildDecoration(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.lock_outline_rounded),
                          Text('Reset Password',
                            style: GoogleFonts.luckiestGuy(
                           //   fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                  ),
                ),


                InkWell(
                  child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.05,
                    decoration: _buildDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.logout_rounded),
                        Text('Logout',
                          style: GoogleFonts.luckiestGuy(
                          //  fontWeight: FontWeight.bold,
                            color: Colors.red
                        ),
                        ),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                  onTap: logUserOut,
                ),
              ],
            ),
          ),
        )
    );
  }
}