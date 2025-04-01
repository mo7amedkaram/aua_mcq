import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../constants/colors.dart';
import '../Home Page/my_home_page.dart';
import '../TestMe Screen/testme_screen.dart';
import '../reopen test/reopen_test.dart';
import '../test screen/test_screen.dart';
import '../view answers/view_answers.dart';

class ResultScreen extends StatelessWidget {
  ResultScreen({super.key});
  Map<String, dynamic> data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show the Fluttertoast message instead of popping the route
        Fluttertoast.showToast(
            msg: "Return to the test page is not available",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        // Return false to prevent the pop action
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: bgColor,
        resizeToAvoidBottomInset: false, // Add this line
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 25.sp, right: 30.sp),
                child: Row(
                  children: [
                    SizedBox(
                      width: 25.sp,
                    ),
                    Text(
                      "Test result",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: "Tajawal",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 219, 217, 217),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  height: 620.sp,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Card(
                          child: Column(
                            children: [
                              Container(
                                width: 150.sp,
                                height: 150.sp,
                                child: SfRadialGauge(
                                  axes: <RadialAxis>[
                                    RadialAxis(
                                      annotations: <GaugeAnnotation>[
                                        GaugeAnnotation(
                                          positionFactor: 0.1,
                                          angle: 90,
                                          widget: Text(
                                            "Exam degree \n ${data["percentage"].toStringAsFixed(0)}%",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontFamily: "Tajawal",
                                            ),
                                          ),
                                        )
                                      ],
                                      pointers: <GaugePointer>[
                                        RangePointer(
                                          color:
                                              Color.fromARGB(255, 243, 163, 34),
                                          value: double.parse(
                                              data["correctAnswer"].toString()),
                                          cornerStyle: CornerStyle.bothCurve,
                                          width: 0.2,
                                          sizeUnit: GaugeSizeUnit.factor,
                                        )
                                      ],
                                      minimum: 0,
                                      maximum: double.parse(data["listAnswers"]
                                          .length
                                          .toString()),
                                      showLabels: false,
                                      showTicks: false,
                                      axisLineStyle: AxisLineStyle(
                                        thickness: 0.2,
                                        cornerStyle: CornerStyle.bothCurve,
                                        color: bgColor,
                                        thicknessUnit: GaugeSizeUnit.factor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 10.sp, right: 10.sp),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Right answers",
                                          style: TextStyle(
                                            fontFamily: "Tajawal",
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${data["numberOfQuestions"]} / ${data["correctAnswer"]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.sp,
                                              fontFamily: "Tajawal",
                                              color: bgColor),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Wrong answers",
                                          style: TextStyle(
                                            fontFamily: "Tajawal",
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${data["numberOfQuestions"]} / ${data["wrongAnswer"]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.sp,
                                              fontFamily: "Tajawal",
                                              color: bgColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.sp,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => Get.to(() => ViewAnswers(),
                                  arguments: {
                                    "listOfQuestions": data["listOfQuestions"],
                                    "listAnswers": data["listAnswers"]
                                  }),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 16.sp,
                                    right: 16.sp,
                                    top: 8.sp,
                                    bottom: 8.sp),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.sp),
                                    color: Color.fromRGBO(252, 200, 38, 1)),
                                child: Center(
                                  child: Text(
                                    "Show Answers",
                                    style: TextStyle(
                                      fontFamily: "Tajawal",
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => Get.offAll(() => ReopenTestScreen(),
                                  arguments: {
                                    "listOfQuestions": data["listOfQuestions"],
                                    "numberOfQuestions":
                                        data["numberOfQuestions"],
                                  }),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 16.sp,
                                    right: 16.sp,
                                    top: 8.sp,
                                    bottom: 8.sp),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.sp),
                                  color: const Color.fromRGBO(197, 192, 215, 1),
                                ),
                                child: Center(
                                  child: Text(
                                    "Repeat exam",
                                    style: TextStyle(
                                      fontFamily: "Tajawal",
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => MyHomePage(),
                                    ),
                                    (Route<dynamic> route) => false);
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 16.sp,
                                    right: 16.sp,
                                    top: 8.sp,
                                    bottom: 8.sp),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.sp),
                                  color: Color.fromRGBO(197, 192, 215, 1),
                                ),
                                child: Center(
                                  child: Text(
                                    "Home",
                                    style: TextStyle(
                                        fontFamily: "Tajawal",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 16.sp),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
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
