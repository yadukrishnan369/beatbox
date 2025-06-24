import 'package:beatbox/core/notifiers/bill_notifier.dart';
import 'package:hive/hive.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';

class BillUtils {
  static Future<void> loadBills() async {
    isBillLoadingNotifier.value = true;
    await _fetchSortedBillsAndUpdateNotifier();
    await Future.delayed(const Duration(milliseconds: 300));
    isBillLoadingNotifier.value = false;
  }

  static Future<void> loadBillsWithoutShimmer() async {
    await _fetchSortedBillsAndUpdateNotifier();
  }

  static Future<void> filterBillsByNameAndDate({
    required String query,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    isBillLoadingNotifier.value = true;

    final box = await Hive.openBox<SalesModel>('salesBox');
    List<SalesModel> allBills = box.values.toList();

    if (query.trim().isNotEmpty) {
      final lowerQuery = query.trim().toLowerCase();
      allBills =
          allBills.where((sale) {
            return sale.customerName.toLowerCase().contains(lowerQuery) ||
                sale.invoiceNumber.toLowerCase().contains(lowerQuery);
          }).toList();
    }

    if (startDate != null && endDate != null) {
      allBills =
          allBills.where((sale) {
            final billingDate = sale.billingDate;
            return billingDate.isAfter(
                  startDate.subtract(const Duration(days: 1)),
                ) &&
                billingDate.isBefore(endDate.add(const Duration(days: 1)));
          }).toList();
    }

    allBills.sort((a, b) => b.billingDate.compareTo(a.billingDate));
    filteredBillNotifier.value = [...allBills];

    await Future.delayed(const Duration(milliseconds: 300));
    isBillLoadingNotifier.value = false;
  }

  static Future<void> _fetchSortedBillsAndUpdateNotifier() async {
    final box = await Hive.openBox<SalesModel>('salesBox');
    final sortedList =
        box.values.toList()
          ..sort((a, b) => b.billingDate.compareTo(a.billingDate));
    filteredBillNotifier.value = [...sortedList];
  }
}
