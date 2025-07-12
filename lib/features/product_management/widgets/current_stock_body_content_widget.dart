import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/current_stock_notifier.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/features/product_management/widgets/current_stock_tile_widget.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/widgets/empty_placeholder.dart';
import 'package:beatbox/widgets/shimmer_widgets/shimmer_bill_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurrentStockBodyContent extends StatelessWidget {
  const CurrentStockBodyContent({
    super.key,
    required this.isShimmer,
    required this.isWeb,
    required bool isSearching,
  }) : _isSearching = isSearching;
  final bool isShimmer;
  final bool isWeb;
  final bool _isSearching;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:
          isShimmer
              ? ListView.builder(
                itemCount: 6,
                padding: EdgeInsets.symmetric(
                  vertical: 20.h,
                  horizontal: isWeb ? 120 : 16.w,
                ),
                itemBuilder:
                    (_, index) => Padding(
                      padding: EdgeInsets.only(bottom: isWeb ? 16 : 12.h),
                      child: const ShimmerBillTile(),
                    ),
              )
              : ValueListenableBuilder<List<ProductModel>>(
                valueListenable: currentStockNotifier,
                builder: (_, productList, __) {
                  if (productList.isEmpty) {
                    return _isSearching
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: isWeb ? 60 : 60.sp,
                              color: AppColors.primary,
                            ),
                            SizedBox(height: isWeb ? 20 : 16.h),
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
                        )
                        : EmptyPlaceholder(
                          imagePath: 'assets/images/empty_product.png',
                          message:
                              'No products available in stock now.\nPlease add items to see them here !',
                          onActionTap:
                              () => Navigator.pushNamed(
                                context,
                                AppRoutes.addProduct,
                              ),
                          actionIcon: Icons.library_add,
                          actionText: 'add product',
                        );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWeb ? 120 : 16.w,
                      vertical: isWeb ? 30 : 20.0,
                    ),
                    itemCount: productList.length,
                    itemBuilder: (_, index) {
                      return CurrentStockTile(product: productList[index]);
                    },
                  );
                },
              ),
    );
  }
}
