import 'package:beatbox/core/notifiers/stock_entry_notifier.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:hive/hive.dart';

class StockEntryUtils {
  /// Show shimmer and load all products
  static Future<void> loadAllProducts() async {
    isStockEntryLoadingNotifier.value = true;
    await _fetchSortedProductsAndUpdateNotifier();
    await Future.delayed(const Duration(milliseconds: 300));
    isStockEntryLoadingNotifier.value = false;
  }

  /// Load all products without shimmer
  static Future<void> loadProductsWithoutShimmer() async {
    await _fetchSortedProductsAndUpdateNotifier();
  }

  /// Filter based on name/code and date
  static Future<void> filterByNameAndDate({
    required String query,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    isStockEntryLoadingNotifier.value = true;

    final box = Hive.box<ProductModel>('productBox');
    List<ProductModel> all =
        box.values.toList()
          ..sort((a, b) => b.createdDate.compareTo(a.createdDate));

    if (query.trim().isNotEmpty) {
      final lower = query.toLowerCase().trim();
      all =
          all.where((p) {
            return p.productName.toLowerCase().contains(lower) ||
                p.productCode.toLowerCase().contains(lower);
          }).toList();
    }

    if (startDate != null && endDate != null) {
      all =
          all.where((p) {
            return p.createdDate.isAfter(
                  startDate.subtract(const Duration(days: 1)),
                ) &&
                p.createdDate.isBefore(endDate.add(const Duration(days: 1)));
          }).toList();
    }

    stockEntryNotifier.value = [...all];

    await Future.delayed(const Duration(milliseconds: 300));
    isStockEntryLoadingNotifier.value = false;
  }

  static Future<void> _fetchSortedProductsAndUpdateNotifier() async {
    final box = await Hive.openBox<ProductModel>('productBox');
    final all =
        box.values.toList()
          ..sort((a, b) => b.createdDate.compareTo(a.createdDate));
    stockEntryNotifier.value = [...all];
  }
}
