import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillingDiscountSection extends StatelessWidget {
  const BillingDiscountSection({
    super.key,
    required this.discountController,
    required this.subtotal,
    required this.gst,
    required this.onDiscountChanged,
    required this.context,
  });

  final TextEditingController discountController;
  final double subtotal;
  final double gst;
  final VoidCallback onDiscountChanged;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
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
