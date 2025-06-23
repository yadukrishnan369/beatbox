import 'package:beatbox/core/notifiers/sales_notifier.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:hive/hive.dart';

class SalesUtils {
  static Future<void> loadSales() async {
    isSalesLoadingNotifier.value = true; // 🔴 start shimmer
    final box = await Hive.openBox<SalesModel>('salesBox');
    final List<SalesModel> allSales =
        box.values.toList()
          ..sort((a, b) => b.billingDate.compareTo(a.billingDate));
    filteredSalesNotifier.value = [...allSales];
    await Future.delayed(const Duration(milliseconds: 300)); // optional delay
    isSalesLoadingNotifier.value = false; // ✅ stop shimmer
  }

  static Future<void> loadSalesWithoutShimmer() async {
    final box = await Hive.openBox<SalesModel>('salesBox');
    final List<SalesModel> allSales =
        box.values.toList()
          ..sort((a, b) => b.billingDate.compareTo(a.billingDate));
    filteredSalesNotifier.value = [...allSales];
  }

  static Future<void> filterSalesByNameAndDate({
    required String query,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    isSalesLoadingNotifier.value = true; // 🔴 start shimmer
    final box = await Hive.openBox<SalesModel>('salesBox');
    List<SalesModel> allSales = box.values.toList();

    if (query.trim().isNotEmpty) {
      final lowerQuery = query.trim().toLowerCase();
      allSales =
          allSales.where((sale) {
            return sale.customerName.toLowerCase().contains(lowerQuery) ||
                sale.invoiceNumber.toLowerCase().contains(lowerQuery);
          }).toList();
    }

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
    isSalesLoadingNotifier.value = false; // ✅ stop shimmer
  }

  static Future<Map<String, double>> getTodaySalesAndProfit() async {
    final box = await Hive.openBox<SalesModel>('salesBox');
    final today = DateTime.now();

    // Filter only today's sales
    final todaySales = box.values.where((sale) {
      return sale.billingDate.year == today.year &&
          sale.billingDate.month == today.month &&
          sale.billingDate.day == today.day;
    });

    double totalSales = 0.0;
    double totalProfit = 0.0;

    for (var sale in todaySales) {
      totalSales += sale.grandTotal;

      for (var item in sale.cartItems) {
        final cost = item.product.purchaseRate;
        final sell = item.product.salePrice;
        final qty = item.quantity;

        totalProfit += (sell - cost) * qty;
      }
    }

    return {'sales': totalSales, 'profit': totalProfit};
  }
}
