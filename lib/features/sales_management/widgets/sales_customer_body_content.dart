import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/sales_notifier.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:beatbox/features/sales_management/widgets/sold_item_list_widget.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/widgets/empty_placeholder.dart';
import 'package:beatbox/widgets/shimmer_widgets/shimmer_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalesCustomerBodyContent extends StatelessWidget {
  const SalesCustomerBodyContent({super.key, required this.isWeb});

  final bool isWeb;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder<bool>(
        valueListenable: isSalesLoadingNotifier,
        builder: (context, isLoading, _) {
          return ValueListenableBuilder<List<SalesModel>>(
            valueListenable: filteredSalesNotifier,
            builder: (context, salesList, _) {
              if (allSalesNotifier.value.isEmpty) {
                return EmptyPlaceholder(
                  imagePath: 'assets/images/empty_product.png',
                  message:
                      "No sales have been recorded yet.\nStart selling to see your sales history here!",
                  onActionTap:
                      () => Navigator.pushNamed(context, AppRoutes.products),
                  actionIcon: Icons.shopping_bag,
                  actionText: 'Explore products',
                );
              }

              if (isLoading) {
                return ListView.builder(
                  itemCount: 6,
                  itemBuilder:
                      (_, index) => const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 6,
                        ),
                        child: ShimmerListTile(),
                      ),
                );
              }

              if (salesList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: isWeb ? 50.sp : 60.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "No matching sale found",
                        style: TextStyle(
                          fontSize: isWeb ? 16.sp : 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: salesList.length,
                itemBuilder: (_, index) {
                  final sale = salesList[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWeb ? 20.w : 12.w,
                      vertical: isWeb ? 6.h : 2.h,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.salesAndCustomerDetails,
                          arguments: sale,
                        );
                      },
                      child: SoldItemListTile(sale: sale),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
