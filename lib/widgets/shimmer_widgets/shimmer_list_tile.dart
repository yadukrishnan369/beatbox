import 'package:beatbox/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({super.key});

  // shimmer base color based on theme
  Color getBaseColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[700]!
        : Colors.grey[300]!;
  }

  // shimmer highlight color based on theme
  Color getHighlightColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[500]!
        : Colors.grey[100]!;
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: getBaseColor(context),
      highlightColor: getHighlightColor(context),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14.h,
                    width: 100.w,
                    color: getBaseColor(context),
                  ),
                ],
              ),
            ),
            // Divider
            Container(
              width: 1.w,
              height: 40.h,
              color: getBaseColor(context),
              margin: EdgeInsets.symmetric(horizontal: 16.w),
            ),
          ],
        ),
      ),
    );
  }
}
