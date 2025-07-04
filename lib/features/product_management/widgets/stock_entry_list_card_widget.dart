import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class StockEntryListCard extends StatelessWidget {
  const StockEntryListCard({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.contColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                product.productName,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                DateFormat('dd MMM yyyy').format(product.createdDate),
                style: TextStyle(fontSize: 12.sp, color: AppColors.primary),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'purchased Qty: ${product.initialQuantity}',
                style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
              ),
              product.productQuantity == 0
                  ? Text(
                    'Out of Stock',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                  : Icon(Icons.list, color: AppColors.textPrimary, size: 20.sp),
            ],
          ),
        ],
      ),
    );
  }
}
