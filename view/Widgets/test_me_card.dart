import 'package:aua_questions_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TestMeCard extends StatelessWidget {
  final VoidCallback onTap;

  const TestMeCard({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
        height: 120.sp,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.secondary,
              AppColors.secondary.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16.sp),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withOpacity(0.4),
              blurRadius: 8.sp,
              offset: Offset(0, 4.sp),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 24.sp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Take a Test',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.sp),
                  Text(
                    'Create personalized tests to challenge yourself',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 80.sp,
              height: 80.sp,
              child: Icon(
                Icons.quiz_outlined,
                size: 48.sp,
                color: Colors.black87,
              ),
            ),
            SizedBox(width: 16.sp),
          ],
        ),
      ),
    );
  }
}
