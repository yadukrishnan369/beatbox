import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:intl/intl.dart';

class SaleSummaryCard extends StatelessWidget {
  final SalesModel sale;

  const SaleSummaryCard({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    final billingDate = sale.billingDate;
    final bool isWeb = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isWeb ? 18 : 16.w),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(isWeb ? 10 : 12.r),
        border: Border.all(color: AppColors.primary, width: isWeb ? 1.5 : 2.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow('Invoice ID', sale.invoiceNumber, isWeb),
          _buildRow(
            'Date',
            DateFormat('dd MMM yyyy').format(billingDate),
            isWeb,
          ),
          _buildRow('Time', DateFormat('hh:mm a').format(billingDate), isWeb),
          _buildRow(
            'Total Amount',
            '₹${AmountFormatter.format(sale.subtotal)}',
            isWeb,
          ),
          _buildRow('GST', '₹${AmountFormatter.format(sale.gst)}', isWeb),
          _buildRow(
            'Discount',
            '₹${AmountFormatter.format(sale.discount)}',
            isWeb,
          ),
          _buildRow(
            'Grand Total',
            '₹${AmountFormatter.format(sale.grandTotal)}',
            isWeb,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, bool isWeb) {
    return Padding(
      padding: EdgeInsets.only(bottom: isWeb ? 14 : 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: isWeb ? 140 : 120.w,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: isWeb ? 14 : 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            ': ',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: isWeb ? 14 : 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: isWeb ? 14 : 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
