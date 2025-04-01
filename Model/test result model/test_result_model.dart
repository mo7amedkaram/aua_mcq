import 'package:aua_questions_app/Model/Question%20Model/question_model.dart';

class TestResult {
  final List<QuestionModel> questions;
  final Map<String, String> userAnswers;
  final int correctAnswers;
  final int wrongAnswers;
  final double percentage;
  final int timeSpent; // in seconds

  TestResult({
    required this.questions,
    required this.userAnswers,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.percentage,
    required this.timeSpent,
  });
}
