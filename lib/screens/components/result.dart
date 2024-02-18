import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_pro/screens/components/reviewScreen.dart';

import 'package:edu_pro/screens/quiz_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:edu_pro/model/questions.dart';
// Import your Screen1 file

class ResultScreen extends StatefulWidget {
  final List<Map<String, dynamic>> userAnswers;
  final List<CauHoi> questions;

  ResultScreen({required this.userAnswers, required this.questions});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  User? user;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser; // Initialize user in initState
  }

  // Function to save results to Firebase
  Future<void> _saveResultsToFirebase(
      String userEmail, int correctAnswers) async {
    try {
      // Get a reference to the Firestore database
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Collection reference for storing quiz results
      CollectionReference quizResults = firestore.collection('quiz_results');

      // Use user's email as the document ID
      DocumentReference userDocument = quizResults.doc(userEmail);

      // Set data in the document
      await userDocument.set({
        'userEmail': userEmail,
        'correctAnswers': correctAnswers,
        'totalQuestions': widget.questions.length,
        'answeredQuestions': widget.userAnswers,
      });

      print('Results saved to Firebase!');
    } catch (e) {
      print('Error saving results to Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    int correctAnswers = 0;

    for (int i = 0;
        i < widget.userAnswers.length && i < widget.questions.length;
        i++) {
      if (widget.userAnswers[i]['user_answer'] ==
          widget.questions[i].dapAnDung) {
        correctAnswers++;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Kết quả'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              'Số câu trả lời đúng: $correctAnswers/${widget.questions.length}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Screen1()),
                  );
                },
                child: Text('Thử lại'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () async {
                  // Get the current user's email
                  String? userEmail = FirebaseAuth.instance.currentUser?.email;

                  // Check if the user email is not null before saving to Firebase
                  if (userEmail != null) {
                    // Save results to Firebase
                    await _saveResultsToFirebase(userEmail, correctAnswers);

                    // Show a SnackBar with a message and two actions
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Kết quả đã được lưu!'),
                        duration: Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'Xem kết quả',
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReviewScreen(userEmail: user?.email ?? ''),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
                child: Text(' Lưu kết quả'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
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
