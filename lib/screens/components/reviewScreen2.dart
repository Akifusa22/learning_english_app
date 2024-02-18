import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReviewScreen2 extends StatefulWidget {
  @override
  _ReviewScreen2State createState() => _ReviewScreen2State();
}

class _ReviewScreen2State extends State<ReviewScreen2> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;

  List<Map<String, dynamic>> quizResults = [];

  void fetchQuizResults() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('quiz_results2')
            .where('userEmail', isEqualTo: user.email)
            .get();

        setState(() {
          quizResults = querySnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
        });
      }
    } catch (error) {
      print('Error fetching quiz results: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    fetchQuizResults();
  }

  @override
  @override
  Widget build(BuildContext context) {
    int correctAnswers = quizResults.isNotEmpty
        ? quizResults[0]['correctAnswers'] as int? ?? 0
        : 0;

    int totalQuestions = quizResults.isNotEmpty
        ? quizResults[0]['totalQuestions'] as int? ?? 0
        : 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: 
            Text(
              '$correctAnswers/$totalQuestions',
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
      body: quizResults.isEmpty
          ? Center(
              child: Text('Dữ liệu trống'),
            )
          : ListView.builder(
              itemCount: quizResults.length,
              itemBuilder: (context, index) {
                final userAnswers =
                    quizResults[index]['userAnswers'] as List<dynamic>?;

                // Customize the display of each quiz result as needed
                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 5,
                  child: ListTile(
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Số đáp án đúng: ${quizResults[index]['correctAnswers']}',
                        ),
                        Text(
                          'Số lượng câu hỏi: ${quizResults[index]['totalQuestions']}',
                        ),
                        SizedBox(height: 8),
                        if (userAnswers != null)
                          ...userAnswers.map((answer) {
                            if (answer is Map<String, dynamic>) {
                              final userAnswer =
                                  answer['userAnswer'] as String? ?? '';
                              final originalQuestion =
                                  answer['originalQuestion'] as String? ?? '';
                              final isCorrect = userAnswer == originalQuestion;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  Text(
                                    '- Đáp án của người dùng: $userAnswer',
                                    style: TextStyle(
                                      color:
                                          isCorrect ? Colors.green : Colors.red,
                                    ),
                                  ),
                                  Text(
                                    '- Đáp án đúng: $originalQuestion',
                                    style: TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  ),
                                ],
                              );
                            } else {
                              return SizedBox
                                  .shrink(); // Handle unexpected data type
                            }
                          }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
