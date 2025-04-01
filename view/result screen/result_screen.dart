import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../Model/Question Model/question_model.dart';
import '../../constants/colors.dart';
import '../reopen test/reopen_test.dart';
import '../view answers/view_answers.dart';

class ResultScreen extends StatelessWidget {
  final int correctAnswers;
  final int wrongAnswers;
  final int totalQuestions;
  final List<QuestionModel> questions;
  final Map<String, String> selectedAnswers;

  const ResultScreen({
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.totalQuestions,
    required this.questions,
    required this.selectedAnswers,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate percentage score
    final percentage = (correctAnswers / totalQuestions) * 100;

    return WillPopScope(
      onWillPop: () async {
        // Show a message instead of allowing back navigation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Use the buttons below to navigate"),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          title: Text("Test Results"),
          automaticallyImplyLeading: false,
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
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.sp),
                  child: Column(
                    children: [
                      // Results Card
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.sp),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.sp),
                          child: Column(
                            children: [
                              // Gauge chart
                              SizedBox(
                                height: 200.sp,
                                child: SfRadialGauge(
                                  axes: <RadialAxis>[
                                    RadialAxis(
                                      minimum: 0,
                                      maximum: 100,
                                      showLabels: false,
                                      showTicks: false,
                                      axisLineStyle: AxisLineStyle(
                                        thickness: 0.2,
                                        cornerStyle: CornerStyle.bothCurve,
                                        color:
                                            AppColors.primary.withOpacity(0.3),
                                        thicknessUnit: GaugeSizeUnit.factor,
                                      ),
                                      pointers: <GaugePointer>[
                                        RangePointer(
                                          value: percentage,
                                          width: 0.2,
                                          sizeUnit: GaugeSizeUnit.factor,
                                          cornerStyle: CornerStyle.bothCurve,
                                          color: _getScoreColor(percentage),
                                        ),
                                      ],
                                      annotations: <GaugeAnnotation>[
                                        GaugeAnnotation(
                                          widget: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "${percentage.toStringAsFixed(0)}%",
                                                style: TextStyle(
                                                  fontSize: 36.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: _getScoreColor(
                                                      percentage),
                                                ),
                                              ),
                                              Text(
                                                "Score",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          angle: 90,
                                          positionFactor: 0,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Score details
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 16.sp),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Correct answers
                                    _buildScoreDetail(
                                      title: "Correct",
                                      score: "$correctAnswers/$totalQuestions",
                                      color: AppColors.success,
                                    ),

                                    // Wrong answers
                                    _buildScoreDetail(
                                      title: "Wrong",
                                      score: "$wrongAnswers/$totalQuestions",
                                      color: AppColors.error,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 32.sp),

                      // Action buttons
                      Row(
                        children: [
                          // View answers button
                          Expanded(
                            child: _buildActionButton(
                              label: "View Answers",
                              icon: Icons.visibility,
                              color: AppColors.secondary,
                              onPressed: () {
                                Get.to(() => ViewAnswersScreen(
                                      questions: questions,
                                      selectedAnswers: selectedAnswers,
                                    ));
                              },
                            ),
                          ),
                          SizedBox(width: 16.sp),

                          // Retake test button
                          Expanded(
                            child: _buildActionButton(
                              label: "Retake Test",
                              icon: Icons.refresh,
                              color: AppColors.tertiary,
                              onPressed: () {
                                Get.off(() => ReopenTestScreen(
                                      questions: questions,
                                      totalQuestions: totalQuestions,
                                    ));
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.sp),

                      // Home button
                      _buildActionButton(
                        label: "Return to Home",
                        icon: Icons.home,
                        color: AppColors.primary,
                        textColor: Colors.white,
                        onPressed: () {
                          Get.offAllNamed('/home');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreDetail({
    required String title,
    required String score,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 4.sp),
        Text(
          score,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    Color textColor = Colors.black,
  }) {
    return SizedBox(
      height: 50.sp,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: textColor),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.sp),
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) {
      return AppColors.success;
    } else if (percentage >= 60) {
      return AppColors.secondary;
    } else if (percentage >= 40) {
      return AppColors.warning;
    } else {
      return AppColors.error;
    }
  }
}
