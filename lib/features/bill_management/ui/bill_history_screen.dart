import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/bill_notifier.dart';
import 'package:beatbox/features/bill_management/widgets/bill_item_card_widget.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/utils/bill_utils.dart';
import 'package:beatbox/widgets/custom_search_bar.dart';
import 'package:beatbox/widgets/date_range_info_widget.dart';
import 'package:beatbox/widgets/shimmer_widgets/shimmer_bill_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillHistoryScreen extends StatefulWidget {
  const BillHistoryScreen({super.key});

  @override
  State<BillHistoryScreen> createState() => _BillHistoryScreenState();
}

class _BillHistoryScreenState extends State<BillHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _checkAndLoadBills();
  }

  Future<void> _checkAndLoadBills() async {
    if (isBillReloadNeeded.value) {
      await BillUtils.loadBills();
      isBillReloadNeeded.value = false;
    } else {
      await BillUtils.loadBillsWithoutShimmer();
    }
  }

  Future<void> _filterBills() async {
    await BillUtils.filterBillsByNameAndDate(
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
      await _filterBills();
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
              'Bill History',
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
                  hintText: 'Search by invoice or customer name',
                  onChanged: (_) => _filterBills(),
                  showFilterIcon: true,
                  onFilterTap: _pickDateRange,
                ),
                SizedBox(height: 12.h),
                // date range filter info
                DateRangeInfoWidget(
                  startDate: _startDate,
                  endDate: _endDate,
                  onClear: () async {
                    setState(() {
                      _startDate = null;
                      _endDate = null;
                    });
                    await _filterBills();
                  },
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: isBillLoadingNotifier,
                    builder: (context, isLoading, _) {
                      return ValueListenableBuilder<List<SalesModel>>(
                        valueListenable: filteredBillNotifier,
                        builder: (context, billList, _) {
                          if (isLoading) {
                            return ListView.separated(
                              itemCount: 6,
                              separatorBuilder:
                                  (_, __) => SizedBox(height: 12.h),
                              itemBuilder: (_, __) => const ShimmerBillTile(),
                            );
                          }

                          if (billList.isEmpty) {
                            return Center(
                              child: Text(
                                'No bills found',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: billList.length,
                            itemBuilder: (context, index) {
                              final bill = billList[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.billDetails,
                                    arguments: bill,
                                  );
                                },
                                child: BillItemCard(bill: bill),
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
