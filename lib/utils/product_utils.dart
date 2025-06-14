import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/filter_product_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/core/notifiers/product_add_notifier.dart';

class ProductUtils {
  static Future<void> loadProducts() async {
    final box = await Hive.openBox<ProductModel>('productBox');
    final allProducts =
        box.values.toList()
          ..sort((a, b) => b.createdDate.compareTo(a.createdDate));
    productAddNotifier.value = allProducts;
    filteredProductNotifier.value = allProducts;
  }

  //filter by name and categories and brands of product screen
  static void filterProducts(
    String query, {
    List<String>? selectedCategories,
    List<String>? selectedBrands,
  }) {
    final box = Hive.box<ProductModel>('productBox');
    final allProducts =
        box.values.toList()
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
  }

  //filter by name and dates range of stock entry screen
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

  static Future<void> deleteProduct(
    ProductModel product,
    String currentQuery,
  ) async {
    final box = Hive.box<ProductModel>('productBox');
    await box.delete(product.key);
    filterProducts(currentQuery);
  }

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
