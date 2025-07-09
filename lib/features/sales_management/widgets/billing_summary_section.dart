import 'package:beatbox/features/sales_management/widgets/billing_discount_section.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:beatbox/utils/gst_utils.dart';
import 'package:beatbox/utils/responsive_utils.dart';
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
    final bool isWeb = Responsive.isDesktop(context);
    final gstPercentage = GSTUtils.getGSTPercentage();

    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isWeb ? 200.w : double.infinity),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.attach_money, size: isWeb ? 8.sp : 20.sp),
                SizedBox(width: isWeb ? 3.w : 8.w),
                Text(
                  "Billing Summary",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: isWeb ? 6.sp : 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: isWeb ? 8.h : 12.h),
            Container(
              padding: EdgeInsets.all(isWeb ? 6.w : 16.w),
              decoration: BoxDecoration(
                color: AppColors.contColor,
                borderRadius: BorderRadius.circular(isWeb ? 8.r : 12.r),
              ),
              child: Column(
                children: [
                  _buildSummaryRow(
                    isWeb,
                    "Total before GST",
                    "₹${AmountFormatter.format(subtotal)}",
                  ),
                  SizedBox(height: isWeb ? 6.h : 8.h),
                  _buildSummaryRow(
                    isWeb,
                    "GST charges (${gstPercentage.toStringAsFixed(0)}%)",
                    "₹${AmountFormatter.format(gst)}",
                  ),
                  SizedBox(height: isWeb ? 6.h : 8.h),
                  BillingDiscountSection(
                    discountController: discountController,
                    subtotal: subtotal,
                    gst: gst,
                    onDiscountChanged: onDiscountChanged,
                  ),
                  SizedBox(height: isWeb ? 6.h : 16.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWeb ? 5.w : 12.w,
                      vertical: isWeb ? 5.h : 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(isWeb ? 6.r : 8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "GRAND TOTAL",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isWeb ? 7.sp : 15.sp,
                          ),
                        ),
                        Text(
                          "₹${AmountFormatter.format(grandTotal)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isWeb ? 7.sp : 15.sp,
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
        ),
      ),
    );
  }

  Widget _buildSummaryRow(bool isWeb, String label, String value) {
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
            color: AppColors.error,
            fontSize: isWeb ? 6.sp : 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
