import 'package:flutter/material.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';

// All bills fetched from DB
ValueNotifier<List<SalesModel>> allBillNotifier = ValueNotifier([]);

// Filtered bills after search/filter
ValueNotifier<List<SalesModel>> filteredBillNotifier = ValueNotifier([]);

// Shimmer loading
ValueNotifier<bool> isBillLoadingNotifier = ValueNotifier(true);

//  Reload check
ValueNotifier<bool> isBillReloadNeeded = ValueNotifier(true);
