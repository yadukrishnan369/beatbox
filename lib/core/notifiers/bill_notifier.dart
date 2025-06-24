import 'package:flutter/material.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';

ValueNotifier<List<SalesModel>> filteredBillNotifier = ValueNotifier([]);
ValueNotifier<bool> isBillLoadingNotifier = ValueNotifier(true);
ValueNotifier<bool> isBillReloadNeeded = ValueNotifier(true);
