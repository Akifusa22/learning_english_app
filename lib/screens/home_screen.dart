import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_pro/constants.dart';
import 'package:edu_pro/presentation/sign_in_screen/sign_in_screen.dart';
import 'package:edu_pro/screens/components/reviewScreen.dart';
import 'package:edu_pro/screens/components/reviewScreen2.dart';
import 'package:edu_pro/screens/favourite.dart';
import 'package:edu_pro/screens/lessons/NewScreen1.dart';
import 'package:edu_pro/screens/lessons/NewScreen2.dart';
import 'package:edu_pro/screens/lessons/NewScreen3.dart';
import 'package:edu_pro/screens/quiz_screen.dart';
import 'package:edu_pro/screens/quiz_screen2.dart';
import 'package:edu_pro/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _doubleBackToExitPressedOnce = false;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: Color.fromRGBO(255, 255, 255, 1),
              title: Text(
                'Cở sở lý thuyết',
                style: TextStyle(
                  fontSize: 22,
                  color: Color.fromARGB(255, 54, 30, 171),
                ),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              elevation: 7,
              iconTheme: IconThemeData(color: Colors.black),
              actionsIconTheme: IconThemeData(color: Colors.black),

              // Add any other properties you need for the main app bar
            )
          : null, // Hide the app bar for other screens
      body: WillPopScope(
        onWillPop: () async {
          if (_doubleBackToExitPressedOnce) {
            // Thoát ứng dụng nếu người dùng đã nhấn quay lại lần thứ hai
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            return true;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Nhấn một lần nữa để thoát ứng dụng"),
              duration: Duration(seconds: 2),
            ),
          );
          // Đặt lại biến _doubleBackToExitPressedOnce sau 2 giây
          _doubleBackToExitPressedOnce = true;
          Future.delayed(Duration(seconds: 2), () {
            _doubleBackToExitPressedOnce = false;
          });
          return false;
        },
        child: Stack(
          children: [
            if (_selectedIndex == 1)
              Screen2()
            else if (_selectedIndex == 3)
              ProfileContent()
            else if (_selectedIndex == 2)
              ProgressScreen()
            else
              SafeArea(
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Center the content horizontally
                            children: [],
                          ),

                          //now we create model of our images and colors which we will use in our app
                          const SizedBox(
                            height: 25,
                          ),
                          //we can not use gridview inside column
                          //use shrinkwrap and physical scroll
                          CustomButton(
                            text: 'Lý thuyết về các thì tiếng Anh',
                            fontStyle: ButtonFontStyle.ManropeBold16Blue500_1,
                            variant: ButtonVariant.OutlineBluegray500,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewScreen1()),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomButton(
                            text: 'Quy tắc phát âm',
                            fontStyle: ButtonFontStyle.ManropeBold16Blue500_1,
                            variant: ButtonVariant.OutlineBluegray500,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewScreen2()),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomButton(
                            text: 'Học từ mới',
                            fontStyle: ButtonFontStyle.ManropeBold16Blue500_1,
                            variant: ButtonVariant.OutlineBluegray500,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewScreen3()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),

      //bottom bar
      // now we will use bottom bar package
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedIndex,
        showElevation: true, // use this to remove appBar's elevation
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },

        items: [
          BottomNavyBarItem(
              icon: Icon(Icons.home),
              title: Text('Trang chính'),
              activeColor: kpink,
              inactiveColor: Colors.grey[300]),
          BottomNavyBarItem(
            icon: Icon(Icons.favorite_rounded),
            title: Text('Luyện tập'),
            inactiveColor: Colors.grey[300],
            activeColor: kpink,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.message),
            title: Text('Tiến độ'),
            inactiveColor: Colors.grey[300],
            activeColor: kpink,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text('Hồ sơ'),
            inactiveColor: Colors.grey[300],
            activeColor: kpink,
          ),
        ],
      ),
    );
  }
}

class Screen2 extends StatefulWidget {
  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 7,
        iconTheme: IconThemeData(color: Colors.black),
        actionsIconTheme: IconThemeData(color: Colors.black),
        title: FutureBuilder(
          future: _getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final userData = snapshot.data as Map<String, dynamic>;
              return Text(
                userData['fullName'],
                style: TextStyle(
                  fontSize: 22,
                  color: Color.fromARGB(255, 54, 30, 171),
                ),
              );
            }
          },
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Bài tập trắc nghiệm",
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  //now we create model of our images and colors which we will use in our app
                  const SizedBox(
                    height: 10,
                  ),
                  //we can not use gridview inside column
                  //use shrinkwrap and physical scroll
                  Card(
                    child: ListTile(
                      title: Text('Vận dụng'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Screen1()),
                        );
                      },
                      trailing: Text(
                        '8 câu',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Sắp xếp từ",
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Card(
                    child: ListTile(
                      title: Text('Vận dụng'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => QuizScreen2()),
                        );
                      },
                      trailing: Text('10 câu',
                          style: TextStyle(
                            fontSize: 17,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _getUserData() async {
    // Implement your logic to fetch current user data here
    final user = FirebaseAuth.instance.currentUser;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    return userDoc.data() as Map<String, dynamic>;
  }
}

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  User? user; // Declare a User variable

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser; // Initialize user in initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: Text(
          'Theo dõi tiến độ',
          style: TextStyle(
            fontSize: 22,
            color: Color.fromARGB(255, 54, 30, 171),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 7,
        iconTheme: IconThemeData(color: Colors.black),
        actionsIconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label at the top-left corner
            Text(
              'Bài tập trắc nghiệm',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Center(
              child: FutureBuilder<DocumentSnapshot?>(
                future: _getUserProgress(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data == null) {
                    return Text('Dữ liệu tiến độ trống');
                  } else {
                    // Handle null values and calculate progress
                    int totalQuestions = snapshot.data!['totalQuestions'] ?? 0;
                    int correctAnswers = snapshot.data!['correctAnswers'] ?? 0;

                    // Avoid division by zero
                    double progressPercentage = totalQuestions != 0
                        ? ((correctAnswers / totalQuestions) * 100)
                            .roundToDouble()
                        : 0;

                    // Display the progress as correctedAnswer/totalQuestions
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          child: ListTile(
                            title: Text('Tiến độ'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ReviewScreen(
                                    userEmail: user?.email ?? '',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 16),
            // Additional Text similar to "Bài tập trắc nghiệm"

            Text(
              'Bài tập sắp xếp từ',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Card(
              child: ListTile(
                title: Text('Tiến độ'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ReviewScreen2(),
                    ),
                  );
                },
              ),
            ),

            // Add more widgets for the additional exercise section as needed
          ],
        ),
      ),
    );
  }

  Future<DocumentSnapshot?> _getUserProgress() async {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail != null) {
      DocumentSnapshot progressSnapshot = await FirebaseFirestore.instance
          .collection('quiz_results')
          .doc(userEmail)
          .get();

      // Check if the document exists
      if (progressSnapshot.exists) {
        return progressSnapshot;
      } else {
        // Return null if the document doesn't exist
        return null;
      }
    } else {
      // Return null if the user is not authenticated
      return null;
    }
  }
}

class ProfileContent extends StatefulWidget {
  @override
  _ProfileContentState createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isExpanded = false;
  bool isExpanded2 = false;
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final userData = snapshot.data as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 55.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
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
                    SizedBox(
                      height: 15,
                    ),
                    Card(
                      child: ListTile(
                        title: Text('Thông tin tài khoản'),
                        onTap: () {
                          setState(() {
                            isExpanded2 = !isExpanded2;
                            if (isExpanded2) {
                              isExpanded = false;
                            } else {
                              isExpanded2 = false;
                            }
                          });
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded;
                              if (isExpanded) {
                                isExpanded2 = false;
                                _fullNameController.text = userData['fullName'];
                                _phoneController.text = userData['phone'];
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    if (isExpanded) ...[
                      buildUserInfoCard(userData),
                      buildEditUserInfoCard(),
                      buildEditPhoneInfoCard(),
                      buildChangePasswordCard(),
                    ],
                    if (isExpanded2) ...[
                      buildUserInfoCard(userData),
                      buildPhoneInfoCard(userData),
                      buildChangePasswordCard(),
                    ],
                    SizedBox(height: 16.0),
                    Card(
                      child: ListTile(
                        title: Text('Sổ tay từ vựng'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => FavoriteWordsScreen()),
                          );
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.bookmark),
                          onPressed: () {
                            // Handle logout
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => FavoriteWordsScreen()),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Card(
                      child: ListTile(
                        title: Text('Đăng xuất'),
                        onTap: () async {
                          await _auth.signOut();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => SignInScreen()),
                          );
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.logout),
                          onPressed: () async {
                            // Handle logout
                            await _auth.signOut();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  bool _isPasswordValid(String password) {
    // Check if the password is at least 6 characters long
    if (password.length < 6) {
      return false;
    }

    // Check if the password contains at least one letter
    if (!password.contains(RegExp(r'[a-zA-Z]'))) {
      return false;
    }

    return true;
  }

  void _changePassword() async {
    // Check if any of the fields is empty
    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmNewPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin.'),
          duration: Duration(seconds: 3),
        ),
      );
      return; // Stop execution if any field is empty
    }

    // Check if the new password and confirm new password match
    if (_newPasswordController.text != _confirmNewPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Mật khẩu mới và xác nhận mật khẩu mới không trùng khớp.'),
          duration: Duration(seconds: 3),
        ),
      );
      return; // Stop execution if passwords do not match
    }

    // Validate the new password
    final newPassword = _newPasswordController.text;
    if (!_isPasswordValid(newPassword)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Mật khẩu mới không hợp lệ. Mật khẩu phải có ít nhất 6 kí tự và chứa ít nhất một kí tự chữ cái.',
          ),
          duration: Duration(seconds: 3),
        ),
      );
      return; // Stop execution if the password is invalid
    }

    try {
      final user = _auth.currentUser;
      if (user != null) {
        final currentPassword = _currentPasswordController.text;

        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        try {
          // Reauthenticate the user
          await user.reauthenticateWithCredential(credential);
        } catch (reauthError) {
          // Handle reauthentication error (old password does not match)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Mật khẩu cũ không khớp. Vui lòng kiểm tra lại.'),
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        // Change the password
        await user.updatePassword(newPassword);

        // Show a success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mật khẩu đã được thay đổi thành công.'),
            duration: Duration(seconds: 3),
          ),
        );

        // Clear the form
        _formKey.currentState?.reset();
      }
    } catch (e) {
      // Show an error snackbar for other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xảy ra lỗi khi thay đổi mật khẩu: $e'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Card buildChangePasswordCard() {
    return Card(
      child: ExpansionTile(
        title: Text('Đổi mật khẩu'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _currentPasswordController,
                    decoration: InputDecoration(labelText: 'Mật khẩu hiện tại'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu hiện tại.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _newPasswordController,
                    decoration: InputDecoration(labelText: 'Mật khẩu mới'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu mới.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmNewPasswordController,
                    decoration:
                        InputDecoration(labelText: 'Xác nhận mật khẩu mới'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng xác nhận mật khẩu mới.';
                      } else if (value != _newPasswordController.text) {
                        return 'Mật khẩu xác nhận không khớp.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _changePassword,
                    child: Text('Đổi Mật Khẩu'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Card buildPhoneInfoCard(Map<String, dynamic> userData) {
    return Card(
      child: ListTile(title: Text('Số điện thoại: ${userData['phone']}')),
    );
  }

  Card buildEditPhoneInfoCard() {
    return Card(
      child: ListTile(
        title: TextField(
          controller: _phoneController,
          decoration: InputDecoration(labelText: 'Đổi số điện thoại'),
        ),
        trailing: IconButton(
          icon: Icon(Icons.phone_android),
          onPressed: () async {
            // Handle update profile action
            if (_validatePhoneNumber(_phoneController.text)) {
              final user = _auth.currentUser;
              await _firestore
                  .collection('users')
                  .doc(user?.uid)
                  .update({'phone': _phoneController.text});

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Số điện thoại đã được cập nhật'),
                  duration: Duration(seconds: 2),
                ),
              );

              // Close the text field after updating
              setState(() {
                isExpanded = false;
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Số điện thoại không hợp lệ'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  bool _validatePhoneNumber(String phoneNumber) {
    // Định dạng số điện thoại Việt Nam: 10 hoặc 11 chữ số, bắt đầu bằng 0 hoặc +84
    final RegExp phoneRegex = RegExp(r'^(?:\+84|0[1-9])+[0-9]{8,9}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  Card buildUserInfoCard(Map<String, dynamic> userData) {
    return Card(
      child: ListTile(
        title: Text('Họ và tên: ${userData['fullName']}'),
        subtitle: Text('Email: ${userData['email']}'),
      ),
    );
  }

  Card buildEditUserInfoCard() {
    return Card(
      child: ListTile(
        title: TextField(
          controller: _fullNameController,
          decoration: InputDecoration(labelText: 'Đổi tên'),
        ),
        trailing: IconButton(
          icon: Icon(Icons.save),
          onPressed: () async {
            // Handle update profile action
            final user = _auth.currentUser;
            await _firestore
                .collection('users')
                .doc(user?.uid)
                .update({'fullName': _fullNameController.text});

            // Show a success Snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Cập nhật họ và tên thành công'),
                duration: Duration(seconds: 2),
              ),
            );
            // Close the text field after updating
            setState(() {
              isExpanded = false;
            });
          },
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _getUserData() async {
    final user = _auth.currentUser;
    final userDoc = await _firestore.collection('users').doc(user?.uid).get();

    return userDoc.data() as Map<String, dynamic>;
  }
}
