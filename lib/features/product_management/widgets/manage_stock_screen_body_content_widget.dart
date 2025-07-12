import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/widgets/product_action_item_widget.dart';
import 'package:beatbox/features/product_management/widgets/total_sale_card.dart';
import 'package:beatbox/features/product_management/widgets/total_stock_card.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageStockScreenBodyContent extends StatelessWidget {
  const ManageStockScreenBodyContent({
    super.key,
    required this.isWeb,
    required this.cardWidth,
    required this.cardHeight,
    required this.actionIconSize,
    required this.actionTitleFontSize,
    required this.trailingIconSize,
  });

  final bool isWeb;
  final double cardWidth;
  final double cardHeight;
  final double actionIconSize;
  final double actionTitleFontSize;
  final double trailingIconSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isWeb ? 200.w : double.infinity),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: const TotalStockCard(),
                ),
                SizedBox(width: 16.w),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: const TotalSalesCard(),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Divider(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text(
                'Product Actions',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: isWeb ? 10.sp : 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ProductActionItemWidget(
              icon: Icons.library_add,
              title: 'Add Product',
              iconSize: actionIconSize,
              fontSize: actionTitleFontSize,
              trailingIconSize: trailingIconSize,
              onTap: () => Navigator.pushNamed(context, AppRoutes.addProduct),
            ),
            ProductActionItemWidget(
              icon: Icons.edit,
              title: 'Edit/Delete Product',
              iconSize: actionIconSize,
              fontSize: actionTitleFontSize,
              trailingIconSize: trailingIconSize,
              onTap:
                  () => Navigator.pushNamed(context, AppRoutes.updateProduct),
            ),
            ProductActionItemWidget(
              icon: Icons.history,
              title: 'Sales/Customer History',
              iconSize: actionIconSize,
              fontSize: actionTitleFontSize,
              trailingIconSize: trailingIconSize,
              onTap:
                  () =>
                      Navigator.pushNamed(context, AppRoutes.salesAndCustomer),
            ),
            ProductActionItemWidget(
              icon: Icons.list_alt,
              title: 'Stock Entries',
              iconSize: actionIconSize,
              fontSize: actionTitleFontSize,
              trailingIconSize: trailingIconSize,
              onTap: () => Navigator.pushNamed(context, AppRoutes.stockEntry),
            ),
            ProductActionItemWidget(
              icon: Icons.receipt_long,
              title: 'Bill History',
              iconSize: actionIconSize,
              fontSize: actionTitleFontSize,
              trailingIconSize: trailingIconSize,
              onTap: () => Navigator.pushNamed(context, AppRoutes.billHistory),
            ),
            ProductActionItemWidget(
              icon: Icons.apps,
              title: 'Brands/Categories',
              iconSize: actionIconSize,
              fontSize: actionTitleFontSize,
              trailingIconSize: trailingIconSize,
              onTap:
                  () =>
                      Navigator.pushNamed(context, AppRoutes.brandAndCategory),
            ),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }
}
