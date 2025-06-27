import 'package:flutter/material.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';

// This is limited stock screen notifier
ValueNotifier<List<ProductModel>> limitedStockNotifier = ValueNotifier([]);

// shimmer loader for limited stock
ValueNotifier<bool> limitedStockShimmerNotifier = ValueNotifier(false);
