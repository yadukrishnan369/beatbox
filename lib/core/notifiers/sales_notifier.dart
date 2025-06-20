// Step 1: sales_notifier.dart
import 'package:flutter/material.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';

ValueNotifier<List<SalesModel>> filteredSalesNotifier = ValueNotifier([]);
