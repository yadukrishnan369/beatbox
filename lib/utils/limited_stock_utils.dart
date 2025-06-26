import 'package:beatbox/core/notifiers/product_add_notifier.dart';
import 'package:beatbox/core/notifiers/filter_product_notifier.dart';
import 'package:beatbox/utils/product_utils.dart';

class LimitedStockUtils {
  static void filterLimitedStockProducts() {
    final allProducts = productAddNotifier.value;

    final filtered =
        allProducts.where((product) {
          return product.productQuantity < 5 ||
              ProductUtils.getProductLabel(product).contains("Limited");
        }).toList();

    filtered.sort((a, b) => a.productQuantity.compareTo(b.productQuantity));
    filteredProductNotifier.value = filtered;
    productShimmerNotifier.value = false;
  }

  static Future<void> searchLimitedProducts(String query) async {
    productShimmerNotifier.value = true;
    await Future.delayed(Duration(milliseconds: 300));

    final lowerQuery = query.toLowerCase().trim();
    final allProducts = productAddNotifier.value;

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
    filteredProductNotifier.value = filtered;
    productShimmerNotifier.value = false;
  }
}
