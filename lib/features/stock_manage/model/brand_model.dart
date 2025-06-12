import 'package:hive/hive.dart';

part 'brand_model.g.dart';

@HiveType(typeId: 0)
class BrandModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String brandName;

  @HiveField(2)
  final String brandImagePath;

  BrandModel({
    required this.id,
    required this.brandName,
    required this.brandImagePath,
  });
}
