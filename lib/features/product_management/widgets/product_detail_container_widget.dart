import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:beatbox/utils/product_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsContainerWidget extends StatelessWidget {
  const ProductDetailsContainerWidget({
    super.key,
    required this.isWeb,
    required this.product,
    required this.fontTitle,
    required this.fontText,
    required this.iconSize,
    required this.onQuantityChanged,
    required this.quantity,
  });

  final bool isWeb;
  final ProductModel product;
  final double fontTitle;
  final double fontText;
  final double iconSize;
  final ValueChanged<int> onQuantityChanged;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 0),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.contColor,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.productName,
            style: TextStyle(
              fontSize: fontTitle,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            '${product.productCategory} | ${product.productBrand} | code-${product.productCode}',
            style: TextStyle(fontSize: fontText, color: AppColors.textPrimary),
          ),
          SizedBox(height: 10.h),
          Text(
            'MRP ₹ ${AmountFormatter.format(product.salePrice)}',
            style: TextStyle(
              fontSize: fontText,
              fontWeight: FontWeight.bold,
              color: AppColors.error,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            product.description,
            style: TextStyle(fontSize: fontText, color: AppColors.textPrimary),
          ),
          SizedBox(height: 16.h),

          // qnty adjust section
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  Icons.remove,
                  size: iconSize,
                  color: AppColors.textPrimary,
                ),
                onPressed: () {
                  onQuantityChanged(ProductUtils.decrementQuantity(quantity));
                },
              ),
              SizedBox(width: 10.w),
              Text(
                '$quantity',
                style: TextStyle(
                  fontSize: fontTitle,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: 10.w),
              IconButton(
                icon: Icon(
                  Icons.add,
                  size: iconSize,
                  color: AppColors.textPrimary,
                ),
                onPressed: () {
                  onQuantityChanged(
                    ProductUtils.incrementQuantity(
                      currentQuantity: quantity,
                      availableQuantity: product.productQuantity,
                      context: context,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
