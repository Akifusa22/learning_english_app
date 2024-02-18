class UserAnswers {
  final String question;
  final String answer;
  final bool isCorrect;

  const UserAnswers({
    required this.question,
    required this.answer,
    required this.isCorrect,
  });
}
List<UserAnswers> userAnswers = [];