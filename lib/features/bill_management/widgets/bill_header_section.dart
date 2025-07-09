import 'package:beatbox/constants/app_images.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillHeaderSection extends StatelessWidget {
  final SalesModel bill;

  const BillHeaderSection({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // invoice number
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Invoice Number : ${bill.invoiceNumber}',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: isWeb ? 5.sp : 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: isWeb ? 6.h : 20.h),

        // logo and name
        Row(
          children: [
            SizedBox(
              width: isWeb ? 50.w : 45.w,
              height: isWeb ? 50.h : 45.h,
              child: Image.asset(AppImages.logo),
            ),
            SizedBox(width: isWeb ? 6.w : 16.w),
            Text(
              'BEATBOXX',
              style: TextStyle(
                fontSize: isWeb ? 10.sp : 24.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: isWeb ? 6.h : 20.h),

        // invoice title
        Text(
          'INVOICE',
          style: TextStyle(
            fontSize: isWeb ? 10.sp : 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: isWeb ? 5.h : 15.h),

        // date & order no
        Text(
          'Date: ${bill.billingDate.day}-${bill.billingDate.month.toString().padLeft(2, '0')}-${bill.billingDate.year}',
          style: TextStyle(
            fontSize: isWeb ? 6.sp : 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          'Order no: ${bill.orderNumber}',
          style: TextStyle(
            fontSize: isWeb ? 5.sp : 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: isWeb ? 4.h : 10.h),

        // customer info
        Text(
          'Billed to :',
          style: TextStyle(
            fontSize: isWeb ? 6.sp : 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: isWeb ? 2.h : 4.h),
        Text(
          bill.customerName,
          style: TextStyle(
            fontSize: isWeb ? 6.sp : 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          'phone : ${bill.customerPhone}',
          style: TextStyle(
            fontSize: isWeb ? 5.sp : 12.sp,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          bill.customerEmail,
          style: TextStyle(
            fontSize: isWeb ? 5.sp : 12.sp,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: isWeb ? 6.h : 20.h),
      ],
    );
  }
}
