import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillItemCard extends StatelessWidget {
  final SalesModel bill;

  const BillItemCard({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb =
            Responsive.isDesktop(context) || constraints.maxWidth > 600;

        return Container(
          margin: EdgeInsets.only(bottom: isWeb ? 5.h : 12.h),
          padding: EdgeInsets.all(isWeb ? 6.w : 16.w),
          decoration: BoxDecoration(
            color: AppColors.contColor,
            borderRadius: BorderRadius.circular(isWeb ? 8.r : 12.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invoice Number : ${bill.invoiceNumber}',
                      style: TextStyle(
                        fontSize: isWeb ? 4.sp : 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: isWeb ? 2.h : 4.h),
                    Text(
                      bill.customerName,
                      style: TextStyle(
                        fontSize: isWeb ? 4.sp : 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: isWeb ? 2.h : 4.h),
                    Text(
                      'Date of Billing : ${bill.billingDate.day}-${bill.billingDate.month.toString().padLeft(2, '0')}-${bill.billingDate.year}',
                      style: TextStyle(
                        fontSize: isWeb ? 4.sp : 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: isWeb ? 6.w : 8.w),
              Icon(
                Icons.more,
                color: AppColors.textPrimary,
                size: isWeb ? 8.sp : 20.sp,
              ),
            ],
          ),
        );
      },
    );
  }
}
