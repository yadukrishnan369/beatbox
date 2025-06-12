import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';

class TotalSalesCard extends StatelessWidget {
  const TotalSalesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.blue,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total sales',
              style: TextStyle(fontSize: 16.sp, color: AppColors.white),
            ),
            SizedBox(height: 8.h),
            Text(
              '31',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
