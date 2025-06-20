import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/core/notifiers/product_add_notifier.dart';

class TotalStockCard extends StatelessWidget {
  const TotalStockCard({super.key});

  int getTotalStock(List<ProductModel> products) {
    return products.fold(0, (sum, item) => sum + item.productQuantity);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ProductModel>>(
      valueListenable: productAddNotifier,
      builder: (context, productList, _) {
        final totalStock = getTotalStock(productList);
        final totalProducts = productList.length;

        return Card(
          color: AppColors.success,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Stock',
                    style: TextStyle(fontSize: 16.sp, color: AppColors.white),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '$totalStock items',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    '$totalProducts products',
                    style: TextStyle(fontSize: 16.sp, color: AppColors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
