import 'package:flutter/material.dart';
import 'package:beatbox/features/product_management/model/category_model.dart';

/// For category data update
ValueNotifier<List<CategoryModel>> categoryUpdatedNotifier = ValueNotifier([]);

/// To control shimmer visibility
ValueNotifier<bool> categoryShimmerNotifier = ValueNotifier(true);

/// Only show shimmer on app launch
ValueNotifier<bool> isFirstTimeCategory = ValueNotifier(true);
