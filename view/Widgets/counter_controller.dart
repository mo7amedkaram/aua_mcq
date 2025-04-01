import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors.dart';

class CounterControl extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final String? suffix;

  const CounterControl({
    required this.label,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
    this.suffix,
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
          height: 48.sp,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8.sp),
          ),
          child: Row(
            children: [
              // Decrement button
              _buildButton(
                icon: Icons.remove,
                onTap: onDecrement,
                alignment: Alignment.centerLeft,
              ),

              // Value display
              Expanded(
                child: Center(
                  child: Text(
                    suffix != null ? "$value $suffix" : "$value",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),

              // Increment button
              _buildButton(
                icon: Icons.add,
                onTap: onIncrement,
                alignment: Alignment.centerRight,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onTap,
    required Alignment alignment,
  }) {
    return Container(
      width: 48.sp,
      height: 48.sp,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.horizontal(
          left: alignment == Alignment.centerLeft
              ? Radius.circular(8.sp)
              : Radius.zero,
          right: alignment == Alignment.centerRight
              ? Radius.circular(8.sp)
              : Radius.zero,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.horizontal(
          left: alignment == Alignment.centerLeft
              ? Radius.circular(8.sp)
              : Radius.zero,
          right: alignment == Alignment.centerRight
              ? Radius.circular(8.sp)
              : Radius.zero,
        ),
        child: Icon(
          icon,
          color: Colors.black,
          size: 24.sp,
        ),
      ),
    );
  }
}
