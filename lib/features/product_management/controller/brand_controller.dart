import 'package:hive/hive.dart';
import '../model/brand_model.dart';

class BrandController {
  static const String _boxName = 'brandBox'; //store box name in a variable

  // open brandModel box
  static Future<void> initBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<BrandModel>(_boxName);
    }
  }

  // add brand
  static Future<void> addBrand(BrandModel brand) async {
    final box = Hive.box<BrandModel>(_boxName);
    for (var brand in box.values) {
      print('Category Name: ${brand.brandName}');
      print('Image Path: ${brand.brandImagePath}');
    }
    await box.add(brand);
  }

  // get all brands
  static List<BrandModel> getBrands() {
    final box = Hive.box<BrandModel>(_boxName);
    return box.values.toList();
  }
}
