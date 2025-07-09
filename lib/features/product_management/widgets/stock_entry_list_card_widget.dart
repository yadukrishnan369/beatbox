import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class StockEntryListCard extends StatelessWidget {
  const StockEntryListCard({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

    return Container(
      margin: EdgeInsets.only(bottom: isWeb ? 6.h : 14.h),
      padding: EdgeInsets.all(isWeb ? 6.w : 18.r),
      decoration: BoxDecoration(
        color: AppColors.contColor,
        borderRadius: BorderRadius.circular(isWeb ? 10.r : 12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // top name and date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  product.productName,
                  style: TextStyle(
                    fontSize: isWeb ? 5.sp : 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                DateFormat('dd MMM yyyy').format(product.createdDate),
                style: TextStyle(
                  fontSize: isWeb ? 5.sp : 12.sp,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          SizedBox(height: isWeb ? 8.h : 10.h),

          // bottom qnty and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'purchased Qty: ${product.initialQuantity}',
                style: TextStyle(
                  fontSize: isWeb ? 5.sp : 14.sp,
                  color: AppColors.textPrimary,
                ),
              ),
              product.productQuantity == 0
                  ? Text(
                    'Out of Stock',
                    style: TextStyle(
                      fontSize: isWeb ? 5.sp : 12.sp,
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                  : Icon(
                    Icons.list,
                    color: AppColors.textPrimary,
                    size: isWeb ? 7.sp : 20.sp,
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
