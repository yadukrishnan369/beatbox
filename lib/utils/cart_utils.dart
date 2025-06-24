import 'package:beatbox/core/notifiers/cart_update_notifier.dart';
import 'package:beatbox/features/sales_management/controller/cart_controller.dart';
import 'package:beatbox/features/sales_management/model/cart_item_model.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';

class CartUtils {
  //add products to cart
  static Future<void> addProductToCart(
    ProductModel product, {
    int quantity = 1,
  }) async {
    final currentCart = [...cartUpdatedNotifier.value];

    final index = currentCart.indexWhere(
      (item) => item.product.productCode == product.productCode,
    );

    if (index != -1) {
      final existing = currentCart[index];
      final updatedItem = CartItemModel(
        product: existing.product,
        quantity: existing.quantity + quantity,
      );

      currentCart[index] = updatedItem;
    } else {
      currentCart.add(CartItemModel(product: product, quantity: quantity));
    }

    cartUpdatedNotifier.value = [...currentCart];

    await CartController.addToCart(
      CartItemModel(product: product, quantity: quantity),
    );
  }

  static Future<void> removeProductFromCart(ProductModel product) async {
    final currentCart = [...cartUpdatedNotifier.value];
    final index = currentCart.indexWhere(
      (item) => item.product.productCode == product.productCode,
    );

    if (index != -1) {
      currentCart.removeAt(index);
      await CartController.removeItem(index);
    }

    cartUpdatedNotifier.value = currentCart;
  }

  static Future<void> clearEntireCart() async {
    await CartController.clearCart();
    cartUpdatedNotifier.value = [];
  }

  static Future<void> changeQuantity(ProductModel product, int newQty) async {
    final currentCart = [...cartUpdatedNotifier.value];

    final index = currentCart.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index != -1) {
      currentCart[index].quantity = newQty;
      cartUpdatedNotifier.value = currentCart;

      await CartController.updateQuantity(product, newQty);
    }
  }

  static double getTotalCartPrice() {
    return cartUpdatedNotifier.value.fold(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );
  }

  static int getTotalCartQuantity() {
    return cartUpdatedNotifier.value.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
  }
}
