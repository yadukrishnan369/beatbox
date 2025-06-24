import 'package:flutter/material.dart';
import 'package:beatbox/utils/product_utils.dart';
import 'package:intl/intl.dart';

class StockEntryUtils {
  static Future<void> loadProducts({
    required bool isReloadNeeded,
    required ValueNotifier<bool> isReloadNotifier,
    required Function(bool) setLoadingState,
  }) async {
    if (isReloadNeeded) {
      setLoadingState(true);
      await ProductUtils.loadProducts();
      await Future.delayed(const Duration(milliseconds: 300));
      setLoadingState(false);
      isReloadNotifier.value = false;
    } else {
      setLoadingState(false);
    }
  }

  static Future<void> pickDateRange({
    required BuildContext context,
    required Function(DateTime?) setFromDate,
    required Function(DateTime?) setToDate,
    required Function(bool) setLoadingState,
    required String searchQuery,
  }) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setFromDate(picked.start);
      setToDate(picked.end);
      setLoadingState(true);

      ProductUtils.filterProductsByNameAndDate(
        query: searchQuery,
        startDate: picked.start,
        endDate: picked.end,
      );

      await Future.delayed(const Duration(milliseconds: 300));
      setLoadingState(false);
    }
  }

  static Future<void> clearDateFilter({
    required Function(DateTime?) setFromDate,
    required Function(DateTime?) setToDate,
    required Function(bool) setLoadingState,
    required String searchQuery,
  }) async {
    setFromDate(null);
    setToDate(null);
    setLoadingState(true);

    ProductUtils.filterProductsByNameAndDate(
      query: searchQuery.trim(),
      startDate: null,
      endDate: null,
    );

    await Future.delayed(const Duration(milliseconds: 300));
    setLoadingState(false);
  }

  static Future<void> searchProducts({
    required String query,
    required DateTime? fromDate,
    required DateTime? toDate,
    required Function(bool) setLoadingState,
  }) async {
    setLoadingState(true);
    ProductUtils.filterProductsByNameAndDate(
      query: query,
      startDate: fromDate,
      endDate: toDate,
    );
    await Future.delayed(const Duration(milliseconds: 300));
    setLoadingState(false);
  }

  static String formatDate(DateTime? date) {
    return date != null ? DateFormat('dd MMM yyyy').format(date) : '';
  }
}
