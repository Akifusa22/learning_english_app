import 'package:edu_pro/presentation/sign_in_screen/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailScreen extends StatefulWidget {
  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    sendVerificationEmail();
  }

  Future<void> sendVerificationEmail() async {
    try {
      if (_user != null) {
        await _user!.sendEmailVerification();
      }
    } catch (e) {
      // Xử lý lỗi gửi email xác minh
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
        automaticallyImplyLeading: false, // Không hiển thị nút quay lại
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('An email verification link has been sent to your email.'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Đóng dialog
                // Di chuyển về màn hình đăng nhập
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()));
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
