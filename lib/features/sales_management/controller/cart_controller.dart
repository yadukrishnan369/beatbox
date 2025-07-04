import 'package:beatbox/core/notifiers/cart_update_notifier.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:hive/hive.dart';
import '../model/cart_item_model.dart';

class CartController {
  static const String _boxName = 'cartBox';

  static Future<void> initBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<CartItemModel>(_boxName);
    }
    _refreshNotifier();
  }

  static Future<void> addToCart(CartItemModel item) async {
    final box = Hive.box<CartItemModel>(_boxName);

    final existingIndex = box.values.toList().indexWhere(
      (e) => e.product.id == item.product.id,
    );

    if (existingIndex != -1) {
      final existingItem = box.getAt(existingIndex);
      existingItem!.quantity += item.quantity;
      await existingItem.save();
    } else {
      await box.add(item);
    }
    _refreshNotifier();
  }

  static List<CartItemModel> getCartItems() {
    final box = Hive.box<CartItemModel>(_boxName);
    return box.values.toList();
  }

  static Future<void> removeItem(int index) async {
    final box = Hive.box<CartItemModel>(_boxName);
    await box.deleteAt(index);
    _refreshNotifier();
  }

  static Future<void> updateQuantity(ProductModel product, int newQty) async {
    final box = Hive.box<CartItemModel>(_boxName);

    final cartItems = box.values.toList();

    for (int i = 0; i < cartItems.length; i++) {
      if (cartItems[i].product.id == product.id) {
        final updatedItem = cartItems[i];
        updatedItem.quantity = newQty;
        await updatedItem.save();
        break;
      }
    }
    _refreshNotifier();
  }

  static Future<void> clearCart() async {
    final box = Hive.box<CartItemModel>(_boxName);
    await box.clear();
    _refreshNotifier();
  }

  // check if product exist in cart
  static bool isProductInCart(String productId) {
    final box = Hive.box<CartItemModel>(_boxName);
    return box.values.any((item) => item.product.id == productId);
  }

  ///  Notify all listeners
  static void _refreshNotifier() {
    final box = Hive.box<CartItemModel>(_boxName);
    cartUpdatedNotifier.value = box.values.toList();
  }
}
