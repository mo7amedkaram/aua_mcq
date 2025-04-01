import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors.dart';

class DropdownSelection<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) getLabel;
  final Function(T?) onChanged;
  final String hintText;
  final bool isLoading;

  const DropdownSelection({
    required this.label,
    required this.value,
    required this.items,
    required this.getLabel,
    required this.onChanged,
    required this.hintText,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.sp),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8.sp),
          ),
          child: isLoading
              ? _buildLoadingIndicator()
              : DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    isExpanded: true,
                    value: value,
                    hint: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.sp),
                      child: Text(
                        hintText,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    icon: Padding(
                      padding: EdgeInsets.only(right: 16.sp),
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.primary,
                        size: 24.sp,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8.sp),
                    borderRadius: BorderRadius.circular(8.sp),
                    onChanged: onChanged,
                    items: items.map((T item) {
                      return DropdownMenuItem<T>(
                        value: item,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.sp),
                          child: Text(
                            getLabel(item),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 48.sp,
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      child: Row(
        children: [
          Text(
            hintText,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey.shade600,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 24.sp,
            height: 24.sp,
            child: CircularProgressIndicator(
              strokeWidth: 2.sp,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
