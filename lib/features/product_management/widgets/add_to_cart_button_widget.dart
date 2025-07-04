import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';

class AddToCartSection extends StatelessWidget {
  final ProductModel product;
  final int quantity;
  final VoidCallback onAddToCart;

  const AddToCartSection({
    super.key,
    required this.product,
    required this.quantity,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: SizedBox(
        height: 55.h,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: product.productQuantity <= 0 ? null : onAddToCart,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.r),
            ),
            backgroundColor:
                product.productQuantity <= 0 ? AppColors.textDisabled : null,
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient:
                  product.productQuantity <= 0
                      ? null
                      : LinearGradient(
                        colors: [
                          AppColors.bottomNavColor,
                          const Color.fromARGB(255, 144, 166, 177),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
              borderRadius: BorderRadius.circular(35.r),
            ),
            child: Container(
              alignment: Alignment.center,
              height: 55.h,
              child: Text(
                product.productQuantity <= 0 ? 'Out of Stock' : 'Add to Cart',
                style: TextStyle(
                  fontSize: 22.sp,
                  color:
                      product.productQuantity <= 0
                          ? AppColors.error
                          : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
