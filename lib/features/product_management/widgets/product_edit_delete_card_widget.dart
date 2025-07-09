import 'dart:convert';
import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/utils/product_utils.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/foundation.dart';
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

  Uint8List? decodeBase64Image(String? base64String) {
    try {
      if (base64String == null || base64String.isEmpty) return null;
      return base64Decode(base64String);
    } catch (e) {
      print("Image decode error: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxCardWidth = isWeb ? 700 : double.infinity;

        return Align(
          alignment: Alignment.center,
          child: Container(
            width: maxCardWidth,
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(isWeb ? 20 : 16.w),
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // image section
                Container(
                  width: isWeb ? 80 : 80.w,
                  height: isWeb ? 80 : 80.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: isWeb ? _webImageWidget() : _mobileImageWidget(),
                  ),
                ),

                SizedBox(width: isWeb ? 24 : 16.w),

                // product info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productName,
                        style: TextStyle(
                          fontSize: isWeb ? 18 : 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'code: ${product.productCode}',
                        style: TextStyle(
                          fontSize: isWeb ? 14 : 14.sp,
                          color: AppColors.textDisabled,
                        ),
                      ),
                    ],
                  ),
                ),

                // action buttons
                Column(
                  children: [
                    Container(
                      width: isWeb ? 80 : 70.w,
                      height: isWeb ? 38 : 35.h,
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
                                fontSize: isWeb ? 13 : 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.edit,
                              color: AppColors.white,
                              size: isWeb ? 16 : 14.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: isWeb ? 80 : 70.w,
                      height: isWeb ? 38 : 35.h,
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
                                fontSize: isWeb ? 13 : 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Icon(
                              Icons.delete,
                              color: AppColors.white,
                              size: isWeb ? 16 : 14.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // web image widget
  Widget _webImageWidget() {
    final bytes = decodeBase64Image(product.webImage1);
    if (bytes != null) {
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackIcon(),
      );
    } else {
      return _fallbackIcon();
    }
  }

  // bobile image widget
  Widget _mobileImageWidget() {
    if (product.image1 != null &&
        product.image1!.isNotEmpty &&
        File(product.image1!).existsSync()) {
      return Image.file(
        File(product.image1!),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackIcon(),
      );
    } else {
      return _fallbackIcon();
    }
  }

  // fallback icon widget
  Widget _fallbackIcon() {
    final bool isWeb = kIsWeb;
    return Center(
      child: Icon(
        Icons.inventory_2,
        color: AppColors.primary,
        size: isWeb ? 30 : 24.sp,
      ),
    );
  }
}
