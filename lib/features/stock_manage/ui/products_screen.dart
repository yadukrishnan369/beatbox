import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/stock_manage/widgets/product_filter_sheet.dart';
import 'package:beatbox/features/stock_manage/widgets/product_view_switcher.dart';
import 'package:beatbox/utils/product_utils.dart';
import 'package:beatbox/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductsScreen extends StatefulWidget {
  final bool shouldFocusSearch;
  const ProductsScreen({super.key, this.shouldFocusSearch = false});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late ValueNotifier<bool> viewToggleNotifier;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<String> _selectedCategories = [];
  List<String> _selectedBrands = [];

  @override
  void initState() {
    super.initState();
    viewToggleNotifier = ValueNotifier(true);
    ProductUtils.loadProducts();

    if (widget.shouldFocusSearch) {
      Future.delayed(Duration(milliseconds: 300), () {
        _searchFocusNode.requestFocus();
      });
    }
  }

  void _filterProducts(String query) {
    ProductUtils.filterProducts(
      query,
      selectedCategories: _selectedCategories,
      selectedBrands: _selectedBrands,
    );
  }

  @override
  void dispose() {
    viewToggleNotifier.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
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
              'Products',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            actions: [
              ValueListenableBuilder<bool>(
                valueListenable: viewToggleNotifier,
                builder:
                    (_, isGrid, __) => IconButton(
                      icon: Icon(
                        isGrid ? Icons.list : Icons.grid_view,
                        color: AppColors.primary,
                        size: 24.sp,
                      ),
                      onPressed: () {
                        viewToggleNotifier.value = !isGrid;
                      },
                    ),
              ),
              SizedBox(width: 8.w),
            ],
          ),
          body: Column(
            children: [
              CustomSearchBar(
                controller: _searchController,
                onChanged: _filterProducts,
                focusNode: _searchFocusNode,
                onFilterTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.r),
                      ),
                    ),
                    builder:
                        (_) => ProductFilterSheet(
                          selectedCategories: _selectedCategories,
                          selectedBrands: _selectedBrands,
                          onClear: () {
                            setState(() {
                              _selectedCategories.clear();
                              _selectedBrands.clear();
                            });
                            _filterProducts(_searchController.text);
                          },
                          onApply: () {
                            _filterProducts(_searchController.text);
                          },
                          onCategorySelected: (selected) {
                            setState(() => _selectedCategories = selected);
                          },
                          onBrandSelected: (selected) {
                            setState(() => _selectedBrands = selected);
                          },
                        ),
                  );
                },
                showFilterIcon: true,
              ),
              Expanded(
                child: ProductViewSwitcher(
                  viewToggleNotifier: viewToggleNotifier,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
