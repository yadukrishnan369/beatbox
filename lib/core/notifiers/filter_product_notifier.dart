import 'package:flutter/material.dart';
import 'package:beatbox/features/stock_manage/model/product_model.dart';

// notify for when search and filter in product lists
ValueNotifier<List<ProductModel>> filteredProductNotifier = ValueNotifier([]);
