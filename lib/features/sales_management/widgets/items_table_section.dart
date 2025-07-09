import 'package:beatbox/utils/amount_formatter.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/sales_management/model/cart_item_model.dart';

class ItemsTableSection extends StatelessWidget {
  final List<CartItemModel> cartItems;

  const ItemsTableSection({required this.cartItems, super.key});

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isWeb ? 200.w : double.infinity),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.inventory_2_outlined, size: isWeb ? 8.sp : 20.sp),
                SizedBox(width: isWeb ? 6.w : 8.w),
                Text(
                  "Item Details",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: isWeb ? 7.sp : 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: isWeb ? 4.h : 12.h),
            Container(
              decoration: BoxDecoration(
                color: AppColors.contColor,
                borderRadius: BorderRadius.circular(isWeb ? 8.r : 12.r),
              ),
              child: Column(
                children: [
                  // table header
                  Container(
                    padding: EdgeInsets.all(isWeb ? 6.w : 16.w),
                    decoration: BoxDecoration(
                      color: AppColors.contColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isWeb ? 8.r : 12.r),
                        topRight: Radius.circular(isWeb ? 8.r : 12.r),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            "Item",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: isWeb ? 6.sp : 14.sp,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Qty",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: isWeb ? 6.sp : 14.sp,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Price",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: isWeb ? 6.sp : 14.sp,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Sub-Total",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: isWeb ? 6.sp : 14.sp,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1.h, color: AppColors.textDisabled),
                  // items list
                  ...cartItems.map((item) => _buildItemRow(item, isWeb)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(CartItemModel item, bool isWeb) {
    return Container(
      padding: EdgeInsets.all(isWeb ? 6.w : 16.w),
      decoration: BoxDecoration(color: AppColors.cardColor),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              item.product.productName,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: isWeb ? 6.sp : 14.sp,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              item.quantity.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: isWeb ? 6.sp : 14.sp,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "₹${AmountFormatter.format(item.product.salePrice)}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.error,
                fontSize: isWeb ? 6.sp : 14.sp,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "₹${AmountFormatter.format((item.product.salePrice * item.quantity))}",
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.error,
                fontSize: isWeb ? 6.sp : 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
