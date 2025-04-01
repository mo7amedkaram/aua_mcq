import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../Questions Page/question_controller.dart';
import 'favourite_screen_controller.dart';

class FavouriteScreen extends StatefulWidget {
  FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  FavouriteQuestionController controller =
      Get.put(FavouriteQuestionController());

  TextEditingController decriptionController = TextEditingController();

  QuestionController questionController = Get.put(QuestionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(39, 25, 99, 1),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 40),
            onPressed: () {
              // Logic to reset the questions in favorites
              controller.resetFavorites();
              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(
              Icons.visibility,
              size: 40,
            ),
            onPressed: () {
              // Logic to show all correct answers in favorites
              controller.showAllCorrectAnswersInFavorites();
              setState(() {});
            },
          ),
        ],
        title: Text(
          "Your Fav. Questions",
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.height * 0.025,
          ),
        ),
        backgroundColor: const Color.fromRGBO(39, 25, 99, 1),
      ),
      body: SafeArea(
        child: Obx(
          () => controller.questions.isEmpty
              ? Center(
                  child: Text(
                    "صفحة المفضلة خالية",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.height * 0.025,
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.questions.length,
                  itemBuilder: (context, index) {
                    var question = controller.questions[index];
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    "${index + 1}) ${controller.questions[index].questionTitle} :",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.025,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    controller.deleteQuestion(
                                        controller.questions[index].id);
                                    Fluttertoast.showToast(
                                        msg:
                                            "تم حذف السؤال بنجاح من قائمة المفضلة");
                                  },
                                  icon: Icon(
                                    Icons.favorite_rounded,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                question.options.length,
                                (indexOptions) {
                                  // الحصول على حالة هذا الاختيار
                                  bool isSelected = controller
                                          .answersState[question.id]
                                          ?.containsKey(indexOptions + 1) ??
                                      false;
                                  bool? isSelectedCorrect =
                                      controller.answersState[question.id]
                                          ?[indexOptions + 1];

                                  return Container(
                                    margin: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isSelected
                                            ? (isSelectedCorrect!
                                                ? Colors.green
                                                : Colors.red)
                                            : const Color.fromRGBO(
                                                39, 25, 99, 1),
                                        textStyle:
                                            TextStyle(color: Colors.white),
                                        // باقي الخصائص...
                                      ),
                                      onPressed: () {
                                        controller.checkAnswer(
                                            question.id, indexOptions + 1);
                                      },
                                      child: Text(
                                        "${question.options[indexOptions]}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            //-----------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    height: 50,
                                    width: 50,
                                    child: IconButton(
                                      onPressed: () {
                                        // Logic for copying question
                                        var question =
                                            controller.questions[index];
                                        var textToCopy =
                                            "${index + 1}) ${question.questionTitle}\n";
                                        for (int i = 0;
                                            i < question.options.length;
                                            i++) {
                                          textToCopy +=
                                              "${i + 1}. ${question.options[i]}${i == question.answer - 1 ? ' (صحيح)' : ''}\n";
                                        }
                                        Clipboard.setData(
                                                ClipboardData(text: textToCopy))
                                            .then((value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    "Question Copied Successfully")),
                                          );
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
                                              controller: decriptionController,
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
                                              questionController
                                                  .sendWrongAnswer(
                                                questionId: controller
                                                    .questions[index].id
                                                    .toString(),
                                                questionTitle: controller
                                                    .questions[index]
                                                    .questionTitle!,
                                                description:
                                                    decriptionController.text
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
                                      controller.showCorrectAnswer(
                                          controller.questions[index].id);
                                    },
                                    icon:
                                        Lottie.asset("assets/images/idea.json"),
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
      ),
    );
  }
}
