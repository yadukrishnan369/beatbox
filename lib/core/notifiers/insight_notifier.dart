import 'package:flutter/material.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';

/// fetch all insight sales
ValueNotifier<List<SalesModel>> insightAllSalesNotifier = ValueNotifier([]);

/// Filtered sales data based on selected date range
ValueNotifier<List<SalesModel>> insightSalesNotifier = ValueNotifier([]);

/// Loader for shimmer, chart, and table
ValueNotifier<bool> isInsightLoadingNotifier = ValueNotifier(true);

/// if filtered sales list is empty
ValueNotifier<bool> isInsightEmptyNotifier = ValueNotifier(false);
