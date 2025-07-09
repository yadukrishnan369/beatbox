import 'package:beatbox/utils/responsive_utils.dart';
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
    final bool isWeb = Responsive.isDesktop(context);
    final double fontSizeTitle = isWeb ? 5.sp : 16.sp;
    final double fontSizeBig = isWeb ? 6.sp : 16.sp;
    final double paddingAll = isWeb ? 7.w : 16.w;

    return Card(
      color: AppColors.blue,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(paddingAll),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Sales',
                style: TextStyle(
                  fontSize: fontSizeTitle,
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                '$totalSales Records',
                style: TextStyle(
                  fontSize: fontSizeBig,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              Text(
                '$totalItems items',
                style: TextStyle(
                  fontSize: fontSizeTitle,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
