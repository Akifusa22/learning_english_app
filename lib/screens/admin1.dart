import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:edu_pro/constants.dart';
import 'package:edu_pro/presentation/sign_in_screen/sign_in_screen.dart';
import 'package:edu_pro/screens/AdminAdd.dart';
import 'package:edu_pro/screens/AdminAdd2.dart';
import 'package:edu_pro/screens/AdminWatch3.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    ThemCauHoiScreen(),
    AdminAdd2(),
    AdminWatch3(),
    EmptyScreen3(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
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
              title: Text('Home'),
              activeColor: kpink,
              inactiveColor: Colors.grey[300]),
          BottomNavyBarItem(
            icon: Icon(Icons.favorite_rounded),
            title: Text('Favorite'),
            inactiveColor: Colors.grey[300],
            activeColor: kpink,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.message),
            title: Text('Messages'),
            inactiveColor: Colors.grey[300],
            activeColor: kpink,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
            inactiveColor: Colors.grey[300],
            activeColor: kpink,
          ),
        ],
      ),
    );
  }
}

class EmptyScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is an empty screen 1.'),
    );
  }
}
class EmptyScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is an empty screen 2.'),
    );
  }
}



class EmptyScreen3 extends StatelessWidget {
  @override
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: ListTile(
          title: Text('Đăng xuất'),
          onTap: () async {
            await _auth.signOut();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SignInScreen()),
            );
          },
          trailing: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // Handle logout
              await _auth.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            },
          ),
        ),
      ),
    );
  }
}
