import 'package:beatbox/utils/responsive_utils.dart';
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

        final bool isWeb = Responsive.isDesktop(context);

        final double titleFont = isWeb ? 5.sp : 16.sp;
        final double valueFont = isWeb ? 6.sp : 18.sp;
        final double padding = isWeb ? 7.w : 14.w;

        return Card(
          color: AppColors.success,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total Stock',
                    style: TextStyle(
                      fontSize: titleFont,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '$totalStock items',
                    style: TextStyle(
                      fontSize: valueFont,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    '$totalProducts products',
                    style: TextStyle(
                      fontSize: titleFont,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white,
                    ),
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
