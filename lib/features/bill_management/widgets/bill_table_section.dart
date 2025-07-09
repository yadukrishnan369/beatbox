import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillTableSection extends StatelessWidget {
  final SalesModel bill;

  const BillTableSection({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textPrimary, width: 0.5.w),
        borderRadius: BorderRadius.circular(isWeb ? 6.r : 8.r),
      ),
      child: Column(
        children: [
          // table header
          Container(
            padding: EdgeInsets.symmetric(
              vertical: isWeb ? 6.h : 10.h,
              horizontal: isWeb ? 8.w : 12.w,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isWeb ? 6.r : 8.r),
                topRight: Radius.circular(isWeb ? 6.r : 8.r),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Item',
                    style: TextStyle(
                      fontSize: isWeb ? 7.sp : 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Qty',
                    style: TextStyle(
                      fontSize: isWeb ? 7.sp : 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Price',
                    style: TextStyle(
                      fontSize: isWeb ? 7.sp : 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Sub-total',
                    style: TextStyle(
                      fontSize: isWeb ? 7.sp : 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),

          // table row
          for (var item in bill.cartItems)
            Container(
              padding: EdgeInsets.symmetric(
                vertical: isWeb ? 6.h : 10.h,
                horizontal: isWeb ? 8.w : 12.w,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.textPrimary,
                    width: 0.5.w,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      item.product.productName,
                      style: TextStyle(
                        fontSize: isWeb ? 5.sp : 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.quantity.toString(),
                      style: TextStyle(
                        fontSize: isWeb ? 5.sp : 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      '₹ ${item.product.salePrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: isWeb ? 5.sp : 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      '₹ ${(item.product.salePrice * item.quantity).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: isWeb ? 5.sp : 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.error,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
