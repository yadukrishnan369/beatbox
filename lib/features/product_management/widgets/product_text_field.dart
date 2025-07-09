import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';

class ProductTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLines;

  const ProductTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb =
            Responsive.isDesktop(context) || constraints.maxWidth > 600;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: isWeb ? 8.sp : 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 4.h),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWeb ? 200.w : double.infinity,
              ),
              child: TextFormField(
                controller: controller,
                style: TextStyle(color: AppColors.textPrimary),
                maxLines: maxLines,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(color: AppColors.textPrimary),
                  prefixIcon: Icon(icon),
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: AppColors.blue),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isWeb ? 14.w : 16.w,
                    vertical: isWeb ? 14.h : 16.h,
                  ),
                ),
                validator: validator,
              ),
            ),
            SizedBox(height: 16.h),
          ],
        );
      },
    );
  }
}
