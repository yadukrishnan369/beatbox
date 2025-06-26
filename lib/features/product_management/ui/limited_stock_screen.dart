import 'package:beatbox/features/product_management/widgets/limited_stock_tile_widget.dart';
import 'package:beatbox/utils/limited_stock_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/widgets/custom_search_bar.dart';
import 'package:beatbox/widgets/shimmer_widgets/shimmer_bill_tile.dart';
import 'package:beatbox/core/notifiers/product_add_notifier.dart';
import 'package:beatbox/core/notifiers/filter_product_notifier.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';

class LimitedStockScreen extends StatefulWidget {
  const LimitedStockScreen({super.key});

  @override
  State<LimitedStockScreen> createState() => _LimitedStockScreenState();
}

class _LimitedStockScreenState extends State<LimitedStockScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    LimitedStockUtils.filterLimitedStockProducts();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (_) {
          FocusScope.of(context).unfocus();
          return false;
        },
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            title: Text(
              "Limited stock",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: CustomSearchBar(
                  controller: _searchController,
                  onChanged: LimitedStockUtils.searchLimitedProducts,
                  focusNode: _searchFocusNode,
                  showFilterIcon: false,
                ),
              ),
              Expanded(
                child: ValueListenableBuilder<bool>(
                  valueListenable: productShimmerNotifier,
                  builder: (_, isLoading, __) {
                    if (isLoading) {
                      return ListView.builder(
                        itemCount: 6,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemBuilder:
                            (_, index) => Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: ShimmerBillTile(),
                            ),
                      );
                    }

                    return ValueListenableBuilder<List<ProductModel>>(
                      valueListenable: filteredProductNotifier,
                      builder: (_, filteredList, __) {
                        if (filteredList.isEmpty) {
                          return Center(
                            child: Text("No limited stock products found"),
                          );
                        }

                        return ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          itemCount: filteredList.length,
                          itemBuilder: (_, index) {
                            return LimitedStockTile(
                              product: filteredList[index],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
