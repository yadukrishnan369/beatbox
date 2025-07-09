import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:beatbox/utils/gst_utils.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillTotalSection extends StatelessWidget {
  final SalesModel bill;

  const BillTotalSection({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);
    final gstPercentage = GSTUtils.getGSTPercentage();

    return Column(
      children: [
        // subtotal
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isWeb ? 6.w : 0,
            vertical: isWeb ? 3.h : 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: isWeb ? 6.sp : 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '₹ ${AmountFormatter.format(bill.subtotal)}',
                style: TextStyle(
                  fontSize: isWeb ? 6.sp : 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: isWeb ? 4.h : 8.h),

        // gst
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isWeb ? 6.w : 0,
            vertical: isWeb ? 3.h : 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GST Charges (${gstPercentage.toStringAsFixed(0)}%)',
                style: TextStyle(
                  fontSize: isWeb ? 6.sp : 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '₹ ${AmountFormatter.format(bill.gst)}',
                style: TextStyle(
                  fontSize: isWeb ? 6.sp : 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: isWeb ? 4.h : 8.h),

        // discount
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isWeb ? 6.w : 0,
            vertical: isWeb ? 3.h : 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discounts',
                style: TextStyle(
                  fontSize: isWeb ? 6.sp : 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '₹ ${AmountFormatter.format(bill.discount)}',
                style: TextStyle(
                  fontSize: isWeb ? 6.sp : 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: isWeb ? 10.h : 16.h),

        // grand total
        Container(
          padding: EdgeInsets.symmetric(
            vertical: isWeb ? 10.h : 12.h,
            horizontal: isWeb ? 12.w : 16.w,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(isWeb ? 6.r : 8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GRAND TOTAL',
                style: TextStyle(
                  fontSize: isWeb ? 6.sp : 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[800],
                ),
              ),
              Text(
                '₹ ${AmountFormatter.format(bill.grandTotal)}',
                style: TextStyle(
                  fontSize: isWeb ? 6.sp : 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
