import 'package:flutter/material.dart';
import 'package:edu_pro/model/questions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewScreen extends StatelessWidget {
  final String userEmail;

  ReviewScreen({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    if (userEmail.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Review Results'),
        ),
        body: Center(
          child: Text('Invalid user email.'),
        ),
      );
    }
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('quiz_results')
          .doc(userEmail)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(255, 255, 255, 1),
              title: Text(
                'Xem kết quả',
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
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(255, 255, 255, 1),
              title: Text(
                'Xem kết quả',
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
              child: Text('No results found for the user.'),
            ),
          );
        }

        final Map<String, dynamic> resultData =
            snapshot.data!.data() as Map<String, dynamic>;
        final int correctedAnswers = resultData['correctAnswers'] ?? 0;
        final int totalQuestions = resultData['totalQuestions'] ?? 0;
        final List<Map<String, dynamic>> userAnswers =
            (resultData['answeredQuestions'] as List<dynamic>)
                .map((answer) => Map<String, dynamic>.from(answer))
                .toList();

        // Assuming you have a 'questions' collection in Firestore
        return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('cau_hoi').get(),
          builder: (context, questionsSnapshot) {
            if (questionsSnapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                  title: Text(
                    'Xem kết quả',
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
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (!questionsSnapshot.hasData ||
                questionsSnapshot.data!.docs.isEmpty) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                  title: Text(
                    'Xem kết quả',
                    style: TextStyle(
                      fontSize: 21,
                      color: Color.fromARGB(255, 54, 30, 171),
                    ),
                  ),
                  centerTitle: true,
                  elevation: 7,
                  iconTheme: IconThemeData(color: Colors.black),
                  actionsIconTheme: IconThemeData(color: Colors.black),
                ),
                body: Center(
                  child: Text('No questions found.'),
                ),
              );
            }

            // Populate questions based on the data from Firestore
            final List<CauHoi> questions = questionsSnapshot.data!.docs
                .map(
                    (doc) => CauHoi.fromMap(doc.data() as Map<String, dynamic>))
                .toList();

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                title: Text(
                  '$correctedAnswers / $totalQuestions',
                  style: TextStyle(
                    fontSize: 21,
                    color: Color.fromARGB(255, 54, 30, 171),
                  ),
                ),
                centerTitle: true,
                elevation: 7,
                iconTheme: IconThemeData(color: Colors.black),
                actionsIconTheme: IconThemeData(color: Colors.black),
              ),
              body: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final CauHoi question = questions[index];
                  final String selectedAnswer =
                      userAnswers[index]['user_answer'].toString();
                  final bool isCorrect = selectedAnswer == question.dapAnDung;

                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Câu hỏi ${index + 1}:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            question.noiDung,
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'A: ${question.dapAnA}',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            'B: ${question.dapAnB}',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            'C: ${question.dapAnC}',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            'D: ${question.dapAnD}',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Đáp án đúng: ${question.dapAnDung}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Đáp án bạn chọn: $selectedAnswer',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isCorrect ? Colors.green : Colors.red,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Giải thích: ${question.giaiThich}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isCorrect ? Colors.green : Colors.red,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Dịch nghĩa: ${question.dichNghia}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isCorrect ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

Widget _buildAnswerText(String answerLabel, String answer,
    String selectedAnswer, String correctAnswer) {
  final bool isCorrectAnswer =
      selectedAnswer.trim().toLowerCase() == correctAnswer.trim().toLowerCase();
  final bool isSelectedAnswer =
      selectedAnswer.trim().toLowerCase() == answer.trim().toLowerCase();

  Color textColor;

  if (isSelectedAnswer && isCorrectAnswer) {
    textColor = Colors.green; // User selected correct answer
  } else if (isSelectedAnswer && !isCorrectAnswer) {
    textColor = Colors.red; // User selected incorrect answer
  } else {
    textColor = Colors.black; // Default color
  }

  return Text(
    '$answerLabel: $answer',
    style: TextStyle(
      fontSize: 16.0,
      color: textColor,
    ),
  );
}
