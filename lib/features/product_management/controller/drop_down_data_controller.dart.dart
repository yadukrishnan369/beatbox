import 'package:beatbox/features/product_management/model/brand_model.dart';
import 'package:beatbox/features/product_management/model/category_model.dart';
import 'package:hive/hive.dart';

class CategoryController {
  //get all category data
  Future<List<String>> getAllCategory() async {
    final box = await Hive.openBox<CategoryModel>('categoryBox');
    return box.values.map((e) => e.categoryName).toList();
  }
}

//get all brand data
class BrandController {
  Future<List<String>> getAllBrands() async {
    final box = await Hive.openBox<BrandModel>('brandBox');
    return box.values.map((e) => e.brandName).toList();
  }
}
