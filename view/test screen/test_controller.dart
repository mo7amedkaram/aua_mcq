import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';

import '../../Model/Question Model/question_model.dart';
import '../../database/database.dart';

class TestScreenController extends GetxController {
  final DatabaseService _databaseService = Get.find<DatabaseService>();

  final String subjectId;
  final int numberOfQuestions;
  final int timeInMinutes;

  TestScreenController({
    required this.subjectId,
    required this.numberOfQuestions,
    required this.timeInMinutes,
  });

  // State variables
  final RxBool isLoading = true.obs;
  final RxList<QuestionModel> questions = <QuestionModel>[].obs;
  final RxInt currentQuestionIndex = 0.obs;
  final RxMap<String, String> selectedAnswers = <String, String>{}.obs;

  // Timer variables
  late Timer _timer;
  final RxInt secondsRemaining = 0.obs;

  // Results
  final RxInt correctAnswers = 0.obs;
  final RxInt wrongAnswers = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadQuestions();
    startTimer();
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }

  Future<void> loadQuestions() async {
    try {
      isLoading.value = true;

      // Fetch all questions for the subject
      final allQuestions = await _databaseService.getQuestions(subjectId);

      if (allQuestions.isEmpty) {
        return;
      }

      // Randomize and limit to requested number
      allQuestions.shuffle(Random());
      final selectedQuestions = allQuestions.length <= numberOfQuestions
          ? allQuestions
          : allQuestions.sublist(0, numberOfQuestions);

      questions.assignAll(selectedQuestions);
    } catch (e) {
      print('Error loading test questions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void startTimer() {
    secondsRemaining.value = timeInMinutes * 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        _timer.cancel();
        finishTest();
      }
    });
  }

  void selectAnswer(String questionId, String answer) {
    selectedAnswers[questionId] = answer;
  }

  bool isAnswerSelected(String questionId) {
    return selectedAnswers.containsKey(questionId);
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
    } else {
      finishTest();
    }
  }

  void finishTest() {
    _timer.cancel();

    // Calculate results
    int correct = 0;
    int wrong = 0;

    questions.forEach((question) {
      final selectedAnswer = selectedAnswers[question.id];
      if (selectedAnswer != null) {
        final selectedIndex = question.options!.indexOf(selectedAnswer);
        if (selectedIndex + 1 == question.answer) {
          correct++;
        } else {
          wrong++;
        }
      } else {
        wrong++; // Count unanswered questions as wrong
      }
    });

    correctAnswers.value = correct;
    wrongAnswers.value = wrong;

    // Navigate to results screen
    Get.toNamed('/test_results', arguments: {
      'correctAnswers': correct,
      'wrongAnswers': wrong,
      'totalQuestions': questions.length,
      'questions': questions,
      'selectedAnswers': selectedAnswers,
    });
  }

  String getFormattedTime() {
    final minutes = (secondsRemaining.value / 60).floor();
    final seconds = secondsRemaining.value % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
