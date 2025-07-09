import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';

class InvoiceInfoSection extends StatelessWidget {
  final String invoiceNumber;
  final String billingDate;
  final int itemCount;

  const InvoiceInfoSection({
    required this.invoiceNumber,
    required this.billingDate,
    required this.itemCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isWeb ? 200.w : double.infinity),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt_outlined, size: isWeb ? 8.sp : 20.sp),
                SizedBox(width: isWeb ? 3.w : 8.w),
                Text(
                  "Invoice Info",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: isWeb ? 7.sp : 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: isWeb ? 4.h : 12.h),
            Container(
              padding: EdgeInsets.all(isWeb ? 6.w : 16.w),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(isWeb ? 5.r : 12.r),
              ),
              child: Column(
                children: [
                  _buildInfoRow("Invoice Number", invoiceNumber, isWeb),
                  SizedBox(height: isWeb ? 6.h : 8.h),
                  _buildInfoRow("Date", billingDate, isWeb),
                  SizedBox(height: isWeb ? 6.h : 8.h),
                  _buildInfoRow("Items", itemCount.toString(), isWeb),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isWeb) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: isWeb ? 6.sp : 14.sp,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: isWeb ? 6.sp : 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
