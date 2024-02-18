import 'dart:async';
import 'package:edu_pro/presentation/sign_in_screen/sign_in_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Gọi hàm để chuyển hướng sau 1.5 giây
    _navigateToSignInScreen();
  }

  // Hàm chuyển hướng đến SignInScreen sau độ trễ
  void _navigateToSignInScreen() {
    // Sử dụng Future.delayed để tạo độ trễ
    Timer(Duration(seconds: 1), () {
      // Chuyển hướng đến SignInScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Builder(
          builder: (context) {
            return Container(
              width: double.maxFinite,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  Image.asset(
                    'assets/images/trilogo.png',
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'E D U P R O',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 65,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
