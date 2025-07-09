import 'dart:io';
import 'dart:convert';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/sales_management/model/cart_item_model.dart';
import 'package:beatbox/features/sales_management/widgets/remove_adjust_cart_item.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Uint8List? decodeBase64Image(String? base64String) {
  try {
    if (base64String == null || base64String.trim().isEmpty) return null;
    return base64Decode(base64String);
  } catch (e) {
    return null;
  }
}

class CartProductList extends StatelessWidget {
  const CartProductList({super.key, required this.cartItems});

  final List<CartItemModel> cartItems;

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];

        return Container(
          margin: EdgeInsets.only(bottom: isWeb ? 8.h : 12.h),
          padding: EdgeInsets.all(isWeb ? 10.r : 16.r),
          decoration: BoxDecoration(
            color: AppColors.contColor,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow:
                isWeb
                    ? [BoxShadow(color: Colors.black12, blurRadius: 2.r)]
                    : [],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // product image
              Container(
                width: isWeb ? 20.w : 70.w,
                height: isWeb ? 20.w : 70.w,
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child:
                      isWeb
                          ? _buildWebImage(item.product.webImage1)
                          : _buildMobileImage(item.product.image1),
                ),
              ),

              SizedBox(width: isWeb ? 12.w : 10.w),

              // product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.productName,
                      style: TextStyle(
                        fontSize: isWeb ? 6.sp : 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      item.product.productCategory,
                      style: TextStyle(
                        fontSize: isWeb ? 5.sp : 12.sp,
                        color: AppColors.textDisabled,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Text(
                          'MRP ₹${AmountFormatter.format(item.product.salePrice)}',
                          style: TextStyle(
                            fontSize: isWeb ? 4.sp : 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Total ₹${AmountFormatter.format(item.totalPrice)}',
                          style: TextStyle(
                            fontSize: isWeb ? 4.sp : 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: isWeb ? 8.w : 4.w),

              // qnty controls
              RemoveAndAdjustItem(item: item, isWeb: isWeb),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWebImage(String? base64Image) {
    final bytes = decodeBase64Image(base64Image);
    if (bytes != null) {
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _errorIcon(),
      );
    } else {
      return _errorIcon();
    }
  }

  Widget _buildMobileImage(String? filePath) {
    if (filePath != null &&
        filePath.isNotEmpty &&
        File(filePath).existsSync()) {
      return Image.file(
        File(filePath),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _errorIcon(),
      );
    } else {
      return _errorIcon();
    }
  }

  Widget _errorIcon() {
    return Center(
      child: Icon(
        Icons.headphones,
        color: AppColors.primary,
        size: kIsWeb ? 18.sp : 30.sp,
      ),
    );
  }
}
