import 'package:beatbox/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillingTextFormField extends StatelessWidget {
  const BillingTextFormField({
    super.key,
    required this.isWeb,
    required this.label,
    required this.hint,
    required this.controller,
    required this.validator,
  });

  final bool isWeb;
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String? p1)? validator;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: isWeb ? 25.w : 60.w,
          child: Text(label, style: TextStyle(color: AppColors.textPrimary)),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: TextFormField(
            controller: controller,
            style: TextStyle(color: AppColors.textPrimary),
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.textDisabled,
                fontSize: isWeb ? 6.sp : 14.sp,
              ),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isWeb ? 3.r : 8.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: isWeb ? 5.w : 12.w,
                vertical: isWeb ? 3.h : 8.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
