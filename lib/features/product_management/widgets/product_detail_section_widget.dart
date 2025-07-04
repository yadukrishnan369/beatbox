import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:beatbox/utils/product_utils.dart';

class ProductDetailSection extends StatelessWidget {
  final ProductModel product;
  final List<String?> imageList;
  final PageController pageController;
  final int currentPage;
  final int quantity;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onQuantityChanged;

  const ProductDetailSection({
    super.key,
    required this.product,
    required this.imageList,
    required this.pageController,
    required this.currentPage,
    required this.quantity,
    required this.onPageChanged,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image Gallery Section
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: PageView.builder(
                controller: pageController,
                itemCount: imageList.length,
                onPageChanged: onPageChanged,
                itemBuilder: (context, index) {
                  final path = imageList[index];
                  return path != null
                      ? Image.file(File(path), fit: BoxFit.cover)
                      : const Center(child: Icon(Icons.image));
                },
              ),
            ),
            if (imageList.length > 1)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.white,
                            size: 40.sp,
                          ),
                          onPressed:
                              currentPage > 0
                                  ? () => pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn,
                                  )
                                  : null,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.white,
                            size: 40.sp,
                          ),
                          onPressed:
                              currentPage < imageList.length - 1
                                  ? () => pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn,
                                  )
                                  : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 18.h),

        // Product Info Section
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(25.w),
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
                  color: AppColors.textPrimary,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                '${product.productCategory} | ${product.productBrand} | code-${product.productCode}',
                style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
              ),
              SizedBox(height: 10.h),
              Text(
                'MRP ₹ ${AmountFormatter.format(product.salePrice)}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                product.description,
                style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.remove,
                      size: 30.sp,
                      color: AppColors.textPrimary,
                    ),
                    onPressed:
                        () => onQuantityChanged(
                          ProductUtils.decrementQuantity(quantity),
                        ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    '$quantity',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 28.sp,
                      color: AppColors.textPrimary,
                    ),
                    onPressed:
                        () => onQuantityChanged(
                          ProductUtils.incrementQuantity(
                            currentQuantity: quantity,
                            availableQuantity: product.productQuantity,
                            context: context,
                          ),
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
