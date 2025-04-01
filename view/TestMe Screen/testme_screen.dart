import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../Model/Subject model/subject_model.dart';
import '../../Model/grades model/grades_model.dart';
import '../../Model/module_model/module_model.dart';
import '../../constants/colors.dart';
import '../Home Page/home_page_controller.dart';
import '../Subjects Page/subject_controller.dart';
import '../module page/module_controller.dart';
import '../test screen/test_screen.dart';
import 'testme_controller.dart';

class TestMeScreen extends StatefulWidget {
  TestMeScreen({super.key});

  @override
  State<TestMeScreen> createState() => _TestMeScreenState();
}

class _TestMeScreenState extends State<TestMeScreen> {
  HomePageController gradeController = Get.put(HomePageController());

  ModuleController moduleController = Get.put(ModuleController());
  SubjectController subjectController = Get.put(SubjectController());

  TestMeController controller = Get.put(TestMeController());

  int numberRandomQuestions = 0;
  int time = 0;

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
          "Generate Test",
          style: TextStyle(
            fontSize: 18.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ), // Add this line
      body: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.only(top: 40.sp, left: 10.sp, right: 10.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            height: 620.sp,
            width: double.infinity,
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Please Choose your grade :",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.025)),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<GradesModel>(
                        isExpanded: true,
                        iconSize: 30.sp,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
                        value: controller.selectedGrade.value,
                        hint: Text(
                          "Choose Grade",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.025),
                        ),
                        onChanged: (GradesModel? newValue) async {
                          if (newValue != null) {
                            controller.selectedGrade.value = newValue;
                            controller.selectedModule.value = null;
                            moduleController.testModules.clear();

                            await moduleController.getTestModules(
                                gradeTestId: newValue.id!);
                            setState(() {});
                            log(newValue.id!);
                            // log("${examController.isLessonsCategory.value}");
                          }
                        },
                        items: gradeController.grades.map((grade) {
                          return DropdownMenuItem(
                            value: grade,
                            child: Text(
                              grade.gradeName ?? "Unnamed Module",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                              ),
                              overflow:
                                  TextOverflow.ellipsis, // Add ellipsis here
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  //------------------------------------------
                  SizedBox(
                    height: 15.sp,
                  ),
                  Row(
                    children: [
                      Text("Please Choose your module :",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.025)),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<ModuleModel>(
                        isExpanded: true,
                        iconSize: 30.sp,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
                        value: controller.selectedModule.value,
                        hint: Text("Choose Module",
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height *
                                    0.025)),
                        onChanged: (ModuleModel? newValue) async {
                          if (newValue != null) {
                            controller.selectedModule.value = newValue;

                            controller.selectedSubject.value =
                                null; // Reset selected subject
                            subjectController.subjectTest.clear();
                            await subjectController.getTestSubjects(
                                moduleTestId: newValue.id!);

                            // log("${examController.isLessonsCategory.value}");

                            setState(() {});
                          }
                        },
                        items: moduleController.testModules.map((module) {
                          return DropdownMenuItem(
                            value: module,
                            child: Text(
                              module.moduleName ?? "Unnamed Module",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                              ),
                              overflow:
                                  TextOverflow.ellipsis, // Add ellipsis here
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.sp,
                  ),
                  Row(
                    children: [
                      Text("Please Choose your subject :",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.025)),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<SubjectModel>(
                        isExpanded: true,
                        iconSize: 30.sp,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
                        value: controller.selectedSubject.value,
                        hint: Text("Choose Subject",
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height *
                                    0.025)),
                        onChanged: (SubjectModel? newValue) {
                          if (newValue != null) {
                            controller.selectedSubject.value = newValue;
                            print(newValue.id);
                            setState(() {});
                          }
                        },
                        items: subjectController.subjectTest.map((subject) {
                          return DropdownMenuItem(
                            value: subject,
                            child: Text(
                              subject.subjectName ?? "Unnamed Module",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                              ),
                              overflow:
                                  TextOverflow.ellipsis, // Add ellipsis here
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  //----------------------------
                  SizedBox(
                    height: 15.sp,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Please Choose number of questions :",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.025)),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: double.infinity,
                        color: Colors.grey.withOpacity(0.20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.1,
                              color: Colors.amber,
                              child: Center(
                                child: IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    setState(() {
                                      if (numberRandomQuestions > 0) {
                                        numberRandomQuestions--;
                                      } else {}
                                    });
                                  },
                                ),
                              ),
                            ),
                            Text(
                              "$numberRandomQuestions",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.025,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.1,
                              color: Colors.amber,
                              child: Center(
                                child: IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      numberRandomQuestions++;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.sp,
                      ),
                      Text("Please Choose time :",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.025)),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: double.infinity,
                        color: Colors.grey.withOpacity(0.20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.1,
                              color: Colors.amber,
                              child: Center(
                                child: IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    if (time > 0) {
                                      setState(() {
                                        time--;
                                      });
                                    } else {}
                                  },
                                ),
                              ),
                            ),
                            Text(
                              "$time min",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.025,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.1,
                              color: Colors.amber,
                              child: Center(
                                child: IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      time++;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.sp,
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(bgColor)),
                            onPressed: () {
                              if (controller.selectedGrade.value == null ||
                                  controller.selectedModule.value == null ||
                                  controller.selectedSubject.value == null ||
                                  time == 0 ||
                                  numberRandomQuestions == 0) {
                                Fluttertoast.showToast(
                                    msg: "لا يمكن أن توجد خانات فارغة");
                              } else {
                                Get.to(() => TestScreen(), arguments: {
                                  "subjectId":
                                      controller.selectedSubject.value!.id,
                                  "numberOfQuestion": numberRandomQuestions,
                                  "time": time
                                });
                              }
                            },
                            child: Text(
                              "Start Test",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.sp),
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
