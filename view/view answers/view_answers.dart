import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Model/Question Model/question_model.dart';
import '../../constants/colors.dart';

class ViewAnswersScreen extends StatelessWidget {
  final List<QuestionModel> questions;
  final Map<String, String> selectedAnswers;

  const ViewAnswersScreen({
    required this.questions,
    required this.selectedAnswers,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: Text("View Answers"),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.sp),
            topRight: Radius.circular(32.sp),
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(16.sp),
          itemCount: questions.length,
          itemBuilder: (context, index) {
            final question = questions[index];
            final selectedAnswer = selectedAnswers[question.id];
            final correctAnswerIndex = question.answer! - 1;
            final correctAnswer = question.options![correctAnswerIndex];

            return Card(
              margin: EdgeInsets.only(bottom: 16.sp),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.sp),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question number and text
                    Text(
                      "Question ${index + 1}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 8.sp),
                    Text(
                      question.questionTitle!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.sp),

                    // Options
                    ...List.generate(
                      question.options!.length,
                      (optionIndex) {
                        final option = question.options![optionIndex];
                        final isCorrect = option == correctAnswer;
                        final isSelected = option == selectedAnswer;

                        Color backgroundColor;
                        Color textColor = Colors.black;

                        if (isCorrect) {
                          backgroundColor = AppColors.success.withOpacity(0.2);
                          textColor = AppColors.success;
                        } else if (isSelected && !isCorrect) {
                          backgroundColor = AppColors.error.withOpacity(0.2);
                          textColor = AppColors.error;
                        } else {
                          backgroundColor = Colors.grey.shade100;
                        }

                        return Container(
                          margin: EdgeInsets.only(bottom: 8.sp),
                          padding: EdgeInsets.all(12.sp),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(8.sp),
                            border: Border.all(
                              color: isSelected || isCorrect
                                  ? (isCorrect
                                      ? AppColors.success
                                      : AppColors.error)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Option marker
                              Container(
                                width: 24.sp,
                                height: 24.sp,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected || isCorrect
                                      ? (isCorrect
                                          ? AppColors.success
                                          : AppColors.error)
                                      : Colors.grey.shade400,
                                ),
                                child: Center(
                                  child: Icon(
                                    isCorrect
                                        ? Icons.check
                                        : (isSelected ? Icons.close : null),
                                    color: Colors.white,
                                    size: 16.sp,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.sp),

                              // Option text
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: isSelected || isCorrect
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // Result indicator
                    SizedBox(height: 8.sp),
                    Row(
                      children: [
                        Icon(
                          selectedAnswer == correctAnswer
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: selectedAnswer == correctAnswer
                              ? AppColors.success
                              : AppColors.error,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.sp),
                        Text(
                          selectedAnswer == correctAnswer
                              ? "Correct"
                              : "Incorrect",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: selectedAnswer == correctAnswer
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
