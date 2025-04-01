import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../database/database.dart';
import '../Favourite Screen/favourite_screen.dart';
import '../TestMe Screen/testme_screen.dart';
import '../module page/module_screen.dart';
import '../widgets/grade_card.dart';
import '../widgets/test_me_card.dart';
import 'home_page_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize services if not already
    if (!Get.isRegistered<DatabaseService>()) {
      Get.put(DatabaseService());
    }

    _controller = Get.put(HomeController());
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.sp),
          ),
          child: Container(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "About AUA Questions",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 16.sp),
                Text(
                  "This app was developed to help medical students prepare for exams with comprehensive question banks.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.sp),
                ),
                SizedBox(height: 24.sp),
                Text(
                  "Developed by:",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListTile(
                  title: Text("Dr. Mansour Algazar"),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    // Launch social profile for Mansour
                  },
                ),
                ListTile(
                  title: Text("Mohamed Karam"),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    // Launch social profile for Mohamed
                  },
                ),
                SizedBox(height: 16.sp),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Close"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text("AUA Questions"),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () => Get.to(() => const FavoritesScreen()),
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _showAboutDialog,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _controller.fetchGrades(),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile section
              Padding(
                padding: EdgeInsets.all(16.sp),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30.sp,
                      backgroundImage: AssetImage("assets/images/profile.png"),
                    ),
                    SizedBox(width: 16.sp),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, Doctor",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                        Text(
                          "Welcome to AUA Questions",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Test Me card
              TestMeCard(
                onTap: () => Get.to(() => TestMeScreen()),
              ),

              SizedBox(height: 16.sp),

              // Grades section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.sp),
                    topRight: Radius.circular(32.sp),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Choose Your Grade",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 16.sp),
                      Obx(() {
                        if (_controller.isLoading.value) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (_controller.grades.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.sp),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.school_outlined,
                                    size: 64.sp,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16.sp),
                                  Text(
                                    "No grades available",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.85,
                            crossAxisSpacing: 8.sp,
                            mainAxisSpacing: 8.sp,
                          ),
                          itemCount: _controller.grades.length,
                          itemBuilder: (context, index) {
                            final grade = _controller.grades[index];
                            return GradeCard(
                              grade: grade,
                              onTap: () => Get.to(
                                () => ModulesScreen(
                                  gradeId: grade.id!,
                                  gradeName: grade.gradeName!,
                                ),
                              ),
                            );
                          },
                        );
                      }),
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
