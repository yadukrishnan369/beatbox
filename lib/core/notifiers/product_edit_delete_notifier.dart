import 'package:flutter/material.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';

ValueNotifier<List<ProductModel>> allEditProductNotifier = ValueNotifier([]);
ValueNotifier<List<ProductModel>> filteredEditProductNotifier = ValueNotifier(
  [],
);
ValueNotifier<bool> editProductShimmerNotifier = ValueNotifier(true);
ValueNotifier<bool> isEditProductReloadNeeded = ValueNotifier(true);
