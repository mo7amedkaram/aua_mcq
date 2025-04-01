import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../Model/Question Model/question_model.dart';
import '../../constants/colors.dart';
import '../result screen/result_screen.dart';

class ReopenTestScreen extends StatefulWidget {
  final List<QuestionModel> questions;
  final int totalQuestions;

  const ReopenTestScreen({
    required this.questions,
    required this.totalQuestions,
    super.key,
  });

  @override
  State<ReopenTestScreen> createState() => _ReopenTestScreenState();
}

class _ReopenTestScreenState extends State<ReopenTestScreen> {
  late final PageController _pageController;
  final Map<String, String> _selectedAnswers = {};
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Exit Test"),
        content:
            Text("Are you sure you want to exit? Your progress will be lost."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Yes"),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void _nextQuestion() {
    final currentQuestion = widget.questions[_currentQuestionIndex];

    // Check if user selected an answer for current question
    if (!_selectedAnswers.containsKey(currentQuestion.id)) {
      Get.snackbar(
        "Note",
        "Please select an answer before proceeding",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      return;
    }

    if (_currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishTest();
    }
  }

  void _finishTest() {
    // Calculate results
    int correct = 0;
    int wrong = 0;

    for (var question in widget.questions) {
      if (_selectedAnswers.containsKey(question.id)) {
        final selectedAnswer = _selectedAnswers[question.id]!;
        final selectedIndex = question.options!.indexOf(selectedAnswer);

        if (selectedIndex + 1 == question.answer) {
          correct++;
        } else {
          wrong++;
        }
      } else {
        wrong++; // Count unanswered questions as wrong
      }
    }

    // Navigate to results screen
    Get.off(() => ResultScreen(
          correctAnswers: correct,
          wrongAnswers: wrong,
          totalQuestions: widget.totalQuestions,
          questions: widget.questions,
          selectedAnswers: _selectedAnswers,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          title: Text("Retake Test"),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.sp),
                    topRight: Radius.circular(32.sp),
                  ),
                ),
                child: PageView.builder(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.questions.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentQuestionIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final question = widget.questions[index];
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(24.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Question text
                          Container(
                            padding: EdgeInsets.all(16.sp),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8.sp),
                            ),
                            child: Text(
                              question.questionTitle!,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 24.sp),

                          // Options
                          ...List.generate(
                            question.options!.length,
                            (optionIndex) {
                              final option = question.options![optionIndex];
                              final isSelected =
                                  _selectedAnswers[question.id] == option;

                              return Container(
                                margin: EdgeInsets.only(bottom: 12.sp),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.grey.shade300,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8.sp),
                                ),
                                child: RadioListTile<String>(
                                  title: Text(
                                    option,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  value: option,
                                  groupValue: _selectedAnswers[question.id],
                                  activeColor: AppColors.primary,
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        _selectedAnswers[question.id!] = value;
                                      });
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // Navigation bar at the bottom
            Container(
              height: 60.sp,
              color: Colors.grey.shade200,
              child: Row(
                children: [
                  // Progress indicator
                  Container(
                    width: 100.sp,
                    height: 60.sp,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.sp),
                        bottomRight: Radius.circular(30.sp),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "${_currentQuestionIndex + 1}/${widget.questions.length}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),

                  Spacer(),

                  // Next/Finish button
                  Container(
                    width: 100.sp,
                    height: 60.sp,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.sp),
                        bottomLeft: Radius.circular(30.sp),
                      ),
                    ),
                    child: InkWell(
                      onTap: _nextQuestion,
                      child: Center(
                        child: Text(
                          _currentQuestionIndex < widget.questions.length - 1
                              ? "Next"
                              : "Finish",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
