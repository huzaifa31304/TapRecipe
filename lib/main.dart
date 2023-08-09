import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tap_recipe/Screens/auth_page.dart';
import 'package:tap_recipe/Screens/camera.dart';
import 'package:tap_recipe/Screens/home.dart';
import 'package:tap_recipe/Screens/homepage.dart';
import 'package:tap_recipe/Screens/login_page.dart';
import 'package:tap_recipe/firebase_options.dart';

List<CameraDescription> ?cameras;

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tap Recipe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthPage(),
    );
  }
}


