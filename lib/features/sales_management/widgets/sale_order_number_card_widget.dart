import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OrderNumberCardWidget extends StatelessWidget {
  final SalesModel sale;

  const OrderNumberCardWidget({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isWeb ? 18 : 16.w),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(isWeb ? 10 : 12.r),
        border: Border.all(color: AppColors.primary, width: isWeb ? 1.5 : 2.w),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // order number column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Number',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: isWeb ? 13 : 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: isWeb ? 6 : 4.h),
                Text(
                  sale.orderNumber,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: isWeb ? 15 : 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // vertical divider
          Container(
            width: isWeb ? 1 : 1.w,
            height: isWeb ? 45 : 40.h,
            color: AppColors.white,
            margin: EdgeInsets.symmetric(horizontal: isWeb ? 18 : 16.w),
          ),

          // date Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: isWeb ? 13 : 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: isWeb ? 6 : 4.h),
                Text(
                  DateFormat('dd MMM yyyy').format(sale.billingDate),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: isWeb ? 15 : 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
