import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/core/notifiers/filter_product_notifier.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/utils/product_utils.dart';
import 'package:beatbox/widgets/custom_search_bar.dart';
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

  @override
  void initState() {
    super.initState();
    ProductUtils.loadProducts();
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

      ProductUtils.filterProductsByNameAndDate(
        query: _searchController.text,
        startDate: _fromDate,
        endDate: _toDate,
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
          body: Column(
            children: [
              CustomSearchBar(
                controller: _searchController,
                onChanged: (query) {
                  ProductUtils.filterProductsByNameAndDate(
                    query: query,
                    startDate: _fromDate,
                    endDate: _toDate,
                  );
                },
                focusNode: _focusNode,
                showFilterIcon: true,
                onFilterTap: _pickDateRange,
                hintText: 'Search Stock ...',
              ),
              _dateInfo(),
              Expanded(
                child: ValueListenableBuilder<List<ProductModel>>(
                  valueListenable: filteredProductNotifier,
                  builder: (context, products, _) {
                    if (products.isEmpty) {
                      return const Center(child: Text("No products found"));
                    }

                    return ListView.builder(
                      padding: EdgeInsets.all(12.r),
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
                          child: _buildProductCard(product),
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

  Widget _buildProductCard(ProductModel product) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.r)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                product.productName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                DateFormat('dd MMM yyyy').format(product.createdDate),
                style: TextStyle(fontSize: 12.sp, color: AppColors.primary),
              ),
            ],
          ),

          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quantity: ${product.productQuantity}',
                style: TextStyle(fontSize: 14.sp),
              ),
              Icon(Icons.list, color: AppColors.textPrimary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dateInfo() {
    if (_fromDate == null && _toDate == null) return const SizedBox();

    String format(DateTime? date) =>
        date != null ? DateFormat('dd MMM yyyy').format(date) : '';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.contColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
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
              icon: Icon(Icons.clear, color: AppColors.textPrimary),
              onPressed: () {
                setState(() {
                  _fromDate = null;
                  _toDate = null;
                });

                ProductUtils.filterProductsByNameAndDate(
                  query: _searchController.text.trim(),
                  startDate: null,
                  endDate: null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
