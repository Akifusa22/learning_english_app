import 'package:edu_pro/auth.dart';
import 'package:edu_pro/presentation/sign_in_screen/sign_in_screen.dart';
import 'package:edu_pro/presentation/sign_up_screen/sign_up_screen.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData){
          return SignUpScreen();
        } else {
          return SignInScreen();
        }
      }
    );
  }
}