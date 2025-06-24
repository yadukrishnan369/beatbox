import 'package:beatbox/core/notifiers/sales_notifier.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:hive/hive.dart';

class SalesUtils {
  /// Load sales with shimmer
  static Future<void> loadSales() async {
    isSalesLoadingNotifier.value = true;
    await _fetchSortedSalesAndUpdateNotifier();
    await Future.delayed(const Duration(milliseconds: 300));
    isSalesLoadingNotifier.value = false;
  }

  /// Load sales without shimmer
  static Future<void> loadSalesWithoutShimmer() async {
    await _fetchSortedSalesAndUpdateNotifier();
  }

  /// Filter by search and date range
  static Future<void> filterSalesByNameAndDate({
    required String query,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    isSalesLoadingNotifier.value = true;

    final box = await Hive.openBox<SalesModel>('salesBox');
    List<SalesModel> allSales = box.values.toList();

    // Filter by name or invoice
    if (query.trim().isNotEmpty) {
      final lowerQuery = query.trim().toLowerCase();
      allSales =
          allSales.where((sale) {
            return sale.customerName.toLowerCase().contains(lowerQuery) ||
                sale.invoiceNumber.toLowerCase().contains(lowerQuery);
          }).toList();
    }

    // Filter by date
    if (startDate != null && endDate != null) {
      allSales =
          allSales.where((sale) {
            final billingDate = sale.billingDate;
            return billingDate.isAfter(
                  startDate.subtract(const Duration(days: 1)),
                ) &&
                billingDate.isBefore(endDate.add(const Duration(days: 1)));
          }).toList();
    }

    allSales.sort((a, b) => b.billingDate.compareTo(a.billingDate));
    filteredSalesNotifier.value = [...allSales];

    await Future.delayed(const Duration(milliseconds: 300));
    isSalesLoadingNotifier.value = false;
  }

  /// Calculate today's total sales and profit
  static Future<Map<String, double>> getTodaySalesAndProfit() async {
    final box = await Hive.openBox<SalesModel>('salesBox');
    final today = DateTime.now();

    final todaySales = box.values.where(
      (sale) =>
          sale.billingDate.year == today.year &&
          sale.billingDate.month == today.month &&
          sale.billingDate.day == today.day,
    );

    double totalSales = 0.0;
    double totalProfit = 0.0;

    for (var sale in todaySales) {
      totalSales += sale.grandTotal;

      for (var item in sale.cartItems) {
        final cost = item.product.purchaseRate;
        final sell = item.product.salePrice;
        final qty = item.quantity;
        final discount = sale.discount;

        totalProfit += (sell - cost) * qty - discount;
      }
    }

    return {'sales': totalSales, 'profit': totalProfit};
  }

  static Future<void> _fetchSortedSalesAndUpdateNotifier() async {
    final box = await Hive.openBox<SalesModel>('salesBox');
    final List<SalesModel> allSales =
        box.values.toList()
          ..sort((a, b) => b.billingDate.compareTo(a.billingDate));
    filteredSalesNotifier.value = [...allSales];
  }
}
