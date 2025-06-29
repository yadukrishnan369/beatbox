import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/core/notifiers/product_edit_delete_notifier.dart';
import 'package:hive/hive.dart';

class ProductEditDeleteUtils {
  static Future<void> loadProducts() async {
    editProductShimmerNotifier.value = true;
    final box = await Hive.openBox<ProductModel>('productBox');
    final products =
        box.values.toList()
          ..sort((a, b) => b.createdDate.compareTo(a.createdDate));

    allEditProductNotifier.value = [...products];
    filteredEditProductNotifier.value = [...products];

    await Future.delayed(const Duration(milliseconds: 300));
    editProductShimmerNotifier.value = false;
  }

  static Future<void> loadProductsWithoutShimmer() async {
    final box = await Hive.openBox<ProductModel>('productBox');
    final products =
        box.values.toList()
          ..sort((a, b) => b.createdDate.compareTo(a.createdDate));

    allEditProductNotifier.value = [...products];
    filteredEditProductNotifier.value = [...products];
  }

  static void filterProducts(String query) {
    final lower = query.trim().toLowerCase();

    final result =
        allEditProductNotifier.value.where((product) {
          return product.productName.toLowerCase().contains(lower) ||
              product.productCode.toLowerCase().contains(lower);
        }).toList();

    filteredEditProductNotifier.value = result;
  }
}
