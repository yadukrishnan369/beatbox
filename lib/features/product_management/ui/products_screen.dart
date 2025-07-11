import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/product_add_notifier.dart';
import 'package:beatbox/features/product_management/widgets/product_filter_sheet.dart';
import 'package:beatbox/features/product_management/widgets/product_view_switcher.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/utils/product_utils.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:beatbox/widgets/custom_search_bar.dart';
import 'package:beatbox/widgets/empty_placeholder.dart';
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

    if (isProductReloadNeeded.value) {
      ProductUtils.loadProducts(showShimmer: true);
      isProductReloadNeeded.value = false;
    }

    if (widget.shouldFocusSearch) {
      Future.delayed(const Duration(milliseconds: 300), () {
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

  void _clearFilters() {
    setState(() {
      _selectedCategories.clear();
      _selectedBrands.clear();
    });
    _filterProducts(_searchController.text);
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb =
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
                titleSpacing: isWeb ? 15.w : 16.w,
                title: Text(
                  'Products',
                  style: TextStyle(
                    fontSize: isWeb ? 9.sp : 22.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                actions: [
                  ValueListenableBuilder(
                    valueListenable: productAddNotifier,
                    builder: (context, productList, _) {
                      if (productList.isEmpty) return const SizedBox.shrink();
                      return Row(
                        children: [
                          ValueListenableBuilder<bool>(
                            valueListenable: viewToggleNotifier,
                            builder:
                                (_, isGrid, __) => IconButton(
                                  icon: Icon(
                                    isGrid ? Icons.list : Icons.grid_view,
                                    color: AppColors.primary,
                                    size: isWeb ? 24 : 20.sp,
                                  ),
                                  onPressed: () {
                                    viewToggleNotifier.value = !isGrid;
                                  },
                                ),
                          ),
                          SizedBox(width: isWeb ? 16 : 8.w),
                        ],
                      );
                    },
                  ),
                ],
              ),
              body: ValueListenableBuilder(
                valueListenable: productAddNotifier,
                builder: (context, productList, _) {
                  if (productList.isEmpty) {
                    return EmptyPlaceholder(
                      imagePath: 'assets/images/empty_product.png',
                      message:
                          'No products added yet.\nAdd products to start selling!',
                      onActionTap:
                          () => Navigator.pushNamed(
                            context,
                            AppRoutes.addProduct,
                          ),
                      actionIcon: Icons.library_add,
                      actionText: 'add product',
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isWeb ? 80.w : 16.w,
                          vertical: 8.h,
                        ),
                        child: CustomSearchBar(
                          controller: _searchController,
                          onChanged: _filterProducts,
                          focusNode: _searchFocusNode,
                          onFilterTap: () => filterProductBottomSheet(context),
                          showFilterIcon: true,
                        ),
                      ),

                      if (_selectedCategories.isNotEmpty ||
                          _selectedBrands.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(right: isWeb ? 80.w : 16.w),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 4.h,
                                ),
                              ),
                              onPressed: _clearFilters,
                              icon: Icon(Icons.clear, size: isWeb ? 18 : 18.sp),
                              label: Text(
                                'Clear Filter',
                                style: TextStyle(fontSize: isWeb ? 18 : 14.sp),
                              ),
                            ),
                          ),
                        ),

                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isWeb ? 80.w : 0,
                          ),
                          child: ProductViewSwitcher(
                            viewToggleNotifier: viewToggleNotifier,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> filterProductBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder:
          (_) => ProductFilterSheet(
            selectedCategories: _selectedCategories,
            selectedBrands: _selectedBrands,
            onClear: _clearFilters,
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
  }
}
