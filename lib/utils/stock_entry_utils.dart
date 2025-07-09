import 'package:beatbox/core/notifiers/stock_entry_notifier.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:hive/hive.dart';

class StockEntryUtils {
  /// show shimmer and load all products
  static Future<void> loadAllProducts() async {
    isStockEntryLoadingNotifier.value = true;

    final box = await Hive.openBox<ProductModel>('productBox');
    final all =
        box.values.toList()
          ..sort((a, b) => b.createdDate.compareTo(a.createdDate));

    allStockEntryNotifier.value = [...all]; // full db list
    stockEntryNotifier.value = [...all]; // filtered or shown list

    await Future.delayed(const Duration(milliseconds: 300));
    isStockEntryLoadingNotifier.value = false;
  }

  /// load all products without shimmer
  static Future<void> loadProductsWithoutShimmer() async {
    final box = await Hive.openBox<ProductModel>('productBox');
    final all =
        box.values.toList()
          ..sort((a, b) => b.createdDate.compareTo(a.createdDate));

    allStockEntryNotifier.value = [...all];
    stockEntryNotifier.value = [...all];
  }

  /// filter based on name or code and date
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
            final created = DateTime(
              p.createdDate.year,
              p.createdDate.month,
              p.createdDate.day,
            );
            final start = DateTime(
              startDate.year,
              startDate.month,
              startDate.day,
            );
            final end = DateTime(endDate.year, endDate.month, endDate.day);

            return (created.isAtSameMomentAs(start) ||
                    created.isAfter(start)) &&
                (created.isAtSameMomentAs(end) || created.isBefore(end));
          }).toList();
    }

    stockEntryNotifier.value = [...all];

    await Future.delayed(const Duration(milliseconds: 300));
    isStockEntryLoadingNotifier.value = false;
  }
}
