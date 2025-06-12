import 'package:hive_flutter/hive_flutter.dart';
import 'package:beatbox/features/stock_manage/model/category_model.dart';

class CategoryController {
  //get all categories
  static List<CategoryModel> getAllCategory() {
    final box = Hive.box<CategoryModel>('categoryBox');
    return box.values.toList();
  }
}
