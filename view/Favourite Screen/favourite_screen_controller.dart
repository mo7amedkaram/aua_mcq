// File: lib/features/favorites/controllers/favorites_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Model/local question model/local_question_model.dart';
import '../../constants/colors.dart';
import '../../database/local_data_base_service.dart';

class FavoritesController extends GetxController {
  final LocalDatabaseService _localDatabaseService =
      Get.find<LocalDatabaseService>();

  final RxBool isLoading = false.obs;
  final RxList<LocalQuestion> questions = <LocalQuestion>[].obs;

  // Map to track the state of answers for each question
  final RxMap<int, Map<int, bool>> answersState = <int, Map<int, bool>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    try {
      isLoading.value = true;
      final loadedQuestions = await _localDatabaseService.getAllQuestions();
      questions.assignAll(loadedQuestions);
    } catch (e) {
      print('Error loading favorites: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Delete a question from favorites
  Future<void> deleteQuestion(int id) async {
    try {
      await _localDatabaseService.deleteQuestion(id);
      questions.removeWhere((question) => question.id == id);
    } catch (e) {
      print('Error deleting question: $e');
    }
  }

  // Reset all answers in favorites
  void resetFavorites() {
    answersState.clear();
    update();
  }

  // Show the correct answer for a specific question
  void showCorrectAnswer(int questionId) {
    final question = questions.firstWhere((q) => q.id == questionId);
    final correctAnswer = question.answer;

    // Create or update the answer state for this question
    answersState[questionId] = {correctAnswer: true};
    update();
  }

  // Show all correct answers in favorites
  void showAllCorrectAnswers() {
    for (var question in questions) {
      answersState[question.id] = {question.answer: true};
    }
    update();
  }

  // Check user answer for a question
  void checkAnswer(int questionId, int selectedOptionIndex) {
    final question = questions.firstWhere((q) => q.id == questionId);
    final correctAnswer = question.answer;

    // Initialize the state map for this question if it doesn't exist
    if (!answersState.containsKey(questionId)) {
      answersState[questionId] = {};
    }

    // Record whether the selected option is correct
    answersState[questionId]![selectedOptionIndex] =
        (correctAnswer == selectedOptionIndex);
    update();
  }

  // Get button color for an option
  Color getButtonColor(int questionId, int optionIndex) {
    // If this question has no answer state or this option hasn't been selected
    if (!answersState.containsKey(questionId) ||
        !answersState[questionId]!.containsKey(optionIndex)) {
      return AppColors.primary;
    }

    // Return green for correct answers, red for incorrect ones
    return answersState[questionId]![optionIndex]!
        ? AppColors.success
        : AppColors.error;
  }
}
