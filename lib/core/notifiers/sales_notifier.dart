import 'package:flutter/material.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';

// All sales fetched from DB
ValueNotifier<List<SalesModel>> allSalesNotifier = ValueNotifier([]);

// Filtered sales after search/filter
ValueNotifier<List<SalesModel>> filteredSalesNotifier = ValueNotifier([]);

// Shimmer loading
ValueNotifier<bool> isSalesLoadingNotifier = ValueNotifier(true);

//  Reload check
ValueNotifier<bool> isSalesReloadNeeded = ValueNotifier(true);
