import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:beatbox/utils/billing_utils.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillingDiscountSection extends StatelessWidget {
  const BillingDiscountSection({
    super.key,
    required this.discountController,
    required this.subtotal,
    required this.gst,
    required this.onDiscountChanged,
  });

  final TextEditingController discountController;
  final double subtotal;
  final double gst;
  final VoidCallback onDiscountChanged;

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);
    double discountValue = 0.0;
    final percentage = double.tryParse(discountController.text.trim());
    if (percentage != null && percentage > 0 && percentage < 100) {
      discountValue = ((subtotal + gst) * percentage) / 100;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Discount (%)",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: isWeb ? 6.sp : 14.sp,
              ),
            ),
            SizedBox(
              width: isWeb ? 60.w : 125.w,
              height: isWeb ? 35.h : 45.h,
              child: TextFormField(
                controller: discountController,
                style: TextStyle(color: AppColors.textPrimary),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textAlign: TextAlign.right,
                onChanged: (_) => onDiscountChanged(),
                validator: BillingUtils.validateDiscount,
                decoration: InputDecoration(
                  hintText: "0.0",
                  suffixText: "%",
                  hintStyle: TextStyle(
                    color: AppColors.textDisabled,
                    fontSize: isWeb ? 3.sp : 12.sp,
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(isWeb ? 5.r : 6.r),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isWeb ? 3.w : 8.w,
                    vertical: isWeb ? 3.h : 8.h,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: isWeb ? 2.h : 4.h),
        if (discountValue > 0)
          Text(
            "Discount Rate ₹${AmountFormatter.format(discountValue)}",
            style: TextStyle(
              fontSize: isWeb ? 5.sp : 12.sp,
              color: AppColors.success,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}
