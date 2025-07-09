import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/bill_notifier.dart';
import 'package:beatbox/widgets/Loading_widgets/show_loading_dialog.dart';
import 'package:flutter/material.dart';
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
            final billingDate = DateTime(
              sale.billingDate.year,
              sale.billingDate.month,
              sale.billingDate.day,
            );

            final start = DateTime(
              startDate.year,
              startDate.month,
              startDate.day,
            );
            final end = DateTime(endDate.year, endDate.month, endDate.day);

            return (billingDate.isAtSameMomentAs(start) ||
                    billingDate.isAfter(start)) &&
                (billingDate.isAtSameMomentAs(end) ||
                    billingDate.isBefore(end));
          }).toList();
    }

    allBills.sort((a, b) => b.billingDate.compareTo(a.billingDate));

    filteredBillNotifier.value = [...allBills];

    final boxAll = await Hive.openBox<SalesModel>('salesBox');
    allBillNotifier.value = [...boxAll.values];

    await Future.delayed(const Duration(milliseconds: 300));
    isBillLoadingNotifier.value = false;
  }

  static Future<void> _fetchSortedBillsAndUpdateNotifier() async {
    final box = await Hive.openBox<SalesModel>('salesBox');
    final sortedList =
        box.values.toList()
          ..sort((a, b) => b.billingDate.compareTo(a.billingDate));

    filteredBillNotifier.value = [...sortedList];
    allBillNotifier.value = [...box.values];
  }

  static Future<void> confirmAndDeleteBill(
    BuildContext context,
    SalesModel bill,
  ) async {
    final confirmFirst = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              "Delete Bill",
              style: TextStyle(color: AppColors.primary),
            ),
            content: Text(
              "Are you sure you want to delete this Bill ${bill.invoiceNumber}?",
              style: TextStyle(color: AppColors.textPrimary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  "Continue",
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
    );

    if (confirmFirst != true) return;

    final confirmSecond = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              "Confirm Deletion",
              style: TextStyle(color: AppColors.primary),
            ),
            content: Text(
              "Deleting this Bill is permanent! Do you want to proceed?",
              style: TextStyle(color: AppColors.textPrimary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
    );

    if (confirmSecond == true) {
      await bill.delete();
      await showLoadingDialog(
        context,
        message: 'Deleting...',
        showSucess: true,
      );
      await loadBillsWithoutShimmer();
      if (!context.mounted) return;

      Navigator.pop(context); // close details screen
      // show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Bill deleted successfully"),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
