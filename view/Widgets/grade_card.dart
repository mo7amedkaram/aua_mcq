import 'package:aua_questions_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Model/grades model/grades_model.dart';

class GradeCard extends StatelessWidget {
  final GradeModel grade;
  final VoidCallback onTap;

  const GradeCard({
    required this.grade,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8.sp),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(16.sp),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.sp,
              offset: Offset(0, 4.sp),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90.sp,
              height: 90.sp,
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school,
                size: 60.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12.sp),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.sp),
              child: Text(
                grade.gradeName ?? 'Unknown Grade',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
