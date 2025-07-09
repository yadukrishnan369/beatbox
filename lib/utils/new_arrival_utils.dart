import 'package:beatbox/core/notifiers/new_arrival_notifier.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class NewArrivalUtils {
  static Future<void> loadNewArrivalProducts() async {
    final box = await Hive.openBox<ProductModel>('productBox');
    final allProducts = box.values.toList();

    final newArrivals =
        allProducts
            .where(
              (product) =>
                  product.isAvailableForSale &&
                  (kIsWeb
                      ? product.webImage1 != null &&
                          product.webImage1!.trim().isNotEmpty
                      : product.image1 != null &&
                          product.image1!.trim().isNotEmpty),
            )
            .toList()
          ..sort((a, b) => b.createdDate.compareTo(a.createdDate));

    // take 3 latest products for showing
    newArrivalNotifier.value = newArrivals.take(3).toList();
  }
}
