import 'package:flutter/material.dart';

// ignore: camel_case_types
class text_field extends StatelessWidget {
  const text_field({Key? key, this.controller, required this.hintText, required this.obscureText, }) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[350],
              border: Border.all(color: Colors.orangeAccent, width: 1.5),
              borderRadius: BorderRadius.circular(20)
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                      fontWeight: FontWeight.w300 )
              ),
            ),
          ),
        )
    );

  }
}