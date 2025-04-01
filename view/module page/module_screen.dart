import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../utils/app_ad_manager.dart';
import '../Subjects Page/subject_page.dart';
import '../widgets/module_card.dart';
import 'module_controller.dart';

class ModulesScreen extends StatefulWidget {
  final String gradeId;
  final String gradeName;

  const ModulesScreen({
    required this.gradeId,
    required this.gradeName,
    super.key,
  });

  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  late final ModulesController _controller;
  final AppAdManager _adManager = AppAdManager();

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ModulesController(gradeId: widget.gradeId));
    _adManager.loadBannerAd();
    _adManager.loadInterstitialAd();

    print(widget.gradeId);
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
        title: Text(widget.gradeName),
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (_controller.modules.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book_outlined,
                          size: 64.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16.sp),
                        Text(
                          "No modules available",
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
                  onRefresh: () => _controller.fetchModules(),
                  child: Padding(
                    padding: EdgeInsets.all(16.sp),
                    child: GridView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 8.sp,
                        mainAxisSpacing: 8.sp,
                      ),
                      itemCount: _controller.modules.length,
                      itemBuilder: (context, index) {
                        final module = _controller.modules[index];
                        return ModuleCard(
                          module: module,
                          onTap: () async {
                            // Show interstitial ad occasionally when navigating between screens
                            if (index % 3 == 0) {
                              await _adManager.showInterstitial();
                            }

                            Get.to(() => SubjectsScreen(
                                  moduleId: module.id!,
                                  moduleName: module.moduleName!,
                                ));
                          },
                        );
                      },
                    ),
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
