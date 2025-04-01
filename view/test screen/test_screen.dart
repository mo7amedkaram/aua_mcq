import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../result screen/result_screen.dart';
import 'test_controller.dart';

class TestScreen extends StatefulWidget {
  final String subjectId;
  final int numberOfQuestions;
  final int timeInMinutes;

  const TestScreen({
    required this.subjectId,
    required this.numberOfQuestions,
    required this.timeInMinutes,
    super.key,
  });

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late final TestScreenController _controller;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _controller = Get.put(TestScreenController(
      subjectId: widget.subjectId,
      numberOfQuestions: widget.numberOfQuestions,
      timeInMinutes: widget.timeInMinutes,
    ));
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          title: Obx(() => Text("Test (${_controller.getFormattedTime()})")),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 16.sp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.sp),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 4.sp),
              child: Obx(() => Text(
                    "${_controller.currentQuestionIndex.value + 1}/${_controller.questions.length}",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
          ],
        ),
        body: Obx(() {
          if (_controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          if (_controller.questions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16.sp),
                  Text(
                    "No questions available for this test",
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.sp),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: Text("Go Back"),
                  ),
                ],
              ),
            );
          }

          return Column(
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
                    itemCount: _controller.questions.length,
                    onPageChanged: (index) {
                      _controller.currentQuestionIndex.value = index;
                    },
                    itemBuilder: (context, index) {
                      final question = _controller.questions[index];
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
                                    _controller.selectedAnswers[question.id] ==
                                        option;

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
                                    groupValue: _controller
                                        .selectedAnswers[question.id],
                                    activeColor: AppColors.primary,
                                    onChanged: (value) {
                                      if (value != null) {
                                        _controller.selectAnswer(
                                            question.id!, value);
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
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          final currentQuestionId = _controller
                              .questions[_controller.currentQuestionIndex.value]
                              .id;
                          if (!_controller
                              .isAnswerSelected(currentQuestionId!)) {
                            Get.snackbar(
                              "error",
                              "Please select an answer before proceeding",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );

                            return;
                          }

                          if (_controller.currentQuestionIndex.value <
                              _controller.questions.length - 1) {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _showFinishDialog();
                          }
                        },
                        child: Container(
                          color: AppColors.primary,
                          alignment: Alignment.center,
                          child: Obx(() => Text(
                                _controller.currentQuestionIndex.value <
                                        _controller.questions.length - 1
                                    ? "Next"
                                    : "Finish",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Finish Test"),
        content: Text(
            "Are you sure you want to submit your answers and finish the test?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Review Answers"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _finishTest();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text("Submit"),
          ),
        ],
      ),
    );
  }

  void _finishTest() {
    // Calculate results
    int correct = 0;
    int wrong = 0;

    for (var question in _controller.questions) {
      final selectedAnswer = _controller.selectedAnswers[question.id];
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
    }

    // Navigate to results screen
    Get.off(() => ResultScreen(
          correctAnswers: correct,
          wrongAnswers: wrong,
          totalQuestions: _controller.questions.length,
          questions: _controller.questions,
          selectedAnswers: _controller.selectedAnswers,
        ));
  }
}
