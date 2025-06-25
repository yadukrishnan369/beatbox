import 'package:beatbox/features/sales_management/widgets/billing_discount_section.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:beatbox/utils/gst_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';

class BillingSummarySection extends StatelessWidget {
  final double subtotal;
  final double gst;
  final double gstRate;
  final TextEditingController discountController;
  final double grandTotal;
  final VoidCallback onDiscountChanged;

  const BillingSummarySection({
    required this.subtotal,
    required this.gst,
    required this.gstRate,
    required this.discountController,
    required this.grandTotal,
    required this.onDiscountChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final gstPercentage = GSTUtils.getGSTPercentage();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.attach_money, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              "Billing Summary",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.contColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              _buildSummaryRow(
                "Total before GST",
                "₹${AmountFormatter.format(subtotal)}",
              ),
              SizedBox(height: 8.h),
              _buildSummaryRow(
                "GST charges (${gstPercentage.toStringAsFixed(0)}%)",
                "₹${AmountFormatter.format(gst)}",
              ),
              SizedBox(height: 8.h),
              BillingDiscountSection(
                discountController: discountController,
                subtotal: subtotal,
                gst: gst,
                onDiscountChanged: onDiscountChanged,
                context: context,
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "GRAND TOTAL",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "₹${AmountFormatter.format(grandTotal)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14.sp)),
        Text(
          value,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
