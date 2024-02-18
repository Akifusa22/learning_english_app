class Questions {
  final String id; // ID của câu hỏi
// Đáp án đúng
  final String originalOrder;
  final String originalQuestion;
  final String shuffledParts;
  String? userAnswer; //// User's answer
  bool get isCorrect => userAnswer == originalOrder;

  Questions({
    required this.id,
    required this.originalOrder,
    required this.originalQuestion,
    required this.shuffledParts,
    this.userAnswer,
  });

  factory Questions.fromMap(Map<String, dynamic> map) {
    return Questions(
      id: map['id'] ?? '',
      originalOrder: map['originalOrder'] ?? '',
      originalQuestion: map['originalQuestion'] ?? '',
      shuffledParts: map['shuffledParts'] ?? '',
      userAnswer: map['userAnswer'],
     
    );
  }
}
