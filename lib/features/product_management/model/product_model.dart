import 'dart:typed_data';
import 'package:hive/hive.dart';
part 'product_model.g.dart';

@HiveType(typeId: 2)
class ProductModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final String productCategory;

  @HiveField(3)
  final String productBrand;

  @HiveField(4)
  int productQuantity;

  @HiveField(5)
  final String productCode;

  @HiveField(6)
  final double purchaseRate;

  @HiveField(7)
  final double salePrice;

  @HiveField(8)
  final String description;

  @HiveField(9)
  final String? image1;
  @HiveField(10)
  final String? image2;

  @HiveField(11)
  final String? image3;

  @HiveField(12)
  final DateTime createdDate;

  @HiveField(13)
  int? initialQuantity;

  @HiveField(14)
  bool isAvailableForSale;

  @HiveField(15)
  final String? webImage1;

  @HiveField(16)
  final String? webImage2;

  @HiveField(17)
  final String? webImage3;

  final Uint8List? imageBytes;

  ProductModel({
    required this.id,
    required this.productName,
    required this.productCategory,
    required this.productBrand,
    required this.productQuantity,
    required this.initialQuantity,
    required this.productCode,
    required this.purchaseRate,
    required this.salePrice,
    required this.description,
    this.image1,
    this.image2,
    this.image3,
    required this.createdDate,
    this.isAvailableForSale = true,
    this.webImage1,
    this.webImage2,
    this.webImage3,
    this.imageBytes,
  });
}
