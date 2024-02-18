import 'package:edu_pro/core/app_export.dart';
import 'package:edu_pro/presentation/sign_in_screen/sign_in_screen.dart';
import 'package:edu_pro/widgets/custom_button.dart';
import 'package:edu_pro/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String? errorMessage = '';
  TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1, milliseconds: 600),
      ),
    );
  }

  Future<void> sendResetPasswordEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showSnackbar(
          "Liên kết đặt lại mật khẩu đã được gửi đến email của bạn.");
    } catch (e) {
      print('Error sending reset password email: $e');
      _showSnackbar("Có lỗi xảy ra. Vui lòng thử lại sau.");
    }
  }

  bool isEmailValid(String email) {
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF0F6F2),
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            // Unfocus keyboard when tapping outside of text fields
            FocusScope.of(context).unfocus();
          },
          child: Container(
            width: double.maxFinite,
            padding: getPadding(left: 24, top: 39, right: 24),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/nature_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Chào mừng đến với EduPro!",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtManropeExtraBold20.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: getPadding(top: 9),
                    child: Text(
                      "Quên mật khẩu?",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtManrope16.copyWith(
                        letterSpacing: getHorizontalSize(0.3),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(height: 30),
                CustomTextFormField(
                  focusNode: FocusNode(),
                  controller: emailController,
                  hintText: "Email",
                  margin: getMargin(top: 20),
                  textInputType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập địa chỉ email.';
                    } else if (!isEmailValid(value)) {
                      return 'Vui lòng nhập một địa chỉ email hợp lệ.';
                    }
                    return null;
                  },
                ),
                Container(height: 10),
                GestureDetector(
                  onTap: () {
                    // Unfocus keyboard before sending reset email
                    FocusScope.of(context).unfocus();

                    if (isEmailValid(emailController.text)) {
                      sendResetPasswordEmail(emailController.text);
                    } else {
                      _showSnackbar("Vui lòng nhập một địa chỉ email hợp lệ.");
                    }
                  },
                  child: CustomButton(
                    height: getVerticalSize(62),
                    text: "Xác thực",
                    margin: getMargin(top: 20),
                    shape: ButtonShape.RoundedBorder10,
                    padding: ButtonPadding.PaddingAll16,
                    fontStyle: ButtonFontStyle.ManropeBold16Gray50_1,
                  ),
                ),
                Container(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  },
                  child: Padding(
                    padding: getPadding(top: 10),
                    child: Text(
                      "Đăng nhập",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtManropeSemiBold14.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
