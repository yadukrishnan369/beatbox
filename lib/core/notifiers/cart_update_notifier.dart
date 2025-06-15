import 'package:beatbox/features/sales_management/model/cart_item_model.dart';
import 'package:flutter/material.dart';

/// Global notifier for updating cart items across app
ValueNotifier<List<CartItemModel>> cartUpdatedNotifier = ValueNotifier([]);
