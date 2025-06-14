import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 1)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String categoryName;

  @HiveField(2)
  final String categoryImagePath;

  CategoryModel({
    required this.id,
    required this.categoryName,
    required this.categoryImagePath,
  });
}
