import 'dart:convert';
import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LimitedStockTile extends StatelessWidget {
  final ProductModel product;

  const LimitedStockTile({super.key, required this.product});

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
        double maxTileWidth = isWeb ? 700 : double.infinity;

        return Align(
          alignment: Alignment.center,
          child: Container(
            width: maxTileWidth,
            margin: EdgeInsets.only(bottom: isWeb ? 16 : 12.h),
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
                contentPadding: EdgeInsets.all(isWeb ? 16 : 10.r),
                leading: Container(
                  width: isWeb ? 100 : 60.w,
                  height: isWeb ? 80 : 60.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: isWeb ? _webImageWidget() : _mobileImageWidget(),
                  ),
                ),
                title: Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Text(
                    product.productName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: isWeb ? 16 : 16.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                subtitle: Text(
                  "code: ${product.productCode}",
                  style: TextStyle(
                    fontSize: isWeb ? 13 : 13.sp,
                    color: AppColors.textDisabled,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWeb ? 6 : 5.w,
                        vertical: isWeb ? 5 : 4.h,
                      ),
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
                          fontSize: isWeb ? 12 : 12.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: isWeb ? 10 : 8.w),
                    Icon(Icons.add, color: AppColors.textPrimary),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _webImageWidget() {
    final bytes = decodeBase64Image(product.webImage1);
    if (bytes != null) {
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackIcon(),
      );
    }
    return _fallbackIcon();
  }

  Widget _mobileImageWidget() {
    if (product.image1 != null &&
        product.image1!.isNotEmpty &&
        File(product.image1!).existsSync()) {
      return Image.file(
        File(product.image1!),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackIcon(),
      );
    }
    return _fallbackIcon();
  }

  Widget _fallbackIcon() {
    final bool isWeb = kIsWeb;
    return Center(
      child: Icon(
        Icons.image,
        color: AppColors.primary,
        size: isWeb ? 30 : 24.sp,
      ),
    );
  }
}
