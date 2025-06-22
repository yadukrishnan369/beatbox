import 'package:beatbox/utils/amount_formatter.dart';
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
                "GST charges (${(gstRate * 100).toStringAsFixed(1)}%)",
                "₹${AmountFormatter.format(gst)}",
              ),
              SizedBox(height: 8.h),
              _buildDiscountField(context),
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

  Widget _buildDiscountField(BuildContext context) {
    double discountValue = 0.0;
    final percentage = double.tryParse(discountController.text.trim());
    if (percentage != null && percentage > 0 && percentage <= 100) {
      discountValue = ((subtotal + gst) * percentage) / 100;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Discount (%)", style: TextStyle(fontSize: 14.sp)),
            SizedBox(
              width: 120.w,
              height: 45.h,
              child: TextField(
                controller: discountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textAlign: TextAlign.right,
                onChanged: (_) {
                  onDiscountChanged();
                },
                decoration: InputDecoration(
                  hintText: "0.0",
                  suffixText: "%",
                  hintStyle: TextStyle(
                    color: AppColors.textDisabled,
                    fontSize: 12.sp,
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.r),
                    borderSide: BorderSide(color: AppColors.primary, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.r),
                    borderSide: BorderSide(color: AppColors.primary, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.r),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 8.h,
                  ),
                ),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),

        if (discountValue > 0)
          Text(
            "Discount Rate ₹${AmountFormatter.format(discountValue)}",
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.success,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}
