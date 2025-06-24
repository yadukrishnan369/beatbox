import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';

class SaleSummaryCard extends StatelessWidget {
  final SalesModel sale;

  const SaleSummaryCard({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    final billingDate = sale.billingDate;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary, width: 2.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow('Invoice ID', sale.invoiceNumber),
          _buildRow(
            'Date',
            '${billingDate.day}-${billingDate.month.toString().padLeft(2, '0')}-${billingDate.year}',
          ),
          _buildRow(
            'Time',
            '${billingDate.hour.toString().padLeft(2, '0')}:${billingDate.minute.toString().padLeft(2, '0')} ${billingDate.hour >= 12 ? 'PM' : 'AM'}',
          ),
          _buildRow(
            'Total Amount',
            '₹${AmountFormatter.format(sale.subtotal)}',
          ),
          _buildRow('GST', '₹${AmountFormatter.format(sale.gst)}'),
          _buildRow('Discount', '₹${AmountFormatter.format(sale.discount)}'),
          _buildRow(
            'Grand Total',
            '₹${AmountFormatter.format(sale.grandTotal)}',
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            ': ',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
