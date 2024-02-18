import 'package:edu_pro/screens/components/reviewScreen2.dart';

import 'package:edu_pro/screens/quiz_screen2.dart';

import 'package:flutter/material.dart';

class ResultScreen2 extends StatefulWidget {
  final int correctAnswers;
  final int totalQuestions;

  ResultScreen2({required this.correctAnswers, required this.totalQuestions});

  @override
  State<ResultScreen2> createState() => _ResultScreen2State();
}

class _ResultScreen2State extends State<ResultScreen2> {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kết quả'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              'Số câu trả lời đúng: ${widget.correctAnswers}/${widget.totalQuestions}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => QuizScreen2()),
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
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ReviewScreen2()),
                  );
                },
                child: Text('Xem kết quả'),
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
