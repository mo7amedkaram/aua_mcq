import 'package:get/get.dart';

import '../../Model/database_model.dart';
import '../../local database/database.dart';

class FavouriteQuestionController extends GetxController {
  var questions = <Question>[].obs;
  final DatabaseManager dbManager = DatabaseManager();
  var answersState = <int, Map<int, bool>>{}.obs;
  @override
  void onInit() {
    super.onInit();
    loadQuestions();
  }

  void showCorrectAnswer(int questionId) {
    var question =
        questions.firstWhere((q) => q.id == questionId, orElse: () => null!);
    if (question != null) {
      var correctAnswer = question.answer;

      // This assumes your options are 1-indexed. Adjust if they are 0-indexed.
      answersState[questionId] = {correctAnswer: true};
    }

    questions.refresh(); // Refresh the observable to update UI
  }

  void resetFavorites() {
    // Iterate through all questions and reset their state
    for (var question in questions) {
      answersState[question.id] = {};
    }
    // Trigger a UI refresh
    answersState.refresh();
  }

  void showAllCorrectAnswersInFavorites() {
    // Iterate through all questions and mark the correct answer
    for (var question in questions) {
      var correctAnswer = question.answer;
      // Assuming your options are 1-indexed. Adjust if they are 0-indexed.
      answersState[question.id] = {correctAnswer: true};
    }
    // Trigger a UI refresh
    answersState.refresh();
  }

  void loadQuestions() async {
    var dbManager = DatabaseManager();
    var loadedQuestions = await dbManager.getQuestions();
    questions.assignAll(loadedQuestions);
  }

  // إضافة وظائف لإضافة، تحديث، وحذف الأسئلة
  void addQuestion(
      String title, List<dynamic> options, int answer, int id) async {
    Question newQuestion = Question(
        questionTitle: title, options: options, answer: answer, id: id);
    await dbManager.insertQuestion(newQuestion);
    questions.add(newQuestion);
  }

  // حذف السؤال
  void deleteQuestion(int id) async {
    await dbManager.deleteQuestion(id);
    questions.removeWhere((question) => question.id == id);
  }

  //-----------------------

  void checkAnswer(int questionId, int selectedOptionIndex) async {
    var question = questions.firstWhere((q) => q.id == questionId);
    var correctAnswer = question.answer;

    answersState[questionId] = (answersState[questionId] ?? {});
    answersState[questionId]![selectedOptionIndex] =
        correctAnswer == selectedOptionIndex;

    questions.refresh();
  }
}
