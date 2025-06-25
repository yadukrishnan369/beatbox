import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:beatbox/utils/gst_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillTotalSection extends StatelessWidget {
  final SalesModel bill;

  const BillTotalSection({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    final gstPercentage = GSTUtils.getGSTPercentage();

    return Column(
      children: [
        _buildRow('Total', bill.subtotal),
        SizedBox(height: 8.h),
        _buildRow(
          'GST Charges (${gstPercentage.toStringAsFixed(0)}%)',
          bill.gst,
        ),
        SizedBox(height: 8.h),
        _buildRow('Discounts', bill.discount),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GRAND TOTAL',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[800],
                ),
              ),
              Text(
                AmountFormatter.format(bill.grandTotal),
                style: TextStyle(
                  fontSize: 16.sp,
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

  Widget _buildRow(String title, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          AmountFormatter.format(value),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.error,
          ),
        ),
      ],
    );
  }
}
