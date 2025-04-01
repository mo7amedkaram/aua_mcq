import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../Model/Question Model/question_model.dart';
import '../Questions Page/question_controller.dart';

class QuestionCard extends StatelessWidget {
  final QuestionModel question;
  final int index;
  final List<Color> buttonColors;
  final Function(String, int) onAnswerSelected;
  final VoidCallback onFavoritePressed;
  final VoidCallback onShowCorrectAnswerPressed;

  const QuestionCard({
    required this.question,
    required this.index,
    required this.buttonColors,
    required this.onAnswerSelected,
    required this.onFavoritePressed,
    required this.onShowCorrectAnswerPressed,
    super.key,
  });

  void _copyQuestionToClipboard(BuildContext context) {
    String textToCopy = "${index + 1}) ${question.questionTitle}\n";

    for (int i = 0; i < question.options!.length; i++) {
      textToCopy +=
          "${i + 1}. ${question.options![i]}${i == question.answer! - 1 ? ' (correct)' : ''}\n";
    }

    Clipboard.setData(ClipboardData(text: textToCopy)).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Question copied to clipboard"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void _showReportDialog(BuildContext context) {
    final TextEditingController descriptionController = TextEditingController();
    final QuestionsController controller = Get.find<QuestionsController>();

    Get.defaultDialog(
      title: "Report a Problem",
      content: Column(
        children: [
          Text(
            "Is there an issue with this question?",
            style: TextStyle(fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.sp),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              hintText: "Describe the issue...",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12.sp),
            ),
            maxLines: 3,
          ),
        ],
      ),
      textConfirm: "Submit",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (descriptionController.text.trim().isEmpty) {
          Get.snackbar("error", "Please describe the issue");

          return;
        }

        controller
            .reportWrongAnswer(
          questionId: question.id!,
          questionTitle: question.questionTitle!,
          description: descriptionController.text.trim(),
        )
            .then((success) {
          if (success) {
            Get.snackbar("done", "Report submitted successfully");
          } else {
            Get.snackbar("error", "Failed to submit report");
          }
        });

        Get.back();
      },
    );
  }

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
            // Question title and favorite button
            Row(
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
                    Icons.favorite_border,
                    color: Colors.red,
                    size: 28.sp,
                  ),
                  onPressed: onFavoritePressed,
                ),
              ],
            ),

            SizedBox(height: 16.sp),

            // Options
            ...List.generate(
              question.options!.length,
              (optionIndex) => Container(
                margin: EdgeInsets.only(bottom: 10.sp),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => onAnswerSelected(question.id!, optionIndex),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColors[optionIndex],
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
                    question.options![optionIndex],
                    style: TextStyle(fontSize: 16.sp),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            // Action buttons
            Padding(
              padding: EdgeInsets.only(top: 8.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Copy button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _copyQuestionToClipboard(context),
                      borderRadius: BorderRadius.circular(25.sp),
                      child: Container(
                        padding: EdgeInsets.all(8.sp),
                        height: 50.sp,
                        width: 50.sp,
                        child: Lottie.asset(
                            "assets/animations/copy_animation.json"),
                      ),
                    ),
                  ),

                  // Report problem button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _showReportDialog(context),
                      borderRadius: BorderRadius.circular(25.sp),
                      child: Container(
                        padding: EdgeInsets.all(8.sp),
                        height: 50.sp,
                        width: 50.sp,
                        child: Lottie.asset(
                            "assets/animations/report_animation.json"),
                      ),
                    ),
                  ),

                  // Show correct answer button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onShowCorrectAnswerPressed,
                      borderRadius: BorderRadius.circular(25.sp),
                      child: Container(
                        padding: EdgeInsets.all(8.sp),
                        height: 50.sp,
                        width: 50.sp,
                        child: Lottie.asset(
                            "assets/animations/bulb_animation.json"),
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
