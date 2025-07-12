import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StockEntryDetailSummaryCard extends StatelessWidget {
  const StockEntryDetailSummaryCard({
    super.key,
    required this.isWeb,
    required this.totalValue,
    required this.product,
    required this.totalProfit,
    required this.profitPerItem,
    required this.isOutOfStock,
  });

  final bool isWeb;
  final double totalValue;
  final ProductModel product;
  final double totalProfit;
  final double profitPerItem;
  final bool isOutOfStock;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isWeb ? 20.r : 16.r),
      decoration: BoxDecoration(
        color: AppColors.contColor,
        borderRadius: BorderRadius.circular(isWeb ? 10.r : 8.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'STOCK TOTAL',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isWeb ? 8.sp : 16.sp,
                ),
              ),
              Text(
                '₹${AmountFormatter.format(totalValue)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isWeb ? 8.sp : 16.sp,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: isWeb ? 10.w : 16.w, top: 4.h),
                child: Text(
                  '${AmountFormatter.format(product.purchaseRate)} x ${product.initialQuantity}',
                  style: TextStyle(
                    fontSize: isWeb ? 7.sp : 14.sp,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'EXPECTED PROFIT',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isWeb ? 8.sp : 16.sp,
                ),
              ),
              Text(
                '₹${AmountFormatter.format(totalProfit)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isWeb ? 8.sp : 16.sp,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: isWeb ? 10.w : 16.w, top: 4.h),
                child: Text(
                  '${AmountFormatter.format(profitPerItem)} x ${product.initialQuantity}',
                  style: TextStyle(
                    fontSize: isWeb ? 7.sp : 14.sp,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          if (isOutOfStock)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Center(
                child: Text(
                  'Out Of Stock',
                  style: TextStyle(
                    fontSize: isWeb ? 9.sp : 18.sp,
                    color: AppColors.error,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
