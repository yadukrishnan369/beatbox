import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';

class CurrentStockTile extends StatelessWidget {
  final ProductModel product;
  const CurrentStockTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.contColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
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
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.success),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            "Available: ${product.productQuantity}",
            style: TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
              fontSize: 10.sp,
            ),
          ),
        ),
      ),
    );
  }
}
