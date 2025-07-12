import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/product_edit_delete_notifier.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/features/product_management/widgets/product_edit_delete_card_widget.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/widgets/empty_placeholder.dart';
import 'package:beatbox/widgets/shimmer_widgets/shimmer_bill_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditDeleteProductBodyContent extends StatelessWidget {
  const EditDeleteProductBodyContent({
    super.key,
    required this.isShimmer,
    required this.isWeb,
    required bool isSearching,
    required TextEditingController searchController,
    required FocusNode searchFocusNode,
  }) : _isSearching = isSearching,
       _searchController = searchController,
       _searchFocusNode = searchFocusNode;
  final bool isShimmer;
  final bool isWeb;
  final bool _isSearching;
  final TextEditingController _searchController;
  final FocusNode _searchFocusNode;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:
          isShimmer
              ? ListView.builder(
                itemCount: 6,
                padding: EdgeInsets.symmetric(horizontal: isWeb ? 30 : 16.w),
                itemBuilder:
                    (_, index) => Padding(
                      padding: EdgeInsets.only(bottom: isWeb ? 16 : 12.h),
                      child: const ShimmerBillTile(),
                    ),
              )
              : ValueListenableBuilder<List<ProductModel>>(
                valueListenable: filteredEditProductNotifier,
                builder: (_, products, __) {
                  if (products.isEmpty) {
                    return _isSearching
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: isWeb ? 20.sp : 60.sp,
                              color: AppColors.primary,
                            ),
                            SizedBox(height: isWeb ? 20 : 16.h),
                            Text(
                              "No matching product found",
                              style: TextStyle(
                                fontSize: isWeb ? 6.sp : 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                        : EmptyPlaceholder(
                          imagePath: 'assets/images/empty_product.png',
                          message:
                              'No products added yet.\nAdd products to manage and edit them here!',
                          onActionTap:
                              () => Navigator.pushNamed(
                                context,
                                AppRoutes.addProduct,
                              ),
                          actionIcon: Icons.add_box_outlined,
                          actionText: 'add product',
                        );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWeb ? 30 : 16.w,
                    ),
                    itemCount: products.length,
                    itemBuilder: (_, index) {
                      final product = products[index];
                      return ProductEditDeleteCard(
                        context: context,
                        searchController: _searchController,
                        searchFocusNode: _searchFocusNode,
                        product: product,
                      );
                    },
                  );
                },
              ),
    );
  }
}
