import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/sales_notifier.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:beatbox/utils/sales_utils.dart';
import 'package:beatbox/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

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
    SalesUtils.loadSales();
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

      SalesUtils.filterSalesByNameAndDate(
        query: _searchController.text.trim(),
        startDate: _startDate,
        endDate: _endDate,
      );
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
          centerTitle: false,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSearchBar(
                controller: _searchController,
                onChanged: (query) {
                  SalesUtils.filterSalesByNameAndDate(
                    query: query,
                    startDate: _startDate,
                    endDate: _endDate,
                  );
                },
                focusNode: _focusNode,
                showFilterIcon: true,
                onFilterTap: _pickDateRange,
                hintText: 'Search by customer or invoice ...',
              ),
              SizedBox(height: 10.h),
              _dateInfo(),
              SizedBox(height: 10.h),
              Expanded(
                child: ValueListenableBuilder<List<SalesModel>>(
                  valueListenable: filteredSalesNotifier,
                  builder: (context, salesList, _) {
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
                          child: _buildSalesTile(sale),
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

  Widget _buildSalesTile(SalesModel sale) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.contColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sale.customerName,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  sale.invoiceNumber,
                  style: TextStyle(
                    color: AppColors.textDisabled,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1.w,
            height: 40.h,
            color: AppColors.white,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Amount',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '₹ ${AmountFormatter.format(sale.grandTotal)}',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.list, color: AppColors.primary, size: 20.sp),
        ],
      ),
    );
  }

  Widget _dateInfo() {
    if (_startDate == null && _endDate == null) return SizedBox();

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'From: ${format(_startDate)}',
                style: TextStyle(fontSize: 15.sp),
              ),
              Text(
                'To: ${format(_endDate)}',
                style: TextStyle(fontSize: 15.sp),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.clear, size: 18.sp),
            onPressed: () {
              setState(() {
                _startDate = null;
                _endDate = null;
              });
              SalesUtils.filterSalesByNameAndDate(
                query: _searchController.text.trim(),
                startDate: null,
                endDate: null,
              );
            },
          ),
        ],
      ),
    );
  }
}
