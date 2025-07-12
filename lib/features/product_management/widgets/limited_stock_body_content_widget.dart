import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/limited_stock_notifier.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/features/product_management/widgets/limited_stock_tile_widget.dart';
import 'package:beatbox/widgets/empty_placeholder.dart';
import 'package:beatbox/widgets/shimmer_widgets/shimmer_bill_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LimtedStockBodyContent extends StatelessWidget {
  const LimtedStockBodyContent({
    super.key,
    required bool isSearching,
    required this.isWeb,
  }) : _isSearching = isSearching;

  final bool _isSearching;
  final bool isWeb;

  @override
  Widget build(BuildContext context) {
    if (limitedStockShimmerNotifier.value) {
      return ListView.builder(
        itemCount: 6,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemBuilder:
            (_, index) => Padding(
              padding: EdgeInsets.only(bottom: isWeb ? 16 : 12.h),
              child: const ShimmerBillTile(),
            ),
      );
    }

    return ValueListenableBuilder<List<ProductModel>>(
      valueListenable: limitedStockNotifier,
      builder: (_, filteredList, __) {
        if (filteredList.isEmpty) {
          return _isSearching
              ? Padding(
                padding: EdgeInsets.all(isWeb ? 30 : 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: isWeb ? 64 : 60.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "No matching product found",
                      style: TextStyle(
                        fontSize: isWeb ? 18 : 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
              : const EmptyPlaceholder(
                imagePath: 'assets/images/empty_product.png',
                message:
                    'All products have sufficient stock.\nNo items are currently in limited stock !',
              );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: filteredList.length,
          itemBuilder: (_, index) {
            return LimitedStockTile(product: filteredList[index]);
          },
        );
      },
    );
  }
}
