import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/sales_management/controller/sales_controller.dart';

class TotalSalesCard extends StatelessWidget {
  const TotalSalesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final totalSales = SalesController.getSalesCount();
    final totalItems = SalesController.getTotalSoldItems();

    return Card(
      color: AppColors.blue,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Sales',
                style: TextStyle(fontSize: 16.sp, color: AppColors.white),
              ),
              SizedBox(height: 8.h),
              Text(
                '$totalSales transactions',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              Text(
                '$totalItems items',
                style: TextStyle(fontSize: 16.sp, color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
