import 'package:beatbox/features/stock_manage/model/product_model.dart';
import 'package:hive/hive.dart';
import 'package:beatbox/core/notifiers/product_add_notifier.dart';

class ProductController {
  static late Box<ProductModel> _productBox;

  // open product box
  static Future<void> initBox() async {
    _productBox = await Hive.openBox<ProductModel>('productBox');
    _refreshNotifier(); // initial load
  }

  // add product
  static Future<void> addProduct(ProductModel product) async {
    await _productBox.put(product.id, product);
    _refreshNotifier(); // update UI
  }

  // update product
  static Future<void> updateProduct(ProductModel product) async {
    await _productBox.put(product.id, product);
    _refreshNotifier();
  }

  // get all product
  static List<ProductModel> getAllProducts() {
    return _productBox.values.toList();
  }

  // delete product
  static Future<void> deleteProductByKey(dynamic key) async {
    await _productBox.delete(key);
    _refreshNotifier();
  }

  // refresh product notifier
  static void _refreshNotifier() {
    final products = _productBox.values.toList().reversed.toList();
    productAddNotifier.value = products;
  }
}
