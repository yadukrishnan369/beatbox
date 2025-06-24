import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/core/notifiers/filter_product_notifier.dart';
import 'package:beatbox/core/notifiers/product_add_notifier.dart';
import 'package:beatbox/features/product_management/widgets/stock_entry_list_card_widget.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/utils/product_utils.dart';
import 'package:beatbox/widgets/custom_search_bar.dart';
import 'package:beatbox/widgets/shimmer_widgets/shimmer_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    if (isProductReloadNeeded.value) {
      _loadProducts(); // First time or after new product
      isProductReloadNeeded.value = false;
    } else {
      _loadFilteredProductsOnly(); // No shimmer
    }
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    await ProductUtils.loadProducts();
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _isLoading = false);
  }

  void _loadFilteredProductsOnly() {
    setState(() => _isLoading = false);
    ProductUtils.filterProductsByNameAndDate(
      query: _searchController.text,
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
        _isLoading = true;
      });

      ProductUtils.filterProductsByNameAndDate(
        query: _searchController.text,
        startDate: _fromDate,
        endDate: _toDate,
      );

      await Future.delayed(const Duration(milliseconds: 300));
      setState(() => _isLoading = false);
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
        onNotification: (notification) {
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
          body: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                CustomSearchBar(
                  controller: _searchController,
                  onChanged: (query) async {
                    setState(() => _isLoading = true);
                    ProductUtils.filterProductsByNameAndDate(
                      query: query,
                      startDate: _fromDate,
                      endDate: _toDate,
                    );
                    await Future.delayed(const Duration(milliseconds: 300));
                    setState(() => _isLoading = false);
                  },
                  focusNode: _focusNode,
                  showFilterIcon: true,
                  onFilterTap: _pickDateRange,
                  hintText: 'Search Stock ...',
                ),
                SizedBox(height: 10.h),
                _dateInfo(),
                SizedBox(height: 10.h),
                Expanded(
                  child: ValueListenableBuilder<List<ProductModel>>(
                    valueListenable: filteredProductNotifier,
                    builder: (context, products, _) {
                      if (_isLoading) {
                        return ListView.builder(
                          itemCount: 6,
                          itemBuilder:
                              (context, index) => const ShimmerListTile(),
                        );
                      }

                      if (products.isEmpty) {
                        return const Center(child: Text("No products found"));
                      }

                      return ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.stockEntryDetails,
                                arguments: product,
                              );
                            },
                            child: StockEntryListCard(product: product),
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
      ),
    );
  }

  Widget _dateInfo() {
    if (_fromDate == null && _toDate == null) return const SizedBox();

    String format(DateTime? date) =>
        date != null ? DateFormat('dd MMM yyyy').format(date) : '';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.cardColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'From: ${format(_fromDate)}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'To: ${format(_toDate)}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.clear, color: AppColors.textPrimary, size: 20.sp),
            onPressed: () async {
              setState(() {
                _fromDate = null;
                _toDate = null;
                _isLoading = true;
              });

              ProductUtils.filterProductsByNameAndDate(
                query: _searchController.text.trim(),
                startDate: null,
                endDate: null,
              );

              await Future.delayed(const Duration(milliseconds: 300));
              setState(() => _isLoading = false);
            },
          ),
        ],
      ),
    );
  }
}
