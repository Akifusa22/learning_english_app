import 'package:edu_pro/screens/components/result2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizScreen2 extends StatefulWidget {
  @override
  _QuizScreen2State createState() => _QuizScreen2State();
}

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserAnswerAndResult({
    required String userEmail,
    required List<Map<String, dynamic>> userAnswers,
    required int correctAnswers,
    required int totalQuestions,
  }) async {
    try {
      User? user = _auth.currentUser;
      String? userEmail = FirebaseAuth.instance.currentUser?.email;
      if (user != null) {
        // Document path for the user

        // Save user's answers to the document
        final FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Collection reference for storing quiz results
        CollectionReference quizResults = firestore.collection('quiz_results2');

        // Use user's email as the document ID
        DocumentReference userDocument = quizResults.doc(userEmail);

        // Set data in the document
        await userDocument.set({
          'userEmail': userEmail,
          'userAnswers': userAnswers,
          'correctAnswers': correctAnswers,
          'totalQuestions': totalQuestions,
        });
      }
    } catch (e) {
      print('Error saving user answers and result: $e');
    }
  }
}

class _QuizScreen2State extends State<QuizScreen2> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  List<String> shuffledParts = [];
  List<String> originalOrder = [];
  bool isCorrect = false;
  TextEditingController textFieldController = TextEditingController();
  FlutterTts flutterTts = FlutterTts();
  String? currentUserId;
  bool _isButtonDisabled = false; // Biến trạng thái nút
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _getCurrentUser();
  }

  void _loadQuestions() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('questions').get();
    final List<QueryDocumentSnapshot> documents = snapshot.docs;

    if (documents.isNotEmpty) {
      setState(() {
        questions =
            documents.map((doc) => doc.data() as Map<String, dynamic>).toList();
        currentQuestionIndex = 0;
        _loadCurrentQuestion();
      });
    }
  }

  void _loadCurrentQuestion() {
    shuffledParts =
        List<String>.from(questions[currentQuestionIndex]['shuffledParts']);
    originalOrder =
        List<String>.from(questions[currentQuestionIndex]['originalOrder']);
    isCorrect = false;
    textFieldController
        .clear(); // Xóa nội dung trong ô văn bản khi chuyển đến câu hỏi mới
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  void _getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    }
  }

  void _checkAnswerAndShowSnackBar() {
    String userAnswer = textFieldController.text;
    if (userAnswer.trim().isEmpty) {
      setState(() {
        errorMessage = 'Vui lòng nhập câu trả lời của bạn.';
      });
      return;
    }

    setState(() {
      errorMessage = null;
    });

    questions[currentQuestionIndex]['userAnswer'] = userAnswer;

    String resultText;
    String trailingText;

    if (userAnswer == originalOrder.join(' ')) {
      resultText = 'Đúng! ';
      trailingText = userAnswer;
    } else {
      resultText = 'Sai! ';
      trailingText = originalOrder.join(' ');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 700),
        content: Row(
          children: [
            Text('$resultText: $trailingText'),
            SizedBox(width: 8),
            Icon(
                userAnswer == originalOrder.join(' ')
                    ? Icons.check
                    : Icons.close,
                color: Colors.white),
          ],
        ),
        backgroundColor:
            userAnswer == originalOrder.join(' ') ? Colors.green : Colors.red,
      ),
    );

    _speak(userAnswer == originalOrder.join(' ')
        ? userAnswer
        : originalOrder.join(' '));

    setState(() {
      _isButtonDisabled = true;
    });

    Future.delayed(Duration(seconds: 1), () {
      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          _loadCurrentQuestion();
          _isButtonDisabled = false;
        });
      } else {
        _navigateToResultScreen();
      }
    });
  }

  void _navigateToResultScreen() {
    final FirestoreService firestoreService = FirestoreService();
    // Gọi phương thức để lưu thông tin người dùng khi chuyển đến màn hình kết quả
    firestoreService.saveUserAnswerAndResult(
      userEmail: currentUserId ?? '',
      userAnswers: questions,
      correctAnswers: _calculateCorrectAnswers(),
      totalQuestions: questions.length,
    );

    // Chuyển hướng đến màn hình kết quả
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen2(
          correctAnswers: _calculateCorrectAnswers(),
          totalQuestions: questions.length,
        ),
      ),
    );
  }

  int _calculateCorrectAnswers() {
    int correctAnswers = 0;
    for (Map<String, dynamic> question in questions) {
      // Kiểm tra đáp án đúng tại đây
      if (question['userAnswer'] == question['originalOrder'].join(' ')) {
        correctAnswers++;
      }
    }
    return correctAnswers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: Text(
          'Trò chơi sắp xếp từ',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Sắp xếp các từ",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 36),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: shuffledParts.map((part) {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    part,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 66),
            TextField(
              controller: textFieldController,
              decoration: InputDecoration(
                labelText: 'Nhập câu trả lời của bạn',
                border: OutlineInputBorder(),
              ),
            ),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 38),
            ElevatedButton(
              onPressed: _isButtonDisabled ? null : _checkAnswerAndShowSnackBar,
              child: Text(
                'Câu hỏi kế tiếp',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
