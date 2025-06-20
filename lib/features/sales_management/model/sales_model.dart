import 'package:hive/hive.dart';
import 'package:beatbox/features/sales_management/model/cart_item_model.dart';

part 'sales_model.g.dart';

@HiveType(typeId: 4)
class SalesModel extends HiveObject {
  @HiveField(0)
  final String customerName;

  @HiveField(1)
  final String customerPhone;

  @HiveField(2)
  final String customerEmail;

  @HiveField(3)
  final String invoiceNumber;

  @HiveField(4)
  final DateTime billingDate;

  @HiveField(5)
  final List<CartItemModel> cartItems;

  @HiveField(6)
  final double subtotal;

  @HiveField(7)
  final double gst;

  @HiveField(8)
  final double discount;

  @HiveField(9)
  final double grandTotal;  

  SalesModel({
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.invoiceNumber,
    required this.billingDate,
    required this.cartItems,
    required this.subtotal,
    required this.gst,
    required this.discount,
    required this.grandTotal,
  });
}
