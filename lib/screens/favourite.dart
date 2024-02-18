import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteWordsScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: Text(
          'Danh sách từ yêu thích',
          style: TextStyle(
            fontSize: 22,
            color: Color.fromARGB(255, 54, 30, 171),
          ),
        ),
        centerTitle: true,
        elevation: 7,
        iconTheme: IconThemeData(color: Colors.black),
        actionsIconTheme: IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder(
        future: _getFavoriteWords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Lỗi: ${snapshot.error}');
          } else {
            List<Map<String, dynamic>> favoriteWords =
                snapshot.data as List<Map<String, dynamic>>;

            if (favoriteWords.isEmpty) {
              return Center(
                child: Text('Không có dữ liệu'),
              );
            }

            return ListView.builder(
              itemCount: favoriteWords.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> wordData = favoriteWords[index];
                String word = wordData['word'];
                String type = wordData['type'];
                String meaning = wordData['meaning'];

                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 5,
                  child: ListTile(
                    title: Text(word),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Type: $type'),
                        Text('Meaning: $meaning'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getFavoriteWords() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String userEmail = user.email ?? '';
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            await FirebaseFirestore.instance
                .collection('favourite')
                .doc(userEmail)
                .get();

        if (documentSnapshot.exists) {
          List<Map<String, dynamic>> favoriteWords =
              (documentSnapshot.data()?['words'] as List<dynamic>)
                  .cast<Map<String, dynamic>>();
          return favoriteWords;
        }
      }

      return [];
    } catch (e) {
      print('Lỗi khi lấy danh sách từ yêu thích: $e');
      return [];
    }
  }
}
