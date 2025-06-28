import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:hive/hive.dart';

class ProductToggleUtils {
  static Future<bool> toggleSaleStatus(ProductModel product) async {
    final box = await Hive.openBox<ProductModel>('productBox');

    final updatedProduct = ProductModel(
      id: product.id,
      productName: product.productName,
      productCategory: product.productCategory,
      productBrand: product.productBrand,
      productQuantity: product.productQuantity,
      initialQuantity: product.initialQuantity,
      productCode: product.productCode,
      purchaseRate: product.purchaseRate,
      salePrice: product.salePrice,
      description: product.description,
      image1: product.image1,
      image2: product.image2,
      image3: product.image3,
      createdDate: product.createdDate,
      isAvailableForSale: !product.isAvailableForSale,
    );

    await box.put(product.id, updatedProduct);
    return !product.isAvailableForSale; // returning updated status
  }
}
