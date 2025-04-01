import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../result screen/result_screen.dart';

class ReopenTestScreen extends StatefulWidget {
  ReopenTestScreen({super.key});

  @override
  State<ReopenTestScreen> createState() => _ReopenTestScreenState();
}

class _ReopenTestScreenState extends State<ReopenTestScreen> {
  Map<String, dynamic> data = Get.arguments;

  int currentQuestionIndex = 0;

  int numberOfQuestions = 0;

  PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    if (data["listOfQuestions"] != null) {
      numberOfQuestions = data["listOfQuestions"].length;
    }
    // You might also want to ensure that _pageController is correctly initialized
    // based on the currentQuestionIndex if you're resuming a test
    _pageController = PageController(initialPage: currentQuestionIndex);
  }

  Map selectedOption = {};

  int rightAnswer = 0;

  int wrongAnswer = 0;

  int chooseOption = 0;

  int correctAnswer = 0;

  void nextQuestion() {
    String questionId =
        data["listOfQuestions"][currentQuestionIndex].id.toString();

    // Check if the current question has been answered
    if (!selectedOption.containsKey(questionId) ||
        selectedOption[questionId] == null) {
      Fluttertoast.showToast(
          msg: "Please select an option before moving to the next question",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return; // Exit the function to prevent moving to the next question
    }

    // Proceed with checking the answer and moving to the next question
    int selectedAnswerIndex = data["listOfQuestions"][currentQuestionIndex]
            .options!
            .indexOf(selectedOption[questionId]) +
        1;
    int correctAnswer = data["listOfQuestions"][currentQuestionIndex].answer!;

    if (selectedAnswerIndex == correctAnswer) {
      rightAnswer++;
    } else {
      wrongAnswer++;
    }

    setState(() {
      if (currentQuestionIndex < numberOfQuestions - 1) {
        currentQuestionIndex++;
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      } else {
        var percentage = (rightAnswer / numberOfQuestions) * 100;
        Get.to(() => ResultScreen(), arguments: {
          "correctAnswer": rightAnswer,
          "wrongAnswer": wrongAnswer,
          "percentage": percentage,
          "listAnswers": selectedOption,
          "numberOfQuestions": data["numberOfQuestions"],
          "listOfQuestions": data["listOfQuestions"]
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Exit the test"),
            content:
                const Text('Do you want to confirm your exit from the test?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('NO'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('YES'),
              ),
            ],
          ),
        );

        // Return true if the user decides to pop and false otherwise
        return shouldPop ?? false;
      },
      child: Scaffold(
        backgroundColor: bgColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () async {
                final shouldPop = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("الخروج من الإختبار"),
                    content: const Text('هل تريد تأكيد الخروج من الإختبار؟'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('لا'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('نعم'),
                      ),
                    ],
                  ),
                );

                // Return true if the user decides to pop and false otherwise
                return shouldPop ?? false;
              },
              icon: Icon(Icons.arrow_back)),
          backgroundColor: bgColor,
          title: Text(
            "Your Test",
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ), // Add this line
        body: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding:
                      EdgeInsets.only(top: 40.sp, left: 10.sp, right: 10.sp),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: 620.sp,
                      child: PageView.builder(
                        controller: _pageController,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: data["listOfQuestions"].length,
                        itemBuilder: (context, index) {
                          var question = data["listOfQuestions"][index];
                          return SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.sp),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        question.questionTitle!,
                                        style: TextStyle(fontSize: 18.sp),
                                      ),
                                      SizedBox(height: 10.sp),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.sp,
                                ),
                                // Inside the PageView.builder itemBuilder
                                ...List.generate(
                                  question.options!.length,
                                  (optionIndex) {
                                    String optionValue =
                                        question.options![optionIndex];
                                    // Use 'question.id.toString()' or a similar unique identifier for your question
                                    String questionId = question.id.toString();

                                    return Container(
                                      color: Colors.white,
                                      width: double.infinity,
                                      child: RadioListTile<String>(
                                        title: Text(
                                          optionValue,
                                          style: TextStyle(fontSize: 17.sp),
                                        ),
                                        value: optionValue,
                                        groupValue: selectedOption[
                                            questionId], // Use the correct reference for groupValue
                                        onChanged: (String? value) {
                                          setState(() {
                                            selectedOption[questionId] = value;
                                          });
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
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 40.sp,
                  width: double.infinity,
                  color: Color.fromARGB(255, 221, 219, 219),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: nextQuestion,
                        child: Container(
                          width: 70.sp,
                          height: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.sp),
                                  bottomRight: Radius.circular(20.sp)),
                              color: bgColor),
                          child: Center(
                              child: Text(
                            "NEXT",
                            style:
                                TextStyle(fontSize: 22.sp, color: Colors.white),
                          )),
                        ),
                      ),
                      Container(
                        width: 70.sp,
                        height: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.sp),
                                bottomLeft: Radius.circular(20.sp)),
                            color: Colors.green),
                        child: Center(
                          child: Text(
                            "${(currentQuestionIndex + 1)} / $numberOfQuestions",
                            style:
                                TextStyle(fontSize: 22.sp, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
