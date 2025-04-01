import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../Model/Subject model/subject_model.dart';
import '../../Model/grades model/grades_model.dart';
import '../../Model/module_model/module_model.dart';
import '../../constants/colors.dart';
import '../../utils/app_ad_manager.dart';
import '../Widgets/counter_controller.dart';
import '../test screen/test_screen.dart';
import '../widgets/dropdown_selection.dart';
import 'testme_controller.dart';

class TestMeScreen extends StatefulWidget {
  const TestMeScreen({super.key});

  @override
  State<TestMeScreen> createState() => _TestMeScreenState();
}

class _TestMeScreenState extends State<TestMeScreen> {
  late final TestController _controller;
  final AppAdManager _adManager = AppAdManager();

  @override
  void initState() {
    super.initState();
    _controller = Get.put(TestController());
    _adManager.loadBannerAd();
    _adManager.loadInterstitialAd();
  }

  @override
  void dispose() {
    _adManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: Text("Create Test"),
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
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(24.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Grade selection
                      DropdownSelection<GradeModel>(
                        label: "Select Grade",
                        value: _controller.selectedGrade.value,
                        items: _controller.grades,
                        getLabel: (grade) => grade.gradeName ?? "Unknown Grade",
                        onChanged: (grade) {
                          if (grade != null) {
                            _controller.setSelectedGrade(grade);
                          }
                        },
                        hintText: "Choose a grade",
                        isLoading: _controller.isLoadingGrades.value,
                      ),
                      SizedBox(height: 24.sp),

                      // Module selection
                      DropdownSelection<ModuleModel>(
                        label: "Select Module",
                        value: _controller.selectedModule.value,
                        items: _controller.modules,
                        getLabel: (module) =>
                            module.moduleName ?? "Unknown Module",
                        onChanged: (module) {
                          if (module != null) {
                            _controller.setSelectedModule(module);
                          }
                        },
                        hintText: "Choose a module",
                        isLoading: _controller.isLoadingModules.value,
                      ),
                      SizedBox(height: 24.sp),

                      // Subject selection
                      DropdownSelection<SubjectModel>(
                        label: "Select Subject",
                        value: _controller.selectedSubject.value,
                        items: _controller.subjects,
                        getLabel: (subject) =>
                            subject.subjectName ?? "Unknown Subject",
                        onChanged: (subject) {
                          if (subject != null) {
                            _controller.setSelectedSubject(subject);
                          }
                        },
                        hintText: "Choose a subject",
                        isLoading: _controller.isLoadingSubjects.value,
                      ),
                      SizedBox(height: 32.sp),

                      // Question count
                      CounterControl(
                        label: "Number of Questions",
                        value: _controller.questionCount.value,
                        onIncrement: _controller.increaseQuestionCount,
                        onDecrement: _controller.decreaseQuestionCount,
                      ),
                      SizedBox(height: 24.sp),

                      // Time selection
                      CounterControl(
                        label: "Test Duration",
                        value: _controller.timeInMinutes.value,
                        onIncrement: _controller.increaseTime,
                        onDecrement: _controller.decreaseTime,
                        suffix: "min",
                      ),
                      SizedBox(height: 40.sp),

                      // Start test button
                      SizedBox(
                        width: double.infinity,
                        height: 52.sp,
                        child: ElevatedButton(
                          onPressed: _startTest,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.sp),
                            ),
                          ),
                          child: Text(
                            "Start Test",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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

  void _startTest() {
    if (!_controller.isFormValid()) {
      Get.snackbar(
        "error",
        "Please fill in all fields to start the test",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      return;
    }

    // Show interstitial ad before starting the test
    _adManager.showInterstitial().then((_) {
      // Navigate to test screen
      Get.to(() => TestScreen(
            subjectId: _controller.selectedSubject.value!.id!,
            numberOfQuestions: _controller.questionCount.value,
            timeInMinutes: _controller.timeInMinutes.value,
          ));
    });
  }
}
