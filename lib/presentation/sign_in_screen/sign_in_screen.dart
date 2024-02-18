import 'package:edu_pro/core/app_export.dart';
import 'package:edu_pro/presentation/forgot_password/forgot_password_screen.dart';
import 'package:edu_pro/screens/admin1.dart';
import 'package:edu_pro/screens/home_screen.dart';
import 'package:edu_pro/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:edu_pro/auth.dart';
import 'package:edu_pro/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore_for_file: must_be_immutable

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

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

  final FocusNode emailFocusNode = FocusNode();

  var isLogin = false;
  var auth = FirebaseAuth.instance;

  void checkIfLogin() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        isLogin = true;
      }
    });
  }

  bool saveLoginInfo = false; // Mặc định không lưu thông tin đăng nhập

  bool isEmailValid(String email) {
    // Đây là biểu thức chính quy để kiểm tra email
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  String? errorMessage = '';

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final User? user = Auth().currentUser;

  Future<void> signInWithEmailAndPassword() async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setString('email', emailController.text);
    });
    try {
      await Auth().signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }


  void handleSignInButtonPress() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('email', emailController.text);

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      // Xử lý khi thiếu thông tin đăng nhập
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Thiếu Thông Tin"),
            content: Text("Vui lòng điền đầy đủ thông tin yêu cầu."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (!isEmailValid(emailController.text)) {
      // Xử lý khi email không hợp lệ
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Email Không Hợp Lệ"),
            content: Text("Vui lòng nhập một địa chỉ email hợp lệ."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  emailFocusNode.requestFocus();
                },
              ),
            ],
          );
        },
      );
    } else {
      try {
        final UserCredential userCredential =
            await auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        if (userCredential.user != null && userCredential.user!.emailVerified) {
          // Đăng nhập thành công và email đã xác minh
          // Kiểm tra tài khoản và chuyển hướng đến màn hình tương ứng
          if (userCredential.user?.email == "mirasakirido@gmail.com") {
            Get.to(() => BottomNavScreen()); // Chuyển hướng đến màn hình A
          } else {
            // Đối với các email khác, chuyển hướng đến màn hình khác
            Get.to(() => HomeScreen());
          }
        } else {
          // Đăng nhập thành công nhưng email chưa xác minh
          sendVerificationEmail();
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Vui lòng xác nhận tài khoản Email"),
                content: Text("Một liên kết đã gửi tới Email của bạn"),
                actions: <Widget>[],
              );
            },
          );
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop(); // Đóng dialog sau 2 giây
          });
        }
      } on FirebaseAuthException {
        // Xử lý lỗi đăng nhập (nếu có)
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Sai thông tin"),
              content: Text("Email Hoặc Mật Khẩu Sai"),
              actions: <Widget>[
                TextButton(
                  child: Text("Đóng"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Color(0xFFF0F6F2),
            resizeToAvoidBottomInset: false,
            body: Container(
                width: double.maxFinite,
                padding: getPadding(left: 24, top: 39, right: 24),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/images/nature_bg.png"), // Hình nền thiên nhiên
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Chào mừng đến với EduPro!",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtManropeExtraBold20.copyWith(
                                color: Colors.black,
                              ))),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: getPadding(top: 9),
                              child: Text("Đăng nhập vào tài khoản của bạn",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtManrope16.copyWith(
                                    letterSpacing: getHorizontalSize(0.3),
                                    color: Colors.black,
                                  )))),
                      CustomTextFormField(
                          focusNode: FocusNode(),
                          controller: emailController,
                          hintText: "Email",
                          margin: getMargin(top: 20),
                          textInputType: TextInputType.text),
                      CustomTextFormField(
                          focusNode: FocusNode(),
                          controller: passwordController,
                          hintText: "Mật Khẩu",
                          margin: getMargin(top: 16),
                          padding: TextFormFieldPadding.PaddingT14,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.visiblePassword,
                          isObscureText: true),
                      // Checkbox và Text "Ghi nhớ đăng nhập"

                      GestureDetector(
                        onTap: handleSignInButtonPress,
                        child: CustomButton(
                          height: getVerticalSize(62),
                          text: "Đăng Nhập",
                          margin: getMargin(top: 20),
                          shape: ButtonShape.RoundedBorder10,
                          padding: ButtonPadding.PaddingAll16,
                          fontStyle: ButtonFontStyle.ManropeBold16Gray50_1,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                        },
                        child: Padding(
                          padding: getPadding(top: 10),
                          child: Text(
                            "Quên mật khẩu?",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtManropeSemiBold14.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                          padding: getPadding(left: 42, top: 30, right: 41),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Chưa có tài khoản?",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtManrope16.copyWith(
                                      letterSpacing: getHorizontalSize(0.3),
                                      color: Colors.black,
                                    )),
                                GestureDetector(
                                    onTap: () {
                                      onTapTxtSignup(context);
                                    },
                                    child: Padding(
                                        padding: getPadding(left: 4, top: 1),
                                        child: Text("Đăng Ký",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeExtraBold20
                                                .copyWith(
                                                    color: Colors.blue,
                                                    letterSpacing:
                                                        getHorizontalSize(
                                                            0.2)))))
                              ]))
                    ]))));
  }

  onTapTxtSignup(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.signUpScreen);
  }
}
