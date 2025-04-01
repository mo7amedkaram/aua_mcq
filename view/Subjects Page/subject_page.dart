import 'package:aua_questions_app/view/Subjects%20Page/subject_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../utils/app_ad_manager.dart';
import '../Questions Page/questions_screen.dart';
import '../widgets/subject_card.dart';

class SubjectsScreen extends StatefulWidget {
  final String moduleId;
  final String moduleName;

  const SubjectsScreen({
    required this.moduleId,
    required this.moduleName,
    super.key,
  });

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  late final SubjectsController _controller;
  final AppAdManager _adManager = AppAdManager();

  @override
  void initState() {
    super.initState();
    _controller = Get.put(SubjectsController(moduleId: widget.moduleId));
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
        title: Text(widget.moduleName),
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

                if (_controller.subjects.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.subject_outlined,
                          size: 64.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16.sp),
                        Text(
                          "No subjects available",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => _controller.fetchSubjects(),
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: _controller.subjects.length,
                    itemBuilder: (context, index) {
                      final subject = _controller.subjects[index];
                      return SubjectCard(
                        subject: subject,
                        onTap: () async {
                          // Show interstitial ad occasionally
                          if (index % 3 == 0) {
                            await _adManager.showInterstitial();
                          }

                          Get.to(() => QuestionsScreen(
                                subjectId: subject.id!,
                                subjectName: subject.subjectName!,
                              ));
                        },
                      );
                    },
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
}
