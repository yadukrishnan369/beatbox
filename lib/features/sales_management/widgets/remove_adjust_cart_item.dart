import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/sales_management/model/cart_item_model.dart';
import 'package:beatbox/utils/cart_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RemoveAndAdjustItem extends StatelessWidget {
  const RemoveAndAdjustItem({
    super.key,
    required this.item,
    this.isWeb = false,
  });

  final CartItemModel item;
  final bool isWeb;

  @override
  Widget build(BuildContext context) {
    final double iconSize = isWeb ? 6.sp : 16.sp;
    final double qtyFont = isWeb ? 4.sp : 14.sp;
    final double removeFont = isWeb ? 4.sp : 12.sp;
    final double removePaddingH = isWeb ? 2.w : 12.w;
    final double removePaddingV = isWeb ? 2.h : 4.h;
    final double qtyPaddingH = isWeb ? 2.w : 12.w;
    final double qtyPaddingV = isWeb ? 2.h : 4.h;

    return Column(
      children: [
        // qnty controls
        Container(
          decoration: BoxDecoration(
            color: AppColors.bottomNavColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  if (item.quantity > 1) {
                    CartUtils.changeQuantity(item.product, item.quantity - 1);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: iconSize,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: qtyPaddingH,
                  vertical: qtyPaddingV,
                ),
                child: Text(
                  '${item.quantity}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: qtyFont,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (item.quantity < item.product.productQuantity) {
                    CartUtils.changeQuantity(item.product, item.quantity + 1);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Only ${item.product.productQuantity} items available",
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  child: Icon(Icons.add, color: Colors.white, size: iconSize),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: isWeb ? 6.h : 8.h),

        // remove button
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text(
                      'Confirmation',
                      style: TextStyle(color: AppColors.primary),
                    ),
                    content: Text(
                      'Are you sure you want to remove this item?',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          CartUtils.removeProductFromCart(item.product);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Remove',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: removePaddingH,
              vertical: removePaddingV,
            ),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              'Remove',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: removeFont,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
