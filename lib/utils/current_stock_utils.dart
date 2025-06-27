import 'package:beatbox/core/notifiers/current_stock_notifier.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CurrentStockUtils {
  static bool _initialLoaded = false;

  static Future<void> filterCurrentStockProducts() async {
    if (!_initialLoaded) {
      currentStockShimmerNotifier.value = true;
    }

    final box = await Hive.openBox<ProductModel>('productBox');
    final allProducts = box.values.toList();

    final filtered =
        allProducts.where((product) => product.productQuantity > 0).toList();

    filtered.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    currentStockNotifier.value = filtered;

    await Future.delayed(const Duration(milliseconds: 300));
    if (!_initialLoaded) {
      currentStockShimmerNotifier.value = false;
      _initialLoaded = true;
    }
  }

  static Future<void> searchCurrentStockProducts(String query) async {
    currentStockShimmerNotifier.value = true;

    final box = await Hive.openBox<ProductModel>('productBox');
    final allProducts = box.values.toList();
    final lowerQuery = query.toLowerCase().trim();

    final filtered =
        allProducts.where((product) {
          final matchName = product.productName.toLowerCase().contains(
            lowerQuery,
          );
          final matchCode = product.productCode.toLowerCase().contains(
            lowerQuery,
          );
          return product.productQuantity > 0 && (matchName || matchCode);
        }).toList();

    filtered.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    currentStockNotifier.value = filtered;

    await Future.delayed(const Duration(milliseconds: 300));
    currentStockShimmerNotifier.value = false;
  }
}
