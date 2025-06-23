import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:flutter/material.dart';

ValueNotifier<List<ProductModel>> newArrivalNotifier = ValueNotifier([]);
ValueNotifier<bool> newArrivalShimmerNotifier = ValueNotifier(true);
ValueNotifier<bool> isFirstTimeNewArrival = ValueNotifier(true);
