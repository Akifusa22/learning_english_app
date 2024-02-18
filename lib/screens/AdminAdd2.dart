import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAdd2 extends StatefulWidget {
  @override
  _AdminAdd2State createState() => _AdminAdd2State();
}

class _AdminAdd2State extends State<AdminAdd2> {
  TextEditingController originalQuestionController = TextEditingController();
  TextEditingController idController =
      TextEditingController(); // New controller for ID
  List<TextEditingController> partControllers = [];

  // List to store shuffled parts for display
  List<String> shuffledParts = [];

  // Hàm để thêm câu hỏi vào Firestore
  void addQuestion() async {
    String originalQuestion = originalQuestionController.text;
    String id = idController.text; // Retrieve ID from the new TextField

    // Tạo một mảng với các phần của câu hỏi được cắt ngẫu nhiên và đảo vị trí
    shuffledParts = _shuffleAndSliceString(originalQuestion);

    // Tạo một danh sách giữ nguyên thứ tự của từng phần
    List<String> originalOrder = originalQuestion.split(' ');

    try {
      await FirebaseFirestore.instance.collection('questions').doc(id).set({
        'type': 'connect',
        'originalQuestion': originalQuestion,
        'shuffledParts': shuffledParts,
        'originalOrder': originalOrder,
        'id': id, // Include ID in the data
      });

      // Hiển thị mảng các phần đã được đảo vị trí cho người dùng nhập đúng
      if (shuffledParts.length == partControllers.length) {
        partControllers.asMap().forEach((index, controller) {
          controller.text = shuffledParts[index];
        });

        // Display a success message using a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đổi vị trí từ và thêm vào cơ sở dữ liệu thành công'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print(
            'Error: The number of shuffled parts does not match the number of controllers.');
      }

      // Sau khi thêm câu hỏi, xóa nội dung của các trường nhập liệu
      originalQuestionController.clear();
      idController.clear(); // Clear ID TextField
    } catch (error) {
      print('Error adding question: $error');
    }
  }

  List<String> _shuffleAndSliceString(String originalString) {
    List<String> parts = originalString.split(' ');

    // Đảo vị trí các từ ngẫu nhiên
    parts.shuffle();

    // Đảm bảo rằng số lượng phần không vượt quá số lượng từ trong câu hỏi
    int numParts = parts.length;

    // Nếu số lượng từ ít hơn số lượng phần, thêm từ trắng để có số lượng phần tương ứng
    while (parts.length < numParts) {
      parts.add('');
    }

    // Initialize partControllers based on the length of shuffledParts
    partControllers = List.generate(numParts, (_) => TextEditingController());

    return parts.sublist(
        0, numParts); // Trả về toàn bộ danh sách các từ đã được đảo vị trí
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm câu hỏi nối từ'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: idController, // New TextField for ID
                decoration: InputDecoration(labelText: 'Nhập ID'),
              ),
              TextField(
                controller: originalQuestionController,
                decoration: InputDecoration(labelText: 'Nhập câu hỏi gốc'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: addQuestion,
                child: Text('Thêm câu hỏi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
