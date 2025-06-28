import 'package:beatbox/features/product_management/widgets/limited_stock_tile_widget.dart';
import 'package:beatbox/utils/limited_stock_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/widgets/custom_search_bar.dart';
import 'package:beatbox/widgets/shimmer_widgets/shimmer_bill_tile.dart';
import 'package:beatbox/core/notifiers/limited_stock_notifier.dart';
import 'package:beatbox/widgets/empty_placeholder.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';

class LimitedStockScreen extends StatefulWidget {
  const LimitedStockScreen({super.key});

  @override
  State<LimitedStockScreen> createState() => _LimitedStockScreenState();
}

class _LimitedStockScreenState extends State<LimitedStockScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    LimitedStockUtils.filterLimitedStockProducts();
  }

  void _onSearch(String query) {
    final isQueryEmpty = query.trim().isEmpty;
    setState(() {
      _isSearching = !isQueryEmpty;
    });

    if (_isSearching) {
      LimitedStockUtils.searchLimitedProducts(query);
    } else {
      LimitedStockUtils.filterLimitedStockProducts();
    }
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
          body: ValueListenableBuilder<bool>(
            valueListenable: limitedStockShimmerNotifier,
            builder: (_, isShimmer, __) {
              return Column(
                children: [
                  ValueListenableBuilder<List<ProductModel>>(
                    valueListenable: limitedStockNotifier,
                    builder: (_, productList, __) {
                      return productList.isNotEmpty || _isSearching
                          ? Padding(
                            padding: EdgeInsets.all(16.w),
                            child: CustomSearchBar(
                              controller: _searchController,
                              onChanged: _onSearch,
                              focusNode: _searchFocusNode,
                              showFilterIcon: false,
                            ),
                          )
                          : const SizedBox();
                    },
                  ),
                  Expanded(
                    child:
                        isShimmer
                            ? ListView.builder(
                              itemCount: 6,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              itemBuilder:
                                  (_, index) => Padding(
                                    padding: EdgeInsets.only(bottom: 12.h),
                                    child: const ShimmerBillTile(),
                                  ),
                            )
                            : ValueListenableBuilder<List<ProductModel>>(
                              valueListenable: limitedStockNotifier,
                              builder: (_, filteredList, __) {
                                if (filteredList.isEmpty) {
                                  return _isSearching
                                      ? Padding(
                                        padding: EdgeInsets.all(24.w),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.search_off_rounded,
                                              size: 60.sp,
                                              color: AppColors.primary,
                                            ),
                                            SizedBox(height: 16.h),
                                            Text(
                                              "No matching product found",
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primary,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      )
                                      : const EmptyPlaceholder(
                                        imagePath:
                                            'assets/images/empty_product.png',
                                        message:
                                            'All products have sufficient stock.\nNo items are currently in limited stock !',
                                      );
                                }

                                return ListView.builder(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                  ),
                                  itemCount: filteredList.length,
                                  itemBuilder: (_, index) {
                                    return LimitedStockTile(
                                      product: filteredList[index],
                                    );
                                  },
                                );
                              },
                            ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
