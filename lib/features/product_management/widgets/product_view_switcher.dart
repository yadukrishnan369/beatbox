import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/filter_product_notifier.dart';
import 'package:beatbox/core/notifiers/product_add_notifier.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/utils/product_utils.dart';
import 'package:beatbox/widgets/shimmer_widgets/shimmer_product_grid.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Uint8List? decodeBase64Image(String? base64String) {
  try {
    if (base64String == null || base64String.trim().isEmpty) return null;
    return base64Decode(base64String);
  } catch (e) {
    print("Error decoding base64 image: $e");
    return null;
  }
}

class ProductViewSwitcher extends StatelessWidget {
  final ValueNotifier<bool> viewToggleNotifier;

  const ProductViewSwitcher({super.key, required this.viewToggleNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ProductModel>>(
      valueListenable: filteredProductNotifier,
      builder: (context, products, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: viewToggleNotifier,
          builder: (context, isGridView, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: productShimmerNotifier,
              builder: (context, isLoading, _) {
                if (isLoading) {
                  return ShimmerProductGrid(isGridView: isGridView);
                }

                if (products.isEmpty) {
                  return _productEmptyView();
                }

                return isGridView
                    ? _buildGridView(context, products)
                    : _buildListView(context, products);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildGridView(BuildContext context, List<ProductModel> products) {
    final double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    double aspectRatio = 0.75;

    if (kIsWeb) {
      if (screenWidth >= 1400) {
        crossAxisCount = 5;
        aspectRatio = 0.8;
      } else if (screenWidth >= 1200) {
        crossAxisCount = 4;
        aspectRatio = 0.8;
      } else if (screenWidth >= 800) {
        crossAxisCount = 3;
        aspectRatio = 0.75;
      }
    }

    return GridView.builder(
      padding: EdgeInsets.all(kIsWeb ? 20 : 16.r),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: kIsWeb ? 20 : 15.h,
        crossAxisSpacing: kIsWeb ? 20 : 15.w,
        childAspectRatio: aspectRatio,
      ),
      itemBuilder:
          (context, index) => _buildProductGridCard(context, products[index]),
    );
  }

  Widget _buildListView(BuildContext context, List<ProductModel> products) {
    return ListView.builder(
      padding: EdgeInsets.all(kIsWeb ? 20 : 16.r),
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
            Icons.search_off_rounded,
            size: kIsWeb ? 40 : 60.sp,
            color: AppColors.primary,
          ),
          SizedBox(height: kIsWeb ? 10 : 16.h),
          Text(
            "No matching product found",
            style: TextStyle(
              fontSize: kIsWeb ? 15 : 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: kIsWeb ? 8 : 12.h),
          Text(
            'Try searching something else',
            style: TextStyle(
              fontSize: kIsWeb ? 12 : 14.sp,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGridCard(BuildContext context, ProductModel product) {
    final bool isOutOfStock = product.productQuantity == 0;

    return GestureDetector(
      onTap: () => _navigateToProductDetails(context, product),
      child: Opacity(
        opacity: isOutOfStock ? 0.5 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 1.r,
                offset: const Offset(0, 2),
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
                    child: _buildProductImage(product),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(kIsWeb ? 8 : 7.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        product.productName,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: kIsWeb ? 14 : 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: kIsWeb ? 4 : 3.h),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'RS ',
                              style: TextStyle(
                                fontSize: kIsWeb ? 13 : 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            TextSpan(
                              text: '${product.salePrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: kIsWeb ? 13 : 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: kIsWeb ? 3 : 3.h),
                      Expanded(
                        child: Center(
                          child: Text(
                            ProductUtils.getProductLabel(product),
                            style: TextStyle(
                              fontSize: kIsWeb ? 13 : 16.sp,
                              color: ProductUtils.getProductLabelColor(product),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductListTile(BuildContext context, ProductModel product) {
    final bool isOutOfStock = product.productQuantity == 0;

    return GestureDetector(
      onTap: () => _navigateToProductDetails(context, product),
      child: Opacity(
        opacity: isOutOfStock ? 0.5 : 1.0,
        child: Container(
          margin: EdgeInsets.only(bottom: kIsWeb ? 14 : 12.h),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(color: AppColors.textDisabled, blurRadius: 1.r),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(kIsWeb ? 12 : 10.r),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: SizedBox(
                width: kIsWeb ? 70 : 80.w,
                height: kIsWeb ? 85 : 90.h,
                child: _buildProductImage(product),
              ),
            ),
            title: Text(
              product.productName,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                fontSize: kIsWeb ? 14 : null,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: kIsWeb ? 3 : 4.h),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'RS ',
                        style: TextStyle(
                          fontSize: kIsWeb ? 13 : 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextSpan(
                        text: '${product.salePrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: kIsWeb ? 13 : 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: kIsWeb ? 6 : 8.h),
                Text(
                  ProductUtils.getProductLabel(product),
                  style: TextStyle(
                    fontSize: kIsWeb ? 12 : 13.sp,
                    color: ProductUtils.getProductLabelColor(product),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(ProductModel product) {
    if (kIsWeb) {
      final base64 = decodeBase64Image(product.webImage1);
      return base64 != null
          ? Image.memory(base64, fit: BoxFit.cover)
          : Center(child: Icon(Icons.image, size: kIsWeb ? 30 : 40.sp));
    } else {
      if (product.image1 != null && File(product.image1!).existsSync()) {
        return Image.file(File(product.image1!), fit: BoxFit.cover);
      } else {
        return Center(child: Icon(Icons.image, size: kIsWeb ? 30 : 40.sp));
      }
    }
  }

  void _navigateToProductDetails(BuildContext context, ProductModel product) {
    Navigator.pushNamed(context, AppRoutes.productDetails, arguments: product);
  }
}
