import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/filter_product_notifier.dart';
import 'package:beatbox/core/notifiers/product_add_notifier.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/features/product_management/ui/add_edit_product_screen.dart';
import 'package:beatbox/utils/product_utils.dart';
import 'package:beatbox/widgets/custom_search_bar.dart';
import 'package:beatbox/widgets/show_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateProductScreen extends StatefulWidget {
  final bool shouldFocusSearch;
  const UpdateProductScreen({super.key, this.shouldFocusSearch = false});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    ProductUtils.loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _editProduct(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddProductScreen(productToEdit: product),
      ),
    ).then((_) {
      ProductUtils.loadProducts();
    });
  }

  void _deleteProduct(ProductModel product) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.white,
            title: Text(
              'Delete Product',
              style: TextStyle(color: AppColors.primary),
            ),
            content: Text(
              'Are you sure you want to delete ${product.productName}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await ProductUtils.deleteProduct(
                    product,
                    _searchController.text,
                  );
                  await showLoadingDialog(
                    context,
                    message: "Deleting...",
                    showSucess: true,
                  );
                  _searchController.clear();
                  _searchFocusNode.unfocus();
                  ProductUtils.filterProducts('');
                },
                child: Text('Delete', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
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
            'Update products',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (productAddNotifier.value.isNotEmpty)
              CustomSearchBar(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: ProductUtils.filterProducts,
              ),

            // Products Label
            if (productAddNotifier.value.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 8.h),
                child: Text(
                  'Products',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

            // Product List or Empty View
            Expanded(
              child: ValueListenableBuilder<List<ProductModel>>(
                valueListenable: filteredProductNotifier,
                builder: (context, products, child) {
                  if (products.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              color: AppColors.textDisabled,
                              size: 60.sp,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'No products found',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textDisabled,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _buildProductItem(product);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(ProductModel product) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child:
                product.image1 != null && product.image1!.isNotEmpty
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.file(
                        File(product.image1!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.inventory_2,
                            color: AppColors.primary,
                            size: 24.sp,
                          );
                        },
                      ),
                    )
                    : Icon(
                      Icons.inventory_2,
                      color: AppColors.primary,
                      size: 24.sp,
                    ),
          ),

          SizedBox(width: 16.w),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'code: ${product.productCode}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textDisabled,
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Column(
            children: [
              // Edit Button
              Container(
                width: 70.w,
                height: 35.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: InkWell(
                  onTap: () => _editProduct(product),
                  borderRadius: BorderRadius.circular(6.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'edit',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(Icons.edit, color: AppColors.white, size: 14.sp),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              // Delete Button
              Container(
                width: 70.w,
                height: 35.h,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: InkWell(
                  onTap: () => _deleteProduct(product),
                  borderRadius: BorderRadius.circular(6.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'delete',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Icon(Icons.delete, color: AppColors.white, size: 14.sp),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
