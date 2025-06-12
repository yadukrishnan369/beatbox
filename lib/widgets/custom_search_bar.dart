import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final VoidCallback? onFilterTap;
  final bool showFilterIcon;
  final FocusNode? focusNode;

  const CustomSearchBar({
    super.key,
    this.hintText = 'Search product...',
    this.controller,
    this.onChanged,
    this.onFilterTap,
    this.showFilterIcon = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      padding: EdgeInsets.only(left: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.textDisabled,
            blurRadius: 5.r,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SizedBox(
        height: 50.h,
        child: Row(
          children: [
            Icon(Icons.search, color: AppColors.textPrimary, size: 28.sp),
            SizedBox(width: 6.w),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                ),
              ),
            ),
            if (showFilterIcon)
              IconButton(
                icon: Icon(
                  Icons.filter_list,
                  color: AppColors.textPrimary,
                  size: 24.sp,
                ),
                onPressed: onFilterTap,
              ),
          ],
        ),
      ),
    );
  }
}
