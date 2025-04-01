import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Model/module_model/module_model.dart';
import '../../constants/colors.dart';

class ModuleCard extends StatelessWidget {
  final ModuleModel module;
  final VoidCallback onTap;

  const ModuleCard({
    required this.module,
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
        child: Padding(
          padding: EdgeInsets.all(12.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.sp),
                  child: Container(
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.sp),
                    ),
                    child: Icon(
                      Icons.view_module,
                      size: 40.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.sp),
              Text(
                module.moduleName ?? 'Unknown Module',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
