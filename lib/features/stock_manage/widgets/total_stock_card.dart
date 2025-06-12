import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/stock_manage/model/product_model.dart';
import 'package:beatbox/core/notifiers/product_add_notifier.dart';

class TotalStockCard extends StatelessWidget {
  const TotalStockCard({super.key});

  int getTotalStock(List<ProductModel> products) {
    int totalStock = 0;
    for (var p in products) {
      totalStock += p.productQuantity;
    }
    return totalStock;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ProductModel>>(
      valueListenable: productAddNotifier,
      builder: (context, productList, _) {
        final totalStock = getTotalStock(productList);

        return Card(
          color: AppColors.success,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total stock',
                  style: TextStyle(fontSize: 16.sp, color: AppColors.white),
                ),
                SizedBox(height: 8.h),
                Text(
                  totalStock.toString(),
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
