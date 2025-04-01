import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../utils/app_ad_manager.dart';
// Import the correct LocalQuestion model
import '../../database/local_databse_model.dart';
import '../Widgets/favourite_question_card.dart';
import 'favourite_screen_controller.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final FavoritesController _controller;
  final AppAdManager _adManager = AppAdManager();

  @override
  void initState() {
    super.initState();
    _controller = Get.put(FavoritesController());
    _adManager.loadBannerAd();
    _adManager.loadInterstitialAd();
  }

  @override
  void dispose() {
    _adManager.dispose();
    super.dispose();
  }

  void _copyQuestionToClipboard(int index, int questionId) {
    final question =
        _controller.questions.firstWhere((q) => q.id == questionId);

    String textToCopy = "${index + 1}) ${question.questionTitle}\n";

    for (int i = 0; i < question.options.length; i++) {
      textToCopy +=
          "${i + 1}. ${question.options[i]}${i == question.answer - 1 ? ' (correct)' : ''}\n";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: Text("Favorite Questions"),
        actions: [
          // Reset answers button
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () => _controller.resetFavorites(),
          ),

          // Show all correct answers button
          IconButton(
            icon: Icon(Icons.check_circle_outline, color: Colors.white),
            onPressed: () => _controller.showAllCorrectAnswers(),
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
              child: GetBuilder<FavoritesController>(
                builder: (controller) {
                  if (controller.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (controller.questions.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 64.sp,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16.sp),
                          Text(
                            "No favorite questions yet",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8.sp),
                          Text(
                            "Add questions to favorites from the question screens",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: controller.questions.length,
                    itemBuilder: (context, index) {
                      final question = controller.questions[index];

                      return FavoriteQuestionCard(
                        question: question,
                        index: index,
                        answerState: controller.answersState[question.id],
                        onOptionPressed: (questionId, optionIndex) {
                          controller.checkAnswer(questionId, optionIndex);

                          // Show ad occasionally
                          if (index % 5 == 0) {
                            _adManager.showInterstitial();
                          }
                        },
                        onDeletePressed: () {
                          Get.defaultDialog(
                            title: "Remove from Favorites",
                            middleText:
                                "Are you sure you want to remove this question from favorites?",
                            textConfirm: "Remove",
                            textCancel: "Cancel",
                            confirmTextColor: Colors.white,
                            onConfirm: () {
                              controller.deleteQuestion(question.id);
                              Get.snackbar("done", "Removed from favorites",
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white);

                              Get.back();
                            },
                          );
                        },
                        onCopyPressed: () =>
                            _copyQuestionToClipboard(index, question.id),
                        onShowCorrectAnswerPressed: () =>
                            controller.showCorrectAnswer(question.id),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // Banner ad at the bottom
          _adManager.getBannerAdWidget(),
        ],
      ),
    );
  }
}
