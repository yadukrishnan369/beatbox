import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/bill_notifier.dart';
import 'package:beatbox/features/bill_management/widgets/bill_history_body_content_widget.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:beatbox/utils/bill_utils.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:beatbox/widgets/custom_search_bar.dart';
import 'package:beatbox/widgets/date_range_info_widget.dart';
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
  bool _isSearching = false;

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
    setState(() {
      _isSearching = _searchController.text.trim().isNotEmpty;
    });

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb =
            Responsive.isDesktop(context) || constraints.maxWidth > 600;

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
                    fontSize: isWeb ? 8.sp : 22.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: isWeb ? 40.w : 0),
                child: Column(
                  children: [
                    ValueListenableBuilder<List<SalesModel>>(
                      valueListenable: allBillNotifier,
                      builder: (_, allBills, __) {
                        final hasData = allBills.isNotEmpty;
                        return hasData || _isSearching
                            ? Padding(
                              padding: EdgeInsets.all(isWeb ? 12.w : 16.w),
                              child: CustomSearchBar(
                                controller: _searchController,
                                focusNode: _focusNode,
                                hintText: 'Search by invoice or customer name',
                                onChanged: (_) => _filterBills(),
                                showFilterIcon: true,
                                onFilterTap: _pickDateRange,
                              ),
                            )
                            : const SizedBox();
                      },
                    ),
                    if (_startDate != null || _endDate != null)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isWeb ? 6.w : 16.w,
                        ),
                        child: DateRangeInfoWidget(
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
                      ),
                    SizedBox(height: isWeb ? 6.h : 10.h),
                    BillHistoryBodyContent(isWeb: isWeb),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
