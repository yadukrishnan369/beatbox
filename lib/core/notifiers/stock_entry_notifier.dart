import 'package:flutter/material.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';

ValueNotifier<List<ProductModel>> stockEntryNotifier = ValueNotifier([]);

ValueNotifier<bool> isStockEntryLoadingNotifier = ValueNotifier(true);
ValueNotifier<bool> isStockEntryReloadNeeded = ValueNotifier(true);
