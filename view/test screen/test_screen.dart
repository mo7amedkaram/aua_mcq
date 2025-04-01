import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../Ads Helper/ads_helper.dart';
import '../../Model/Question Model/question_model.dart';
import '../../constants/colors.dart';
import '../Questions Page/question_controller.dart';
import '../result screen/result_screen.dart';

class TestScreen extends StatefulWidget {
  TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  InterstitialAd? _interstitialAd;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {},
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  //----------------
  Map<String, dynamic> data = Get.arguments;
  QuestionController questionController = Get.put(QuestionController());
  int currentQuestionIndex = 0;
  int numberOfQuestions = 0;
  //-----
  late Timer _timer;
  late int _secondsRemaining;
  @override
  void initState() {
    super.initState();
    _secondsRemaining = data["time"] * 60; // Convert minutes to seconds
    _startTimer();
    questionController
        .getTestQuestions(subjectTestId: data["subjectId"])
        .then((_) {
      // Assuming getTestQuestions fetches questions and updates questionsTest list
      // Randomize and select a subset of questions based on data["numberOfQuestion"]
      if (questionController.questionsTest.isNotEmpty) {
        final randomQuestions = (questionController.questionsTest..shuffle())
            .take(data["numberOfQuestion"])
            .toList();
        setState(() {
          questionController.questionsTest.value =
              randomQuestions.cast<QuestionModel>().toList().obs;
          numberOfQuestions = randomQuestions.length;
        });
      }
    });
    _loadInterstitialAd();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer.cancel();
        _navigateToSpecificScreen();
      }
    });
  }

  void _navigateToSpecificScreen() {
    // Replace with your navigation logic
    // For example, if you're using named routes:
    List<QuestionModel> listOfQuestions =
        questionController.questionsTest.toList();
    var percentage = (rightAnswer / numberOfQuestions) * 100;

    if (_interstitialAd != null) {
      _interstitialAd?.show().then(
            (value) => Get.to(() => ResultScreen(), arguments: {
              "correctAnswer": rightAnswer,
              "wrongAnswer": wrongAnswer,
              "percentage": percentage,
              "listAnswers": selectedOption,
              "numberOfQuestions": numberOfQuestions,
              "listOfQuestions": listOfQuestions,
            }),
          );
    } else {
      String questionId =
          questionController.questionsTest[currentQuestionIndex].id.toString();

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
        Navigator.of(
            context); // Exit the function to prevent moving to the next question
      } else {
        Get.to(() => ResultScreen(), arguments: {
          "correctAnswer": rightAnswer,
          "wrongAnswer": wrongAnswer,
          "percentage": percentage,
          "listAnswers": selectedOption,
          "numberOfQuestions": numberOfQuestions,
          "listOfQuestions": listOfQuestions,
        });
      }
    }
  }

  @override
  void dispose() {
    _interstitialAd!.dispose();
    _timer
        .cancel(); // Cancel the timer when the widget is disposed to avoid memory leaks.
    super.dispose();
  }

  PageController _pageController = PageController();
  Map selectedOption = {};
  int rightAnswer = 0;
  int wrongAnswer = 0;

  int chooseOption = 0;
  int correctAnswer = 0;
  void nextQuestion() {
    String questionId =
        questionController.questionsTest[currentQuestionIndex].id.toString();

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
    int selectedAnswerIndex = questionController
            .questionsTest[currentQuestionIndex].options!
            .indexOf(selectedOption[questionId]) +
        1;
    int correctAnswer =
        questionController.questionsTest[currentQuestionIndex].answer!;

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
        List<QuestionModel> listOfQuestions =
            questionController.questionsTest.toList();
        var percentage = (rightAnswer / numberOfQuestions) * 100;
        if (_interstitialAd != null) {
          _interstitialAd?.show().then(
                (value) => Get.to(() => ResultScreen(), arguments: {
                  "correctAnswer": rightAnswer,
                  "wrongAnswer": wrongAnswer,
                  "percentage": percentage,
                  "listAnswers": selectedOption,
                  "numberOfQuestions": numberOfQuestions,
                  "listOfQuestions": listOfQuestions,
                }),
              );
        } else {
          Get.to(() => ResultScreen(), arguments: {
            "correctAnswer": rightAnswer,
            "wrongAnswer": wrongAnswer,
            "percentage": percentage,
            "listAnswers": selectedOption,
            "numberOfQuestions": numberOfQuestions,
            "listOfQuestions": listOfQuestions,
          });
        }
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
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .start, // Use this to minimize the row's width to fit its children
                children: [
                  Text(
                    "${_secondsRemaining ~/ 60}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Tajawal",
                      // Note: fontSize using `.sp` might be specific to a library like `flutter_screenutil`
                      // Ensure you have it implemented in your project or use a fixed size in pixels
                      fontSize: MediaQuery.of(context).size.height *
                          0.025, // Assuming `sp` is defined somewhere in your code
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                      width:
                          8.0), // Add some space between the text and the icon
                  const Icon(
                    Icons.timer,
                    size: 30,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
          leading: IconButton(
              onPressed: () async {
                final shouldPop = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Exit the test"),
                    content: const Text(
                        'Do you want to confirm your exit from the test?'),
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
              icon: Icon(Icons.arrow_back)),
          backgroundColor: bgColor,
          title: Text(
            "Your Test",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.025,
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
                  padding: EdgeInsets.only(
                    top: 40.sp,
                    left: 10.sp,
                    right: 10.sp,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  width: double.infinity,
                  child: Obx(
                    () => questionController.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                            child: SizedBox(
                              height: 620.sp,
                              child: PageView.builder(
                                controller: _pageController,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    questionController.questionsTest.length,
                                itemBuilder: (context, index) {
                                  var question =
                                      questionController.questionsTest[index];
                                  return SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10.sp),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                question.questionTitle!,
                                                style:
                                                    TextStyle(fontSize: 18.sp),
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
                                            String questionId =
                                                question.id.toString();

                                            return Container(
                                              color: Colors.white,
                                              width: double.infinity,
                                              child: RadioListTile<String>(
                                                title: Text(
                                                  optionValue,
                                                  style: TextStyle(
                                                      fontSize: 17.sp),
                                                ),
                                                value: optionValue,
                                                groupValue: selectedOption[
                                                    questionId], // Use the correct reference for groupValue
                                                onChanged: (String? value) {
                                                  setState(() {
                                                    selectedOption[questionId] =
                                                        value;
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
