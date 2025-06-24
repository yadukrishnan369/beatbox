import 'dart:io';

import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/utils/product_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductEditDeleteCard extends StatelessWidget {
  const ProductEditDeleteCard({
    super.key,
    required this.context,
    required TextEditingController searchController,
    required FocusNode searchFocusNode,
    required this.product,
  }) : _searchController = searchController,
       _searchFocusNode = searchFocusNode;

  final BuildContext context;
  final TextEditingController _searchController;
  final FocusNode _searchFocusNode;
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child:
                product.image1 != null && product.image1!.isNotEmpty
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.file(
                        File(product.image1!),
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Icon(
                              Icons.inventory_2,
                              color: AppColors.primary,
                              size: 24.sp,
                            ),
                      ),
                    )
                    : Icon(
                      Icons.inventory_2,
                      color: AppColors.primary,
                      size: 24.sp,
                    ),
          ),
          SizedBox(width: 16.w),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'code: ${product.productCode}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textDisabled,
                  ),
                ),
              ],
            ),
          ),

          // Buttons
          Column(
            children: [
              Container(
                width: 70.w,
                height: 35.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: InkWell(
                  onTap: () => ProductUtils.editProduct(context, product),
                  borderRadius: BorderRadius.circular(6.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'edit',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(Icons.edit, color: AppColors.white, size: 14.sp),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                width: 70.w,
                height: 35.h,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: InkWell(
                  onTap:
                      () => ProductUtils.confirmDeleteProduct(
                        context,
                        product,
                        _searchController,
                        _searchFocusNode,
                      ),
                  borderRadius: BorderRadius.circular(6.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'delete',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Icon(Icons.delete, color: AppColors.white, size: 14.sp),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
