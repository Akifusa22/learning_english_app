import 'package:edu_pro/core/app_export.dart';
import 'package:edu_pro/presentation/sign_in_screen/sign_in_screen.dart';
import 'package:edu_pro/widgets/custom_button.dart';
import 'package:edu_pro/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:edu_pro/auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

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

  final FocusNode emailFocusNode = FocusNode();
  bool isPhoneNumberValid(String phoneNumber) {
    // Định dạng số điện thoại Việt Nam: 10 hoặc 11 chữ số, bắt đầu bằng 0 hoặc +84
    final RegExp phoneRegex = RegExp(r'^(?:\+84|0[1-9])+[0-9]{8,9}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  bool isEmailValid(String email) {
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool isPasswordValid(String password) {
    // Kiểm tra độ dài của mật khẩu
    if (password.length <= 6) {
      return false;
    }

    // Kiểm tra xem mật khẩu có chứa ít nhất một chữ cái hay không
    if (!password.contains(RegExp(r'[a-zA-Z]'))) {
      return false;
    }

    return true;
  }

  String? errorMessage = '';
  bool isLogin = true;

  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      final emailExists =
          await Auth().isEmailAlreadyInUse(emailController.text);
      if (emailExists) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Email Đã Đăng Ký"),
              content: Text("Email bạn nhập đã được đăng ký trước đó."),
              actions: <Widget>[
                TextButton(
                  child: Text("Đóng"),
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
        FirebaseAuth _auth = FirebaseAuth.instance;

        Future<void> sendEmailVerification() async {
          User? user = _auth.currentUser;

          if (user != null) {
            await user.sendEmailVerification();
          }
        }

        await Auth().createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        final User user = FirebaseAuth.instance.currentUser!;
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'fullName': fullnameController.text,
          'email': emailController.text,
          'phone': phoneController.text

          // Thêm thêm trường theo nhu cầu
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Một đường dẫn đã gửi tới Email của bạn để xác nhận"),
              content: Text("Vui lòng xác nhận tài khoản Email!"),
              actions: <Widget>[
                TextButton(
                  child: Text("Đóng"),
                  onPressed: () {
                    sendVerificationEmail();
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  },
                ),
              ],
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  void handleSignUpButtonPress() async {
    if (fullnameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty||
        phoneController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Thiếu Thông Tin"),
            content: Text("Vui lòng điền đầy đủ thông tin cần thiết."),
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
    } else if (!isEmailValid(emailController.text)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Email Không Hợp Lệ"),
            content: Text("Vui lòng nhập địa chỉ email hợp lệ."),
            actions: <Widget>[
              TextButton(
                child: Text("Đóng"),
                onPressed: () {
                  Navigator.of(context).pop();
                  emailFocusNode.requestFocus();
                },
              ),
            ],
          );
        },
      );
    } else if (!isPasswordValid(passwordController.text)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Mật khẩu không hợp lệ"),
            content: Text(
                "Vui lòng nhập mật khẩu có ít nhất 6 kí tự và chứa chữ cái."),
            actions: <Widget>[
              TextButton(
                child: Text("Đóng"),
                onPressed: () {
                  Navigator.of(context).pop();
                  passwordController.clear();
                  emailFocusNode
                      .requestFocus(); // Xóa mật khẩu để người dùng nhập lại
                },
              ),
            ],
          );
        },
      );
    } else if (!isPhoneNumberValid(phoneController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Số điện thoại không hợp lệ."),
          duration: Duration(seconds: 2),
        ),
      );
    } else if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Xác nhận mật khẩu không khớp."),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      await createUserWithEmailAndPassword();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF0F6F2), // Màu xanh lá cây nhạt
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.maxFinite,
          padding: getPadding(
            left: 24,
            top: 39,
            right: 24,
            bottom: 39,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/images/nature_bg.png"), // Hình nền thiên nhiên
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Tạo tài khoản ",
                      style: TextStyle(
                        color: Colors.black, // Màu chữ trắng
                        fontSize: getFontSize(24),
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w800,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.2), // Đổ bóng mờ
                            offset: Offset(1, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                    TextSpan(
                      text: "E D U P R O",
                      style: TextStyle(
                        color: Colors.blue, // Màu chữ trắng
                        fontSize: getFontSize(24),
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.2), // Đổ bóng mờ
                            offset: Offset(1, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: getPadding(top: 7),
                child: Text(
                  "Tạo tài khoản để tiếp tục",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtManrope16.copyWith(
                    color: Colors.black, // Màu chữ trắng
                    letterSpacing: getHorizontalSize(0.3),
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.2), // Đổ bóng mờ
                        offset: Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
              CustomTextFormField(
                focusNode: FocusNode(),
                controller: fullnameController,
                hintText: "Họ và Tên",
                margin: getMargin(top: 40),
              ),
              CustomTextFormField(
                  focusNode: emailFocusNode,
                  controller: emailController,
                  hintText: "Email",
                  margin: getMargin(top: 16)),
              CustomTextFormField(
                focusNode: FocusNode(),
                controller: passwordController,
                hintText: "Mật khẩu",
                margin: getMargin(top: 16),
                padding: TextFormFieldPadding.PaddingT14,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.visiblePassword,
                isObscureText: true,
              ),
              CustomTextFormField(
                focusNode: FocusNode(),
                controller: confirmPasswordController,
                hintText: "Xác nhận mật khẩu",
                margin: getMargin(top: 16),
                padding: TextFormFieldPadding.PaddingT14,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.visiblePassword,
                isObscureText: true,
              ),
              CustomTextFormField(
                focusNode: FocusNode(),
                controller: phoneController,
                hintText: "Số điện thoại",
                margin: getMargin(top: 16),
                padding: TextFormFieldPadding.PaddingT14,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.phone,
              ),
              GestureDetector(
                onTap: handleSignUpButtonPress,
                child: CustomButton(
                  height: getVerticalSize(56),
                  text: "Đăng Ký",
                  margin: getMargin(top: 24),
                  shape: ButtonShape.RoundedBorder10,
                  padding: ButtonPadding.PaddingAll16,
                  fontStyle: ButtonFontStyle.ManropeBold16Gray50_1,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: getPadding(
                    left: 22,
                    top: 27,
                    right: 21,
                    bottom: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Bạn đã có tài khoản?",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtManrope16.copyWith(
                          color: Colors.white, // Màu chữ trắng
                          letterSpacing: getHorizontalSize(0.3),
                          shadows: [
                            Shadow(
                              color:
                                  Colors.black.withOpacity(0.2), // Đổ bóng mờ
                              offset: Offset(1, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          onTapTxtSignup(context);
                        },
                        child: Padding(
                            padding: getPadding(left: 4, top: 1),
                            child: Text("Đăng Nhập",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeExtraBold20.copyWith(
                                    color: Colors.blue,
                                    letterSpacing: getHorizontalSize(0.2)))),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTapTxtSignup(BuildContext context) async {
    createUserWithEmailAndPassword();
    Navigator.pushNamed(context, AppRoutes.signInScreen);
  }
}
