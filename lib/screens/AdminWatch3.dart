import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminWatch3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theo dõi'),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('quiz_results').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No quiz results available.');
          }
          var quizResults = snapshot.data!.docs;
          return ListView.builder(
            itemCount: quizResults.length,
            itemBuilder: (context, index) {
              var result = quizResults[index].data();

              return Card(
                child: ListTile(
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${result['userEmail']}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Số đáp án đúng ${result['correctAnswers']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                      Text('Số lượng câu hỏi ${result['totalQuestions']}',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
