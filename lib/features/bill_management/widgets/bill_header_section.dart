import 'package:beatbox/constants/app_images.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillHeaderSection extends StatelessWidget {
  final SalesModel bill;

  const BillHeaderSection({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Invoice Number
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Invoice Number : ${bill.invoiceNumber}',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),

        // Logo and Name
        Row(
          children: [
            SizedBox(
              width: 45.w,
              height: 45.h,
              child: Image.asset(AppImages.logo),
            ),
            SizedBox(width: 16.w),
            Text(
              'BEATBOXX',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),

        // INVOICE Title
        Text(
          'INVOICE',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 15.h),

        // Date
        Text(
          'Date: ${bill.billingDate.day}-${bill.billingDate.month.toString().padLeft(2, '0')}-${bill.billingDate.year}',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 10.h),

        // Customer Info
        Text(
          'Billed to :',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          bill.customerName,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          'phone : ${bill.customerPhone}',
          style: TextStyle(fontSize: 12.sp, color: AppColors.textPrimary),
        ),
        Text(
          bill.customerEmail,
          style: TextStyle(fontSize: 12.sp, color: AppColors.textPrimary),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
