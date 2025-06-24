import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/sales_management/model/cart_item_model.dart';
import 'package:beatbox/features/sales_management/widgets/remove_adjust_cart_item.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartProductList extends StatelessWidget {
  const CartProductList({super.key, required this.cartItems});

  final List<CartItemModel> cartItems;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.contColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              // Product Image
              Container(
                width: 70.w,
                height: 70.h,
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child:
                    item.product.image1 != null &&
                            item.product.image1!.isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.file(
                            File(item.product.image1!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.headphones,
                                color: AppColors.primary,
                                size: 30.sp,
                              );
                            },
                          ),
                        )
                        : Icon(
                          Icons.headphones,
                          color: AppColors.primary,
                          size: 30.sp,
                        ),
              ),
              SizedBox(width: 12.w),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.productName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      item.product.productCategory,
                      style: TextStyle(
                        color: AppColors.textDisabled,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'MRP ₹ ${AmountFormatter.format(item.product.salePrice)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                        color: AppColors.error,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Total ₹ ${AmountFormatter.format(item.totalPrice)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),

              // quantity controls and remove button
              RemoveAndAdjustItem(item: item),
            ],
          ),
        );
      },
    );
  }
}
