import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';

class ViewAnswers extends StatefulWidget {
  ViewAnswers({super.key});

  @override
  State<ViewAnswers> createState() => _ViewAnswersState();
}

class _ViewAnswersState extends State<ViewAnswers> {
  Map<String, dynamic> data = Get.arguments;
  int numberOfQuestions = 0;

  @override
  void initState() {
    super.initState();
    if (data["listOfQuestions"] != null) {
      numberOfQuestions = data["listOfQuestions"].length;
    }
    // You might also want to ensure that _pageController is correctly initialized
    // based on the currentQuestionIndex if you're resuming a test
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          "Show Answers",
          style: TextStyle(
            fontSize: 18.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              padding: EdgeInsets.only(top: 40.sp, left: 10.sp, right: 10.sp),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              height: 620.sp,
              width: double.infinity,
              child: ListView.builder(
                itemCount: numberOfQuestions,
                itemBuilder: (context, index) {
                  var question = data["listOfQuestions"][index];
                  var questionId = question.id
                      .toString(); // Assuming each question has a unique ID
                  var correctAnswer = question
                      .answer; // Assuming this is the index of the correct answer
                  var userAnswer = data["listAnswers"][
                      questionId]; // The user's selected answer for this question

                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text(
                          question.questionTitle,
                          style: TextStyle(fontSize: 18.sp),
                        ),
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      ...List.generate(
                        question.options.length,
                        (optionIndex) {
                          String optionValue = question.options[optionIndex];
                          bool isSelected = optionValue == userAnswer;
                          bool isCorrect = (optionIndex + 1) == correctAnswer;

                          Color bgColor =
                              Colors.white; // Default background color
                          if (isSelected) {
                            bgColor = isCorrect ? Colors.green : Colors.red;
                          } else if (!isSelected && isCorrect) {
                            bgColor = Colors
                                .green; // Highlight the correct answer if the user's choice was wrong
                          }

                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical:
                                    4.sp), // Add some space between options
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            width: double.infinity,
                            child: ListTile(
                              title: Text(
                                optionValue,
                                style: TextStyle(fontSize: 17.sp),
                              ),
                              leading: Radio<String>(
                                value: optionValue,
                                groupValue: userAnswer,
                                onChanged:
                                    null, // Options are not selectable here
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              )),
        ),
      ),
    );
  }
}
