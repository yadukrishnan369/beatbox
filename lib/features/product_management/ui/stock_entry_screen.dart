import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/stock_entry_notifier.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/features/product_management/widgets/stock_entry_list_card_widget.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/utils/stock_entry_utils.dart';
import 'package:beatbox/widgets/custom_search_bar.dart';
import 'package:beatbox/widgets/date_range_info_widget.dart';
import 'package:beatbox/widgets/empty_placeholder.dart';
import 'package:beatbox/widgets/shimmer_widgets/shimmer_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StockEntryScreen extends StatefulWidget {
  const StockEntryScreen({super.key});

  @override
  State<StockEntryScreen> createState() => _StockEntryScreenState();
}

class _StockEntryScreenState extends State<StockEntryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  DateTime? _fromDate;
  DateTime? _toDate;

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _checkAndLoadProducts();
  }

  Future<void> _checkAndLoadProducts() async {
    if (isStockEntryReloadNeeded.value) {
      await StockEntryUtils.loadAllProducts();
      isStockEntryReloadNeeded.value = false;
    } else {
      await StockEntryUtils.loadProductsWithoutShimmer();
    }
  }

  Future<void> _filterProducts() async {
    setState(() {
      _isSearching = _searchController.text.trim().isNotEmpty;
    });

    await StockEntryUtils.filterByNameAndDate(
      query: _searchController.text.trim(),
      startDate: _fromDate,
      endDate: _toDate,
    );
  }

  void _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _fromDate = picked.start;
        _toDate = picked.end;
      });

      await _filterProducts();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
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
              'Stock Entries',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: Column(
            children: [
              ValueListenableBuilder<List<ProductModel>>(
                valueListenable: allStockEntryNotifier,
                builder: (_, allProducts, __) {
                  final hasData = allProducts.isNotEmpty;
                  return hasData || _isSearching
                      ? Padding(
                        padding: EdgeInsets.all(16.w),
                        child: CustomSearchBar(
                          controller: _searchController,
                          focusNode: _focusNode,
                          hintText: 'Search Stock ...',
                          showFilterIcon: true,
                          onChanged: (_) => _filterProducts(),
                          onFilterTap: _pickDateRange,
                        ),
                      )
                      : const SizedBox();
                },
              ),
              if (_fromDate != null || _toDate != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: DateRangeInfoWidget(
                    startDate: _fromDate,
                    endDate: _toDate,
                    onClear: () async {
                      setState(() {
                        _fromDate = null;
                        _toDate = null;
                      });
                      await _filterProducts();
                    },
                  ),
                ),
              SizedBox(height: 10.h),
              Expanded(
                child: ValueListenableBuilder<bool>(
                  valueListenable: isStockEntryLoadingNotifier,
                  builder: (context, isLoading, _) {
                    if (isLoading) {
                      return ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: 6,
                        separatorBuilder: (_, __) => SizedBox(height: 12.h),
                        itemBuilder: (_, __) => const ShimmerListTile(),
                      );
                    }

                    return ValueListenableBuilder<List<ProductModel>>(
                      valueListenable: stockEntryNotifier,
                      builder: (context, products, _) {
                        return ValueListenableBuilder<List<ProductModel>>(
                          valueListenable: allStockEntryNotifier,
                          builder: (context, allProducts, _) {
                            if (allProducts.isEmpty) {
                              return const EmptyPlaceholder(
                                imagePath: 'assets/images/empty_product.png',
                                message: 'No stock entries found',
                              );
                            }

                            if (products.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off_rounded,
                                      size: 60.sp,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      "No matching stock found",
                                      style: TextStyle(
                                        fontSize: 18.sp,
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
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.stockEntryDetails,
                                        arguments: product,
                                      );
                                    },
                                    child: StockEntryListCard(product: product),
                                  ),
                                );
                              },
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
