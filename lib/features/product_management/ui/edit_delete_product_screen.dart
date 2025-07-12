import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/product_edit_delete_notifier.dart';
import 'package:beatbox/features/product_management/widgets/edit_delete_product_body_content.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:beatbox/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/utils/product_edit_delete_utils.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';

class UpdateProductScreen extends StatefulWidget {
  final bool shouldFocusSearch;
  const UpdateProductScreen({super.key, this.shouldFocusSearch = false});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    if (widget.shouldFocusSearch) {
      Future.delayed(const Duration(milliseconds: 300), () {
        FocusScope.of(context).requestFocus(_searchFocusNode);
      });
    }
  }

  Future<void> _loadProducts() async {
    if (isEditProductReloadNeeded.value) {
      await ProductEditDeleteUtils.loadProducts();
      isEditProductReloadNeeded.value = false;
    } else {
      await ProductEditDeleteUtils.loadProductsWithoutShimmer();
    }
  }

  Future<void> _onSearch(String query) async {
    final isQueryEmpty = query.trim().isEmpty;
    setState(() {
      _isSearching = !isQueryEmpty;
    });

    editProductShimmerNotifier.value = true;
    await Future.delayed(const Duration(milliseconds: 300));

    if (_isSearching) {
      ProductEditDeleteUtils.filterProducts(query);
    } else {
      await _loadProducts();
    }
    editProductShimmerNotifier.value = false;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

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
              'Update Products',
              style: TextStyle(
                fontSize: isWeb ? 26 : 22.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: ValueListenableBuilder<bool>(
            valueListenable: editProductShimmerNotifier,
            builder: (_, isShimmer, __) {
              return Column(
                children: [
                  ValueListenableBuilder<List<ProductModel>>(
                    valueListenable: allEditProductNotifier,
                    builder: (_, allProducts, __) {
                      return allProducts.isNotEmpty || _isSearching
                          ? Padding(
                            padding: EdgeInsets.all(isWeb ? 20 : 16.w),
                            child: CustomSearchBar(
                              controller: _searchController,
                              onChanged: _onSearch,
                              focusNode: _searchFocusNode,
                              showFilterIcon: false,
                            ),
                          )
                          : const SizedBox();
                    },
                  ),
                  EditDeleteProductBodyContent(
                    isShimmer: isShimmer,
                    isWeb: isWeb,
                    isSearching: _isSearching,
                    searchController: _searchController,
                    searchFocusNode: _searchFocusNode,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
