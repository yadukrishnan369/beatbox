import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/sales_notifier.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:beatbox/widgets/Loading_widgets/show_loading_dialog.dart';
import 'package:flutter/material.dart';
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
    List<SalesModel> filtered = box.values.toList();

    // Filter by search
    if (query.trim().isNotEmpty) {
      final lowerQuery = query.trim().toLowerCase();
      filtered =
          filtered.where((sale) {
            return sale.customerName.toLowerCase().contains(lowerQuery) ||
                sale.invoiceNumber.toLowerCase().contains(lowerQuery);
          }).toList();
    }

    // Filter by date
    if (startDate != null && endDate != null) {
      filtered =
          filtered.where((sale) {
            final billingDate = sale.billingDate;
            return billingDate.isAfter(
                  startDate.subtract(const Duration(days: 1)),
                ) &&
                billingDate.isBefore(endDate.add(const Duration(days: 1)));
          }).toList();
    }

    // Sort filtered
    filtered.sort((a, b) => b.billingDate.compareTo(a.billingDate));

    //  Update only filtered list
    filteredSalesNotifier.value = [...filtered];

    await Future.delayed(const Duration(milliseconds: 300));
    isSalesLoadingNotifier.value = false;
  }

  /// Get today's sales and profit
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
      totalSales += sale.subtotal;

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

    allSalesNotifier.value = [...allSales];
    filteredSalesNotifier.value = [...allSales];
  }

  static Future<void> confirmAndDeleteSale(
    BuildContext context,
    SalesModel sale,
  ) async {
    final confirmFirst = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              "Delete Sale",
              style: TextStyle(color: AppColors.primary),
            ),
            content: Text(
              "Are you sure you want to delete this Sale ${sale.orderNumber}?",
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
              "Deleting this Sale is permanent! Do you want to proceed?",
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
      await sale.delete();
      await showLoadingDialog(
        context,
        message: 'Deleting...',
        showSucess: true,
      );
      await loadSalesWithoutShimmer();
      if (!context.mounted) return;

      Navigator.pop(context); // Close details screen
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sale deleted successfully"),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
