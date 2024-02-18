import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_pro/model/questions.dart';
import 'package:edu_pro/screens/components/result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Screen1 extends StatefulWidget {
  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  final List<CauHoi> questions = [];
  User? user = FirebaseAuth.instance.currentUser;
  int currentQuestionIndex = 0; // Track the current question index
  List<Map<String, dynamic>> userAnswers = [];
  bool userHasSelectedAnswer = false;
  String? selectedAnswer; // Track the selected answer

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('cau_hoi').get();
    print("Firebase Data: ${snapshot.docs.length} documents");
    final List<QueryDocumentSnapshot> documents = snapshot.docs;

    if (documents.isNotEmpty) {
      questions.addAll(
        documents.map(
          (doc) => CauHoi.fromMap(doc.data() as Map<String, dynamic>),
        ),
      );
    }

    if (questions.isNotEmpty) {
      // Shuffle the questions
      questions.shuffle();
      // Start with the first question
      setState(() {
        currentQuestionIndex = 0;
        userHasSelectedAnswer = false;
      });
    }
  }

  void _recordUserAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });

    final CauHoi currentQuestion = questions[currentQuestionIndex];

    Map<String, dynamic> userAnswer = {
      'question_id': currentQuestion.id,
      'user_answer': selectedAnswer,
    };

    userAnswers.add(userAnswer);
  }

  void _navigateToNextQuestion() {
    if (selectedAnswer != null) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer =
            null; // Reset selected answer when moving to the next question
        userHasSelectedAnswer = false;
      });
    }
  }

  void _navigateToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
        selectedAnswer =
            null; // Reset selected answer when moving to the previous question
        userHasSelectedAnswer = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          title: Text(
            'Câu hỏi trắc nghiệm',
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
        body: Center(
          child: CircularProgressIndicator(), // Show loading indicator
        ),
      );
    }

    if (currentQuestionIndex >= questions.length) {
      return ResultScreen(
        userAnswers: userAnswers,
        questions: questions,
      );
    }

    final CauHoi currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: Text(
          'Câu hỏi trắc nghiệm',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${currentQuestion.noiDung}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold, // Make the text bold
                fontFamily: 'Manrope', // Set your preferred font family
              ),
            ),
          ),
          RadioListTile(
            title: Text(currentQuestion.dapAnA),
            value: 'A',
            groupValue: selectedAnswer,
            onChanged: (value) {
              _recordUserAnswer('A');
            },
          ),
          RadioListTile(
            title: Text(currentQuestion.dapAnB),
            value: 'B',
            groupValue: selectedAnswer,
            onChanged: (value) {
              _recordUserAnswer('B');
            },
          ),
          RadioListTile(
            title: Text(currentQuestion.dapAnC),
            value: 'C',
            groupValue: selectedAnswer,
            onChanged: (value) {
              _recordUserAnswer('C');
            },
          ),
          RadioListTile(
            title: Text(currentQuestion.dapAnD),
            value: 'D',
            groupValue: selectedAnswer,
            onChanged: (value) {
              _recordUserAnswer('D');
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (currentQuestionIndex >
                  0) // Show "Câu hỏi trước" only if not the first question
                ElevatedButton(
                  onPressed: () {
                    _navigateToPreviousQuestion();
                  },
                  child: Text('Câu hỏi trước'),
                ),
              ElevatedButton(
                onPressed: () {
                  _navigateToNextQuestion();
                },
                child: Text('Câu hỏi tiếp theo'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
