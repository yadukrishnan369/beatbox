import 'package:beatbox/core/notifiers/insight_notifier.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:hive/hive.dart';

DateTime? selectedRangeStart;
DateTime? selectedRangeEnd;

/// Load all sales to insight
Future<void> loadInsightSales() async {
  final box = await Hive.openBox<SalesModel>('salesBox');

  final allSales =
      box.values.toList()
        ..sort((a, b) => b.billingDate.compareTo(a.billingDate));

  insightAllSalesNotifier.value = [...allSales];
  insightSalesNotifier.value = [...allSales];

  _updateEmptyState();
}

/// Filter insight sales by date range
void filterInsightSalesByRange(DateTime start, DateTime end) {
  selectedRangeStart = start;
  selectedRangeEnd = end;

  final startDate = DateTime(start.year, start.month, start.day);
  final endDate = DateTime(end.year, end.month, end.day);

  final filtered =
      insightAllSalesNotifier.value.where((sale) {
        final billingDate = DateTime(
          sale.billingDate.year,
          sale.billingDate.month,
          sale.billingDate.day,
        );

        return (billingDate.isAtSameMomentAs(startDate) ||
                billingDate.isAfter(startDate)) &&
            (billingDate.isAtSameMomentAs(endDate) ||
                billingDate.isBefore(endDate));
      }).toList();

  filtered.sort((a, b) => b.billingDate.compareTo(a.billingDate));

  insightSalesNotifier.value = [...filtered];
  _updateEmptyState();
}

/// Grouped chart data by date
Map<DateTime, Map<String, double>> getInsightChartData() {
  Map<DateTime, Map<String, double>> chartMap = {};

  if (selectedRangeStart == null || selectedRangeEnd == null) return chartMap;

  final rangeLength =
      selectedRangeEnd!.difference(selectedRangeStart!).inDays + 1;

  for (final sale in insightSalesNotifier.value) {
    DateTime groupDate;

    if (rangeLength <= 7) {
      // Group by Day
      groupDate = DateTime(
        sale.billingDate.year,
        sale.billingDate.month,
        sale.billingDate.day,
      );
    } else if (rangeLength <= 31) {
      // Group by Week
      final date = sale.billingDate;
      groupDate = DateTime(date.year, date.month, date.day - date.weekday + 1);
    } else {
      // Group by Month
      groupDate = DateTime(sale.billingDate.year, sale.billingDate.month);
    }

    chartMap[groupDate] ??= {'sales': 0, 'profit': 0};

    double totalWithoutGST = 0.0;
    double totalProfit = 0.0;

    for (final item in sale.cartItems) {
      final qty = item.quantity;
      final sell = item.product.salePrice;
      final cost = item.product.purchaseRate;
      final discount = sale.discount;

      totalWithoutGST += sell * qty;
      totalProfit += (sell - cost) * qty;
      totalProfit -= discount;
    }

    chartMap[groupDate]!['sales'] =
        chartMap[groupDate]!['sales']! + totalWithoutGST;
    chartMap[groupDate]!['profit'] =
        chartMap[groupDate]!['profit']! + totalProfit;
  }

  final sortedKeys = chartMap.keys.toList()..sort();
  return Map.fromEntries(
    sortedKeys.map((key) => MapEntry(key, chartMap[key]!)),
  );
}

/// Table data grouped by product
List<Map<String, dynamic>> getInsightTableData() {
  Map<String, Map<String, dynamic>> tableMap = {};

  for (final sale in insightSalesNotifier.value) {
    for (final item in sale.cartItems) {
      final name = item.product.productName;
      final qty = item.quantity;
      final sell = item.product.salePrice;
      final cost = item.product.purchaseRate;
      final total = sell * qty;
      final profit = (sell - cost) * qty;

      if (tableMap.containsKey(name)) {
        tableMap[name]!['qty'] += qty;
        tableMap[name]!['total'] += total;
        tableMap[name]!['profit'] += profit;
      } else {
        tableMap[name] = {
          'product': name,
          'qty': qty,
          'total': total,
          'profit': profit,
        };
      }
    }
  }

  return tableMap.values.toList();
}

/// Check if data is empty and update notifier
void _updateEmptyState() {
  isInsightEmptyNotifier.value = insightSalesNotifier.value.isEmpty;
}
