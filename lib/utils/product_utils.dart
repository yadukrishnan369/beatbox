import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/filter_product_notifier.dart';
import 'package:beatbox/features/product_management/controller/product_controller.dart';
import 'package:beatbox/features/product_management/ui/add_edit_product_screen.dart';
import 'package:beatbox/widgets/Loading_widgets/show_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/core/notifiers/product_add_notifier.dart';

class ProductUtils {
  // get all products function
  static Future<void> loadProducts({bool showShimmer = true}) async {
    if (showShimmer) productShimmerNotifier.value = true;

    final box = await Hive.openBox<ProductModel>('productBox');
    final allProducts =
        box.values.where((product) => product.isAvailableForSale).toList()
          ..sort((a, b) => b.createdDate.compareTo(a.createdDate));

    productAddNotifier.value = allProducts;
    filteredProductNotifier.value = allProducts;

    await Future.delayed(Duration(milliseconds: 300));
    productShimmerNotifier.value = false;
  }

  // filter by name and categories and brands of product screen
  static void filterProducts(
    String query, {
    List<String>? selectedCategories,
    List<String>? selectedBrands,
  }) async {
    productShimmerNotifier.value = true;

    await Future.delayed(Duration(milliseconds: 300));

    final box = Hive.box<ProductModel>('productBox');
    final allProducts =
        box.values.where((product) => product.isAvailableForSale).toList()
          ..sort((a, b) => b.createdDate.compareTo(a.createdDate));

    final filtered =
        allProducts.where((product) {
          final matchName = product.productName.toLowerCase().contains(
            query.toLowerCase(),
          );
          final matchCode = product.productCode.toLowerCase().contains(
            query.toLowerCase(),
          );

          final matchCategory =
              selectedCategories == null || selectedCategories.isEmpty
                  ? true
                  : selectedCategories.contains(product.productCategory);

          final matchBrand =
              selectedBrands == null || selectedBrands.isEmpty
                  ? true
                  : selectedBrands.contains(product.productBrand);

          return (matchName || matchCode) && matchCategory && matchBrand;
        }).toList();

    filteredProductNotifier.value = filtered;
    productShimmerNotifier.value = false;
  }

  // filter by name and date range of stock entry screen
  static void filterProductsByNameAndDate({
    required String query,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final box = Hive.box<ProductModel>('productBox');
    final allProducts =
        box.values.toList()
          ..sort((a, b) => b.createdDate.compareTo(a.createdDate));

    final lowerQuery = query.toLowerCase().trim();

    final filtered =
        allProducts.where((product) {
          final matchName =
              lowerQuery.isEmpty
                  ? true
                  : product.productName.toLowerCase().contains(lowerQuery);

          final matchDate =
              (startDate == null || endDate == null)
                  ? true
                  : (product.createdDate.isAfter(
                        startDate.subtract(const Duration(days: 1)),
                      ) &&
                      product.createdDate.isBefore(
                        endDate.add(const Duration(days: 1)),
                      ));

          return matchName && matchDate;
        }).toList();

    filteredProductNotifier.value = filtered;
  }

  // edit and delete product functions
  static void editProduct(BuildContext context, ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddProductScreen(productToEdit: product),
      ),
    ).then((_) {
      isProductReloadNeeded.value = true;
      loadProducts();
    });
  }

  static void confirmDeleteProduct(
    BuildContext context,
    ProductModel product,
    TextEditingController searchController,
    FocusNode searchFocusNode,
  ) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
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
                  await deleteProduct(product, searchController.text);
                  isProductReloadNeeded.value = true;
                  await showLoadingDialog(
                    context,
                    message: "Deleting...",
                    showSucess: true,
                  );
                  searchController.clear();
                  searchFocusNode.unfocus();
                  filterProducts('');
                },
                child: Text('Delete', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
    );
  }

  static Future<void> deleteProduct(
    ProductModel product,
    String currentQuery,
  ) async {
    await ProductController.deleteProduct(product);
    filterProducts(currentQuery);
  }

  // product quantity adjustment functions
  static int incrementQuantity({
    required int currentQuantity,
    required int availableQuantity,
    required BuildContext context,
  }) {
    if (currentQuantity < availableQuantity) {
      return currentQuantity + 1;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Only $availableQuantity items available"),
          backgroundColor: Colors.red,
        ),
      );
      return currentQuantity;
    }
  }

  static int decrementQuantity(int currentQuantity) {
    return currentQuantity > 1 ? currentQuantity - 1 : 1;
  }

  // get product label function
  static String getProductLabel(ProductModel product) {
    const int arrivalLabelDays = 7;
    const int limitedCount = 5;

    if (product.productQuantity == 0) {
      return 'Out of Stock';
    }

    final now = DateTime.now();
    final difference = now.difference(product.createdDate).inDays;
    final isNewArrival = difference <= arrivalLabelDays;
    final isLimitedStock = product.productQuantity < limitedCount;

    if (isNewArrival && isLimitedStock) {
      return 'New Arrival/Limited';
    } else if (isNewArrival) {
      return 'New Arrival';
    } else if (isLimitedStock) {
      return 'Limited Stock';
    }

    return '';
  }

  // get product label color function
  static Color getProductLabelColor(ProductModel product) {
    final label = getProductLabel(product);
    switch (label) {
      case 'Out of Stock':
        return AppColors.error;
      case 'Limited Stock':
        return AppColors.warning;
      case 'New Arrival':
        return AppColors.success;
      case 'New Arrival/Limited':
        return AppColors.blue;
      default:
        return Colors.transparent;
    }
  }
}
