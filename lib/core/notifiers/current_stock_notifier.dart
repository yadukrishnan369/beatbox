import 'package:flutter/material.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';

// This is current stock screen notifier
ValueNotifier<List<ProductModel>> currentStockNotifier = ValueNotifier([]);

// shimmer loader for current stock
ValueNotifier<bool> currentStockShimmerNotifier = ValueNotifier(false);
