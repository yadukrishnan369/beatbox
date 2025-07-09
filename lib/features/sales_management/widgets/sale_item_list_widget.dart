import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';

class SaleItemListWidget extends StatelessWidget {
  final SalesModel sale;

  const SaleItemListWidget({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

    double totalSale = 0.0;
    double totalPurchase = 0.0;

    for (var item in sale.cartItems) {
      totalSale += item.product.salePrice * item.quantity;
      totalPurchase += item.product.purchaseRate * item.quantity;
    }

    double totalProfit = (totalSale + sale.gst - sale.discount) - totalPurchase;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isWeb ? 18 : 16.w),
      decoration: BoxDecoration(
        color: AppColors.contColor,
        borderRadius: BorderRadius.circular(isWeb ? 10 : 12.r),
        border: Border.all(
          color: AppColors.textPrimary,
          width: isWeb ? 1.2 : 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...sale.cartItems.map((item) {
            final itemProfit =
                (item.product.salePrice - item.product.purchaseRate) *
                item.quantity;

            return Padding(
              padding: EdgeInsets.only(bottom: isWeb ? 18 : 16.h),
              child: _buildProductItem(
                isWeb: isWeb,
                productName: item.product.productName,
                brand: item.product.productBrand,
                qty: item.quantity,
                purchaseRate: item.product.purchaseRate,
                salePrice: item.product.salePrice,
                total: item.totalPrice,
                itemProfit: itemProfit,
              ),
            );
          }),
          Divider(color: Colors.grey.shade500, thickness: isWeb ? 1.2 : 1),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              children: [
                Text(
                  '(included GST & Discount)',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: isWeb ? 11 : 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: isWeb ? 40 : 25.w),
                Text(
                  'Total : ₹${AmountFormatter.format(totalProfit)}',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: isWeb ? 18 : 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem({
    required bool isWeb,
    required String productName,
    required String brand,
    required int qty,
    required double purchaseRate,
    required double salePrice,
    required double total,
    required double itemProfit,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$productName      $brand',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: isWeb ? 17 : 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: isWeb ? 5 : 4.h),
          Row(
            children: [
              _infoText('Qty: $qty', isWeb),
              _infoText('Purchase rate: ₹$purchaseRate', isWeb),
              _infoText('Sale rate: ₹$salePrice', isWeb),
            ],
          ),
          SizedBox(height: isWeb ? 6 : 5.h),
          Row(
            children: [
              _infoText('Total : ₹${AmountFormatter.format(total)}', isWeb),
              _infoText(
                'Profit: ₹${AmountFormatter.format(itemProfit)}',
                isWeb,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoText(String text, bool isWeb) {
    return Padding(
      padding: EdgeInsets.only(right: isWeb ? 20 : 18.w),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: isWeb ? 14 : 14.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
