import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../utils/app_ad_manager.dart';
import '../widgets/question_card.dart';
import 'question_controller.dart';

class QuestionsScreen extends StatefulWidget {
  final String subjectId;
  final String subjectName;

  const QuestionsScreen({
    required this.subjectId,
    required this.subjectName,
    super.key,
  });

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  late final QuestionsController _controller;
  final AppAdManager _adManager = AppAdManager();
  final ScrollController _scrollController = ScrollController();
  bool _initialScrollDone = false;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(QuestionsController(subjectId: widget.subjectId));
    _adManager.loadBannerAd();
    _adManager.loadInterstitialAd();

    // Handle scrolling to the last viewed question
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToLastQuestion();
    });
  }

  void _scrollToLastQuestion() {
    if (!_initialScrollDone && _controller.questions.isNotEmpty) {
      final index = _controller.lastQuestionIndex.value;
      if (index >= 0 && index < _controller.questions.length) {
        // Estimate the height of each question card
        final estimatedHeight = 400.sp;
        _scrollController.animateTo(
          index * estimatedHeight,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        _initialScrollDone = true;
      }
    }
  }

  @override
  void dispose() {
    _adManager.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showResetConfirmation() {
    Get.defaultDialog(
      title: "Reset Answers",
      middleText: "Are you sure you want to reset all answers?",
      textConfirm: "Reset",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        _controller.resetAnswers();
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: Text(widget.subjectName),
        actions: [
          // Reset button
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _showResetConfirmation,
          ),

          // Show all correct answers button
          IconButton(
            icon: Icon(Icons.check_circle_outline, color: Colors.white),
            onPressed: () => _controller.showAllCorrectAnswers(),
          ),

          // Question counter badge
          Container(
            margin: EdgeInsets.only(right: 16.sp),
            padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 4.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.sp),
            ),
            child: Obx(() => Text(
                  "${_controller.questions.length}",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                )),
          ),
        ],
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
              child: Obx(() {
                if (_controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (_controller.questions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.question_mark,
                          size: 64.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16.sp),
                        Text(
                          "No questions available",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: _controller.questions.length,
                  itemBuilder: (context, index) {
                    final question = _controller.questions[index];

                    return QuestionCard(
                      question: question,
                      index: index,
                      buttonColors: _controller.buttonColors[question.id!] ??
                          List.filled(question.options!.length,
                              _controller.defaultButtonColor),
                      onAnswerSelected: (questionId, optionIndex) {
                        _controller.selectAnswer(questionId, optionIndex);

                        // Show an ad after answering questions occasionally
                        if (index % 10 == 9) {
                          // Every 10th question
                          _adManager.showInterstitial();
                        }
                      },
                      onFavoritePressed: () {
                        _controller.addToFavorites(question).then((success) {
                          if (success) {
                            Get.snackbar("done", "Added to favorites");
                          } else {
                            Get.snackbar("error", "Already in favorites");
                          }
                        });
                      },
                      onShowCorrectAnswerPressed: () =>
                          _controller.showCorrectAnswer(question.id!),
                    );
                  },
                );
              }),
            ),
          ),

          // Banner ad at the bottom
          _adManager.getBannerAdWidget(),
        ],
      ),
    );
  }
}
