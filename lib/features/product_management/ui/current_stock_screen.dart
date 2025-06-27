import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/utils/current_stock_utils.dart';
import 'package:beatbox/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/widgets/empty_placeholder.dart';
import 'package:beatbox/widgets/shimmer_widgets/shimmer_bill_tile.dart';
import 'package:beatbox/core/notifiers/current_stock_notifier.dart';
import 'package:beatbox/features/product_management/widgets/current_stock_tile_widget.dart';

class CurrentStockScreen extends StatefulWidget {
  const CurrentStockScreen({super.key});

  @override
  State<CurrentStockScreen> createState() => _CurrentStockScreenState();
}

class _CurrentStockScreenState extends State<CurrentStockScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    CurrentStockUtils.filterCurrentStockProducts();
  }

  void _onSearch(String query) {
    final isQueryEmpty = query.trim().isEmpty;
    setState(() {
      _isSearching = !isQueryEmpty;
    });

    if (_isSearching) {
      CurrentStockUtils.searchCurrentStockProducts(query);
    } else {
      CurrentStockUtils.filterCurrentStockProducts();
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
              "Current Stock",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: ValueListenableBuilder<bool>(
            valueListenable: currentStockShimmerNotifier,
            builder: (_, isShimmer, __) {
              return Column(
                children: [
                  ValueListenableBuilder<List<ProductModel>>(
                    valueListenable: currentStockNotifier,
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
                              valueListenable: currentStockNotifier,
                              builder: (_, productList, __) {
                                if (productList.isEmpty) {
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
                                            'No current stock products available',
                                      );
                                }

                                return ListView.builder(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                  ),
                                  itemCount: productList.length,
                                  itemBuilder: (_, index) {
                                    return CurrentStockTile(
                                      product: productList[index],
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
