// File: lib/features/favorites/widgets/favorite_question_card.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../Model/local question model/local_question_model.dart';
import '../../constants/colors.dart'; // Use the consolidated model

class FavoriteQuestionCard extends StatelessWidget {
  final LocalQuestion question;
  final int index;
  final Map<int, bool>? answerState;
  final Function(int, int) onOptionPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onCopyPressed;
  final VoidCallback onShowCorrectAnswerPressed;

  const FavoriteQuestionCard({
    required this.question,
    required this.index,
    required this.answerState,
    required this.onOptionPressed,
    required this.onDeletePressed,
    required this.onCopyPressed,
    required this.onShowCorrectAnswerPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(12.sp),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.sp),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question title and delete button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "${index + 1}) ${question.questionTitle}",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 28.sp,
                  ),
                  onPressed: onDeletePressed,
                ),
              ],
            ),

            SizedBox(height: 16.sp),

            // Options
            Column(
              children: List.generate(
                question.options.length,
                (optionIndex) {
                  // Determine button state
                  final isSelected =
                      answerState?.containsKey(optionIndex + 1) ?? false;
                  final isCorrect =
                      isSelected ? answerState![optionIndex + 1] : null;

                  // Determine button color
                  Color buttonColor = AppColors.primary;
                  if (isSelected) {
                    buttonColor =
                        isCorrect! ? AppColors.success : AppColors.error;
                  }

                  return Container(
                    margin: EdgeInsets.only(bottom: 10.sp),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          onOptionPressed(question.id, optionIndex + 1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 12.sp,
                          horizontal: 16.sp,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.sp),
                        ),
                      ),
                      child: Text(
                        question.options[optionIndex],
                        style: TextStyle(fontSize: 16.sp),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Action buttons
            Padding(
              padding: EdgeInsets.only(top: 8.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Copy button
                  _buildActionButton(
                    onTap: onCopyPressed,
                    assetPath: "assets/animations/copy_animation.json",
                  ),

                  // Show correct answer button
                  _buildActionButton(
                    onTap: onShowCorrectAnswerPressed,
                    assetPath: "assets/animations/bulb_animation.json",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      {required VoidCallback onTap, required String assetPath}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25.sp),
        child: Container(
          padding: EdgeInsets.all(8.sp),
          height: 50.sp,
          width: 50.sp,
          child: Lottie.asset(assetPath),
        ),
      ),
    );
  }
}
