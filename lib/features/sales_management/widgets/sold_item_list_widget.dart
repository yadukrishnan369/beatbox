import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SoldItemListTile extends StatelessWidget {
  const SoldItemListTile({super.key, required this.sale});

  final SalesModel sale;

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

    return Container(
      margin: EdgeInsets.only(bottom: isWeb ? 6.h : 12.h),
      padding: EdgeInsets.symmetric(
        horizontal: isWeb ? 5.w : 16.r,
        vertical: isWeb ? 10.h : 16.r,
      ),
      decoration: BoxDecoration(
        color: AppColors.contColor,
        borderRadius: BorderRadius.circular(isWeb ? 10.r : 12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sale.customerName,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: isWeb ? 5.sp : 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: isWeb ? 3.h : 4.h),
                Text(
                  sale.orderNumber,
                  style: TextStyle(
                    color: AppColors.textDisabled,
                    fontSize: isWeb ? 5.sp : 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1.w,
            height: isWeb ? 38.h : 40.h,
            color: AppColors.white,
            margin: EdgeInsets.symmetric(horizontal: isWeb ? 14.w : 16.w),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Amount',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: isWeb ? 5.sp : 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: isWeb ? 3.h : 4.h),
                Text(
                  '₹ ${AmountFormatter.format(sale.grandTotal)}',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: isWeb ? 6.sp : 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.list,
            color: AppColors.primary,
            size: isWeb ? 10.sp : 20.sp,
          ),
        ],
      ),
    );
  }
}
