import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/sales_notifier.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:beatbox/features/sales_management/widgets/sold_item_list_widget.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/utils/sales_utils.dart';
import 'package:beatbox/widgets/custom_search_bar.dart';
import 'package:beatbox/widgets/date_range_info_widget.dart';
import 'package:beatbox/widgets/empty_placeholder.dart';
import 'package:beatbox/widgets/shimmer_widgets/shimmer_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalesAndCustomerScreen extends StatefulWidget {
  const SalesAndCustomerScreen({super.key});

  @override
  State<SalesAndCustomerScreen> createState() => _SalesAndCustomerScreenState();
}

class _SalesAndCustomerScreenState extends State<SalesAndCustomerScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _checkAndLoadSales();
  }

  Future<void> _checkAndLoadSales() async {
    if (isSalesReloadNeeded.value) {
      await SalesUtils.loadSales();
      isSalesReloadNeeded.value = false;
    } else {
      await SalesUtils.loadSalesWithoutShimmer();
    }
  }

  Future<void> _filterSales() async {
    await SalesUtils.filterSalesByNameAndDate(
      query: _searchController.text.trim(),
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  void _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      await _filterSales();
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
            title: LayoutBuilder(
              builder: (context, constraints) {
                final isWeb = constraints.maxWidth > 600;
                return Text(
                  'Sales History',
                  style: TextStyle(
                    fontSize: isWeb ? 9.sp : 22.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                );
              },
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isWeb = constraints.maxWidth > 600;
              return Center(
                child: Container(
                  width: isWeb ? 300.w : double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: isWeb ? 20.w : 0),
                  child: Column(
                    children: [
                      ValueListenableBuilder<List<SalesModel>>(
                        valueListenable: allSalesNotifier,
                        builder: (_, allSalesList, __) {
                          if (allSalesList.isEmpty) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: EdgeInsets.all(isWeb ? 20.w : 16.w),
                            child: CustomSearchBar(
                              controller: _searchController,
                              focusNode: _focusNode,
                              showFilterIcon: true,
                              hintText: 'Search by customer or invoice ...',
                              onChanged: (_) => _filterSales(),
                              onFilterTap: _pickDateRange,
                            ),
                          );
                        },
                      ),
                      if (_startDate != null || _endDate != null)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isWeb ? 20.w : 16.w,
                          ),
                          child: DateRangeInfoWidget(
                            startDate: _startDate,
                            endDate: _endDate,
                            onClear: () async {
                              setState(() {
                                _startDate = null;
                                _endDate = null;
                              });
                              await _filterSales();
                            },
                          ),
                        ),
                      SizedBox(height: 10.h),
                      Expanded(
                        child: ValueListenableBuilder<bool>(
                          valueListenable: isSalesLoadingNotifier,
                          builder: (context, isLoading, _) {
                            return ValueListenableBuilder<List<SalesModel>>(
                              valueListenable: filteredSalesNotifier,
                              builder: (context, salesList, _) {
                                if (allSalesNotifier.value.isEmpty) {
                                  return EmptyPlaceholder(
                                    imagePath:
                                        'assets/images/empty_product.png',
                                    message:
                                        "No sales have been recorded yet.\nStart selling to see your sales history here!",
                                    onActionTap:
                                        () => Navigator.pushNamed(
                                          context,
                                          AppRoutes.products,
                                        ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                        horizontal: isWeb ? 20.w : 16.w,
                                        vertical: 6.h,
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
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
