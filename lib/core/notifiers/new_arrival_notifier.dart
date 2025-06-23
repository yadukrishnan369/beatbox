import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:flutter/material.dart';

/// For new data update
ValueNotifier<List<ProductModel>> newArrivalNotifier = ValueNotifier([]);

/// To control shimmer visibility
ValueNotifier<bool> newArrivalShimmerNotifier = ValueNotifier(true);

/// Only show shimmer on app launch
ValueNotifier<bool> isFirstTimeNewArrival = ValueNotifier(true);
