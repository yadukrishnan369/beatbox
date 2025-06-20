import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/filter_product_notifier.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/utils/product_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductViewSwitcher extends StatelessWidget {
  final ValueNotifier<bool> viewToggleNotifier;

  const ProductViewSwitcher({super.key, required this.viewToggleNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ProductModel>>(
      valueListenable: filteredProductNotifier,
      builder: (context, products, _) {
        if (products.isEmpty) {
          return _productEmptyView();
        }

        return ValueListenableBuilder<bool>(
          valueListenable: viewToggleNotifier,
          builder: (context, isGridView, _) {
            return isGridView
                ? _buildGridView(context, products)
                : _buildListView(context, products);
          },
        );
      },
    );
  }

  Widget _buildGridView(BuildContext context, List<ProductModel> products) {
    return GridView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15.h,
        crossAxisSpacing: 15.w,
        childAspectRatio: 0.75,
      ),
      itemBuilder:
          (context, index) => _buildProductGridCard(context, products[index]),
    );
  }

  Widget _buildListView(BuildContext context, List<ProductModel> products) {
    return ListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: products.length,
      itemBuilder:
          (context, index) => _buildProductListTile(context, products[index]),
    );
  }

  Widget _productEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80.sp,
            color: AppColors.bottomNavColor,
          ),
          SizedBox(height: 10.h),
          Text(
            'No products found',
            style: TextStyle(fontSize: 16.sp, color: AppColors.primary),
          ),
          SizedBox(height: 4.h),
          Text(
            'Try searching something else',
            style: TextStyle(fontSize: 14.sp, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGridCard(BuildContext context, product) {
    final bool isOutOfStock = product.productQuantity == 0;

    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () => _navigateToProductDetails(context, product),
          child: Opacity(
            opacity: isOutOfStock ? 0.5 : 1.0,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 1.r,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.offWhite,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12.r),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.r),
                              topRight: Radius.circular(10.r),
                            ),
                            child:
                                product.image1 != null
                                    ? Image.file(
                                      File(product.image1!),
                                      fit: BoxFit.cover,
                                    )
                                    : Center(
                                      child: Icon(Icons.image, size: 40.sp),
                                    ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.all(7.r),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  product.productName,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 3.h),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'RS ',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '${product.salePrice.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  ProductUtils.getProductLabel(product),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: ProductUtils.getProductLabelColor(
                                      product,
                                    ),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductListTile(BuildContext context, product) {
    final bool isOutOfStock = product.productQuantity == 0;

    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () => _navigateToProductDetails(context, product),
          child: Opacity(
            opacity: isOutOfStock ? 0.5 : 1.0,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(color: AppColors.textDisabled, blurRadius: 1.r),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10.r),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child:
                          product.image1 != null
                              ? Image.file(
                                File(product.image1!),
                                fit: BoxFit.cover,
                                width: 80.w,
                                height: 90.h,
                              )
                              : Center(child: Icon(Icons.image, size: 40.sp)),
                    ),
                    title: Text(
                      product.productName,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.h),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'RS ',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '${product.salePrice.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          ProductUtils.getProductLabel(product),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: ProductUtils.getProductLabelColor(product),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToProductDetails(BuildContext context, ProductModel product) {
    Navigator.pushNamed(context, AppRoutes.productDetails, arguments: product);
  }
}
