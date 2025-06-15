import 'package:hive/hive.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 3)
class CartItemModel extends HiveObject {
  @HiveField(0)
  final ProductModel product;

  @HiveField(1)
  int quantity;

  CartItemModel({required this.product, required this.quantity});

  double get totalPrice => product.salePrice * quantity;
}
