import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/Question Model/question_model.dart';
import '../../Model/local question model/local_question_model.dart';
import '../../constants/colors.dart';
import '../../database/database.dart';
import '../../database/local_data_base_service.dart';

class QuestionsController extends GetxController {
  final DatabaseService _databaseService = Get.find<DatabaseService>();
  final LocalDatabaseService _localDatabaseService =
      Get.put(LocalDatabaseService());

  final RxBool isLoading = false.obs;
  final RxList<QuestionModel> questions = <QuestionModel>[].obs;

  // Store the colors of option buttons for each question
  final RxMap<String, List<Color>> buttonColors = <String, List<Color>>{}.obs;

  // Constants for button colors
  final Color defaultButtonColor = AppColors.primary;
  final Color correctAnswerColor = AppColors.success;
  final Color wrongAnswerColor = AppColors.error;

  // Track last viewed question
  final RxInt lastQuestionIndex = 0.obs;

  final String subjectId;

  QuestionsController({required this.subjectId});

  @override
  void onInit() {
    super.onInit();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      isLoading.value = true;
      final fetchedQuestions = await _databaseService.getQuestions(subjectId);
      questions.assignAll(fetchedQuestions);

      // Initialize button colors for each question
      for (var question in questions) {
        if (!buttonColors.containsKey(question.id)) {
          buttonColors[question.id!] =
              List.filled(question.options!.length, defaultButtonColor);
        }
      }

      // Load saved button colors from preferences
      loadButtonColors();

      // Load last viewed question
      loadLastQuestionIndex();
    } catch (e) {
      print('Error fetching questions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Handle answer selection
  void selectAnswer(String questionId, int optionIndex) {
    final question = questions.firstWhere((q) => q.id == questionId);
    final correctOptionIndex =
        question.answer! - 1; // Convert to zero-based index

    // Reset colors for this question
    buttonColors[questionId] =
        List.filled(question.options!.length, defaultButtonColor);

    // Set color based on whether the answer is correct
    if (optionIndex == correctOptionIndex) {
      buttonColors[questionId]![optionIndex] = correctAnswerColor;
    } else {
      buttonColors[questionId]![optionIndex] = wrongAnswerColor;
    }

    // Save the button colors
    saveButtonColors();

    // Update the last viewed question index
    lastQuestionIndex.value = questions.indexWhere((q) => q.id == questionId);
    saveLastQuestionIndex();
  }

  // Reset all answers
  void resetAnswers() {
    for (var question in questions) {
      buttonColors[question.id!] =
          List.filled(question.options!.length, defaultButtonColor);
    }
    saveButtonColors();
  }

  // Show all correct answers
  void showAllCorrectAnswers() {
    for (var question in questions) {
      final correctOptionIndex = question.answer! - 1;

      // Reset colors for this question
      buttonColors[question.id!] =
          List.filled(question.options!.length, defaultButtonColor);

      // Set the correct answer
      buttonColors[question.id!]![correctOptionIndex] = correctAnswerColor;
    }
    saveButtonColors();
  }

  // Show only correct answer for a specific question
  void showCorrectAnswer(String questionId) {
    final question = questions.firstWhere((q) => q.id == questionId);
    final correctOptionIndex = question.answer! - 1;

    // Reset colors for this question
    buttonColors[questionId] =
        List.filled(question.options!.length, defaultButtonColor);

    // Set the correct answer
    buttonColors[questionId]![correctOptionIndex] = correctAnswerColor;

    saveButtonColors();
  }

  // Add question to favorites
  Future<bool> addToFavorites(QuestionModel question) async {
    try {
      final isAlreadyFavorite =
          await _localDatabaseService.questionExists(question.questionTitle!);

      if (isAlreadyFavorite) {
        return false;
      }

      // Create a random ID for local storage
      final randomId = DateTime.now().millisecondsSinceEpoch % 10000;

      final localQuestion = LocalQuestion(
        id: randomId,
        questionTitle: question.questionTitle!,
        options: question.options!,
        answer: question.answer!,
      );

      await _localDatabaseService.addQuestion(localQuestion);
      return true;
    } catch (e) {
      print('Error adding to favorites: $e');
      return false;
    }
  }

  // Report wrong question
  Future<bool> reportWrongAnswer({
    required String questionId,
    required String questionTitle,
    required String description,
  }) async {
    return await _databaseService.reportWrongAnswer(
      questionId: questionId,
      questionTitle: questionTitle,
      description: description,
    );
  }

  // Save and load button colors from preferences
  Future<void> saveButtonColors() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> colorsData = {};

      buttonColors.forEach((questionId, colors) {
        colorsData[questionId] = colors.map((c) => c.value.toString()).toList();
      });

      await prefs.setString('buttonColors_$subjectId', colorsData.toString());
    } catch (e) {
      print('Error saving button colors: $e');
    }
  }

  Future<void> loadButtonColors() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? colorsData = prefs.getString('buttonColors_$subjectId');

      if (colorsData != null && colorsData.isNotEmpty) {
        // Parse the string data and restore button colors
        // This is simplified - you'll need proper parsing logic to convert the string back to a map
      }
    } catch (e) {
      print('Error loading button colors: $e');
    }
  }

  // Save and load last question index
  Future<void> saveLastQuestionIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
          'lastQuestionIndex_$subjectId', lastQuestionIndex.value);
    } catch (e) {
      print('Error saving last question index: $e');
    }
  }

  Future<void> loadLastQuestionIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final int? index = prefs.getInt('lastQuestionIndex_$subjectId');

      if (index != null && index >= 0 && index < questions.length) {
        lastQuestionIndex.value = index;
      }
    } catch (e) {
      print('Error loading last question index: $e');
    }
  }
}
