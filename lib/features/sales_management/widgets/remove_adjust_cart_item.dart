import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/sales_management/model/cart_item_model.dart';
import 'package:beatbox/utils/cart_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RemoveAndAdjustItem extends StatelessWidget {
  const RemoveAndAdjustItem({super.key, required this.item});

  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // quantity controls
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
                  // decrease quantity logic
                  if (item.quantity > 1) {
                    CartUtils.changeQuantity(item.product, item.quantity - 1);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  child: Icon(
                    Icons.remove,
                    color: AppColors.white,
                    size: 16.sp,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                child: Text(
                  '${item.quantity}',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // increase quantity logic
                  if (item.quantity < item.product.productQuantity) {
                    CartUtils.changeQuantity(item.product, item.quantity + 1);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Only ${item.product.productQuantity} items available",
                        ),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  child: Icon(Icons.add, color: AppColors.white, size: 16.sp),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),

        // remove Button
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: AppColors.white,
                  title: Text(
                    'Confirmation',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  content: Text('Are you sure you want to remove this item?'),
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
                );
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              'Remove',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
