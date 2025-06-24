import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/sales_notifier.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:beatbox/features/sales_management/widgets/date_range_info_widget.dart';
import 'package:beatbox/features/sales_management/widgets/sold_item_list_widget.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/utils/sales_utils.dart';
import 'package:beatbox/widgets/custom_search_bar.dart';
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
            title: Text(
              'Sales History',
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
                  focusNode: _focusNode,
                  showFilterIcon: true,
                  hintText: 'Search by customer or invoice ...',
                  onChanged: (_) => _filterSales(),
                  onFilterTap: _pickDateRange,
                ),
                SizedBox(height: 10.h),
                // date range filter info
                DateRangeInfoWidget(
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
                SizedBox(height: 10.h),
                Expanded(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: isSalesLoadingNotifier,
                    builder: (context, isLoading, _) {
                      return ValueListenableBuilder<List<SalesModel>>(
                        valueListenable: filteredSalesNotifier,
                        builder: (context, salesList, _) {
                          if (isLoading) {
                            return ListView.builder(
                              itemCount: 6,
                              itemBuilder:
                                  (context, index) => const ShimmerListTile(),
                            );
                          }

                          if (salesList.isEmpty) {
                            return Center(
                              child: Text(
                                'No sales found',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: salesList.length,
                            itemBuilder: (context, index) {
                              final sale = salesList[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.salesAndCustomerDetails,
                                    arguments: sale,
                                  );
                                },
                                //list of sale and customer history
                                child: SoldItemListTile(sale: sale),
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
      ),
    );
  }
}
