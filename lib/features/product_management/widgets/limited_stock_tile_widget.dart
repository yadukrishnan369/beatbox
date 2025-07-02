import 'dart:io';
import 'package:beatbox/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';

class LimitedStockTile extends StatelessWidget {
  final ProductModel product;
  const LimitedStockTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.contColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.limitedStockDetail,
            arguments: product,
          );
        },
        child: ListTile(
          contentPadding: EdgeInsets.all(10.r),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child:
                product.image1 != null
                    ? Image.file(
                      File(product.image1!),
                      width: 60.w,
                      height: 60.h,
                      fit: BoxFit.cover,
                    )
                    : Icon(Icons.image, size: 40.sp),
          ),
          title: Text(
            product.productName,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
          ),
          subtitle: Text(
            "code: ${product.productCode}",
            style: TextStyle(fontSize: 13.sp),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textPrimary),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  product.productQuantity == 0
                      ? 'Out of Stock'
                      : 'product left : ${product.productQuantity}',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Icon(Icons.add, color: AppColors.textPrimary),
            ],
          ),
        ),
      ),
    );
  }
}
