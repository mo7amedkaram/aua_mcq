// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../Favourite Screen/favourite_screen_controller.dart';
import 'question_controller.dart';

class QuestionScreen extends StatefulWidget {
  String subjectName;
  String subjectId;
  QuestionScreen({
    Key? key,
    required this.subjectName,
    required this.subjectId,
  }) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  late QuestionController controller;
  TextEditingController decriptionController = TextEditingController();
  FavouriteQuestionController favController =
      Get.put(FavouriteQuestionController());
  int lastQuestionIndex =
      0; // default to the first question if no index was saved

  @override
  void initState() {
    super.initState();
    // TODO make sure to comment out this line before release

    getLastQuestionAnswered(widget.subjectId);
    controller = Get.put(QuestionController(subjectId: widget.subjectId));

    _loadCurrentPage();
    controller.getQuestions().then((_) async {
      await controller.loadButtonColors();
      if (controller.allButtonColors.isEmpty ||
          controller.allButtonColors.length != controller.question.length) {
        controller.allButtonColors = controller.question.map((question) {
          return List.filled(question.options!.length, controller.defaultBg);
        }).toList();
      }
      setState(() {});
    });
    int lastQuestionIndex = 5;
    if (lastQuestionIndex >= 0 &&
        lastQuestionIndex < controller.question.length) {
      Future.delayed(Duration.zero, () {
        scrollController.jumpTo(lastQuestionIndex * 300);
      });
    }
  }

  @override
  void didUpdateWidget(covariant QuestionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.subjectId != oldWidget.subjectId) {
      controller = Get.put(QuestionController(subjectId: widget.subjectId));
      _loadCurrentPage();
      controller.getQuestions().then((_) async {
        await controller.loadButtonColors();
        // التحقق من الألوان وتحديثها إذا لزم الأمر
        if (controller.allButtonColors.isEmpty ||
            controller.allButtonColors.length != controller.question.length) {
          controller.allButtonColors = controller.question.map((question) {
            return List.filled(question.options!.length, controller.defaultBg);
          }).toList();
        }
        if (mounted) setState(() {});
      });
    }
  }

  Future<void> _loadCurrentPage() async {
    final prefs = await SharedPreferences.getInstance();
    int currentPage = prefs.getInt('currentPage_${widget.subjectId}') ?? 0;
    controller.currentPages[widget.subjectId] = currentPage;
  }

  Future<void> _saveCurrentPage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('currentPage_${widget.subjectId}',
        controller.currentPages[widget.subjectId] ?? 0);
  }

  void resetQuestions() {
    for (var buttonColors in controller.allButtonColors) {
      for (int i = 0; i < buttonColors.length; i++) {
        buttonColors[i] = controller.defaultBg;
      }
    }
    setState(() {});
    controller.storeButtonColors();
  }

  void showAllCorrectAnswers() {
    for (int questionIndex = 0;
        questionIndex < controller.question.length;
        questionIndex++) {
      var question = controller.question[questionIndex];
      var correctAnswerIndex = question.answer! - 1; // تصحيح المؤشر

      var buttonColors = controller.allButtonColors[questionIndex];
      for (int optionIndex = 0;
          optionIndex < buttonColors.length;
          optionIndex++) {
        if (optionIndex == correctAnswerIndex) {
          buttonColors[optionIndex] = controller.rightAnswer;
        } else {
          buttonColors[optionIndex] = controller.defaultBg;
        }
      }
    }

    setState(() {});
    controller.storeButtonColors();
  }

  double estimatedHeightOfEachQuestion = 400.0;
  Future<void> getLastQuestionAnswered(String subjectId) async {
    final prefs = await SharedPreferences.getInstance();
    lastQuestionIndex = prefs.getInt('lastQuestionIndex_$subjectId') ?? 0;
    // Now, you can use lastQuestionIndex to scroll to the last question for this subject.
    // You may need to call setState if necessary to refresh the UI with the new index.
  }

  bool initialScrollDone = false;
  ScrollController scrollController = ScrollController();

  Future<void> saveLastQuestionAnswered(
      {required String subjectId, required int questionIndex}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastQuestionIndex_$subjectId', questionIndex);
  }

  @override
  Widget build(BuildContext context) {
    // Only perform the initial scroll once.
    if (!initialScrollDone) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients &&
            controller.question.isNotEmpty &&
            lastQuestionIndex < controller.question.length) {
          double offset = lastQuestionIndex * estimatedHeightOfEachQuestion;
          scrollController.animateTo(
            offset,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
          initialScrollDone = true; // Set the flag to true after scrolling.
        }
      });
    }
    return Scaffold(
      backgroundColor: const Color.fromRGBO(39, 25, 99, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(39, 25, 99, 1),
        title: Text(
          widget.subjectName,
          style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.height * 0.025),
        ),
        actions: [
          IconButton(
              onPressed: resetQuestions,
              icon: Lottie.asset("assets/images/reset.json")),
          IconButton(
              onPressed: showAllCorrectAnswers,
              icon: Lottie.asset("assets/images/select_all.json")),
          Container(
            width: 80,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Center(
                child: Text(
              "${controller.question.length}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            )),
          )
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      itemCount: controller.question.length,
                      itemBuilder: (context, index) {
                        if (controller.allButtonColors.length <= index) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        var buttonColors = controller.allButtonColors[index];

                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "${index + 1}) ${controller.question[index].questionTitle} :",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.025,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        int randomId = Random().nextInt(1000);
                                        favController.addQuestion(
                                          controller
                                              .question[index].questionTitle!,
                                          controller.question[index].options!,
                                          controller.question[index].answer!,
                                          randomId,
                                        );
                                        Fluttertoast.showToast(
                                            msg:
                                                "تم حفظ السؤال في المفضلة بنجاح");
                                      },
                                      icon: Icon(
                                        Icons.favorite_border_outlined,
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    controller.question[index].options!.length,
                                    (indexOptions) {
                                      if (indexOptions >=
                                          controller.question[index].options!
                                              .length) {
                                        return Container();
                                      }

                                      return Container(
                                        margin: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.all(10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            textStyle: TextStyle(fontSize: 18),
                                            alignment: Alignment.center,
                                            backgroundColor:
                                                buttonColors.length >
                                                        indexOptions
                                                    ? buttonColors[indexOptions]
                                                    : controller.defaultBg,
                                          ),
                                          onPressed: () {
                                            onAnswerSelected(
                                                index, indexOptions);
                                          },
                                          child: Text(
                                            "${controller.question[index].options![indexOptions]}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.025),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        height: 50,
                                        width: 50,
                                        child: IconButton(
                                          onPressed: () {
                                            var question =
                                                controller.question[index];
                                            var textToCopy =
                                                "${index + 1}) ${question.questionTitle}\n";
                                            for (int i = 0;
                                                i < question.options!.length;
                                                i++) {
                                              textToCopy +=
                                                  "${i + 1}. ${question.options![i]}${i == question.answer! - 1 ? ' (صحيح)' : ''}\n";
                                            }
                                            Clipboard.setData(ClipboardData(
                                                    text: textToCopy))
                                                .then((value) {
                                              final snackBar = SnackBar(
                                                  content: Text(
                                                      "Question Copied Successfully"));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            });
                                          },
                                          icon: Lottie.asset(
                                              "assets/images/copy.json"),
                                        )),
                                    Container(
                                      height: 50,
                                      width: 50,
                                      child: IconButton(
                                        onPressed: () {
                                          Get.defaultDialog(
                                            title: "هل يوجد خطأ في هذا السؤال؟",
                                            titleStyle: TextStyle(fontSize: 18),
                                            content: Column(
                                              children: <Widget>[
                                                TextField(
                                                  controller:
                                                      decriptionController,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "..... قم بكتابة تفاصيل الخطأ هنا",
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('الغاء'),
                                                onPressed: () {
                                                  Get.back(); // يغلق الـ Dialog
                                                },
                                              ),
                                              TextButton(
                                                child: Text('ارسال'),
                                                onPressed: () {
                                                  // هنا يمكنك تنفيذ الكود للتحقق من الخطأ وإرساله
                                                  // يغلق الـ Dialog بعد الإرسال
                                                  controller.sendWrongAnswer(
                                                    questionId: controller
                                                        .question[index].id!,
                                                    questionTitle: controller
                                                        .question[index]
                                                        .questionTitle!,
                                                    description:
                                                        decriptionController
                                                            .text
                                                            .trim(),
                                                  );
                                                  Get.back(); // Add this if you want to close the dialog after pressing send
                                                },
                                              ),
                                            ],
                                            barrierDismissible:
                                                false, // لا يمكن إغلاق الـ Dialog بالضغط خارجه
                                          );
                                        },
                                        icon: Lottie.asset(
                                            "assets/images/wrong.json"),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50.sp,
                                      width: 50.sp,
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            var question =
                                                controller.question[index];
                                            var correctAnswerIndex =
                                                question.answer! -
                                                    1; // تصحيح المؤشر
                                            for (int i = 0;
                                                i < question.options!.length;
                                                i++) {
                                              if (i == correctAnswerIndex) {
                                                buttonColors[i] =
                                                    controller.rightAnswer;
                                              } else {
                                                if (buttonColors[i] !=
                                                    controller.rightAnswer) {
                                                  buttonColors[i] =
                                                      controller.defaultBg;
                                                }
                                              }
                                            }
                                          });
                                          controller.storeButtonColors();
                                        },
                                        icon: Lottie.asset(
                                            "assets/images/idea.json"),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      // bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

/*
  Widget _buildBottomNavigationBar() {
    // Assuming _bannerAd is a BannerAd object and properly initialized.
    return bannerAd != null ? StartAppBanner(bannerAd!) : Container();
  }
*/
  void onAnswerSelected(int questionIndex, int selectedOptionIndex) {
    final buttonColors = controller.allButtonColors[questionIndex];
    final isCorrect =
        controller.question[questionIndex].answer == (selectedOptionIndex + 1);

    for (int i = 0; i < buttonColors.length; i++) {
      buttonColors[i] = controller.defaultBg;
    }
    buttonColors[selectedOptionIndex] =
        isCorrect ? controller.rightAnswer : controller.falseAnswer;

    setState(() {});
    saveLastQuestionAnswered(
        questionIndex: questionIndex,
        subjectId: widget.subjectId); // Call this when the answer is selected
    controller.storeButtonColors();
  }
}

/*


Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(currentQuestion["question_title"],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          Column(
                            children: List.generate(
                              currentQuestion["options"].length,
                              (optionIndex) => RadioListTile(
                                  title: Text(
                                      currentQuestion["options"][optionIndex]),
                                  value: optionIndex,
                                  groupValue:
                                      controller.selectedAnswerIndices[index],
                                  onChanged: (value) {
                                    print("$value");
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
*/
