import 'package:beatbox/core/notifiers/limited_stock_notifier.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/utils/product_utils.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LimitedStockUtils {
  static bool _initialLoaded = false;

  static Future<void> filterLimitedStockProducts() async {
    if (!_initialLoaded) {
      limitedStockShimmerNotifier.value = true;
    }

    final box = await Hive.openBox<ProductModel>('productBox');
    final allProducts = box.values.toList();

    final filtered =
        allProducts.where((product) {
          return product.productQuantity < 5 ||
              ProductUtils.getProductLabel(product).contains("Limited");
        }).toList();

    filtered.sort((a, b) => a.productQuantity.compareTo(b.productQuantity));
    limitedStockNotifier.value = filtered;

    await Future.delayed(const Duration(milliseconds: 300));

    if (!_initialLoaded) {
      limitedStockShimmerNotifier.value = false;
      _initialLoaded = true;
    }
  }

  static Future<void> searchLimitedProducts(String query) async {
    limitedStockShimmerNotifier.value = true;

    final box = await Hive.openBox<ProductModel>('productBox');
    final allProducts = box.values.toList();
    final lowerQuery = query.toLowerCase().trim();

    final filtered =
        allProducts.where((product) {
          final isLimited =
              product.productQuantity < 5 ||
              ProductUtils.getProductLabel(product).contains("Limited");
          final matchName = product.productName.toLowerCase().contains(
            lowerQuery,
          );
          final matchCode = product.productCode.toLowerCase().contains(
            lowerQuery,
          );
          return isLimited && (matchName || matchCode);
        }).toList();

    filtered.sort((a, b) => a.productQuantity.compareTo(b.productQuantity));
    limitedStockNotifier.value = filtered;

    await Future.delayed(const Duration(milliseconds: 300));
    limitedStockShimmerNotifier.value = false;
  }
}
