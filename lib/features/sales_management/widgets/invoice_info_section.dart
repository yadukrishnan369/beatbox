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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.receipt_outlined, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              "Invoice Info",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              _buildInfoRow("Invoice Number", invoiceNumber),
              SizedBox(height: 8.h),
              _buildInfoRow("Date", billingDate),
              SizedBox(height: 8.h),
              _buildInfoRow("Items", itemCount.toString()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 14.sp),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
