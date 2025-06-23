import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:flutter/material.dart';

// notify for when product list changes
ValueNotifier<List<ProductModel>> productAddNotifier = ValueNotifier([]);
// shimmer status
ValueNotifier<bool> productShimmerNotifier = ValueNotifier(true);
ValueNotifier<bool> isProductReloadNeeded = ValueNotifier(true);
