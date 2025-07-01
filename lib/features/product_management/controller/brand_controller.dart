import 'package:beatbox/core/notifiers/brand_update_notifier.dart';
import 'package:hive/hive.dart';
import '../model/brand_model.dart';

class BrandController {
  static const String _boxName = 'brandBox'; //store box name in a variable

  // open category box
  static Future<void> initBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<BrandModel>(_boxName);
    }
    _refreshNotifier(); //  Initial load
  }

  // add brands
  static Future<void> addBrand(BrandModel brand) async {
    final box = Hive.box<BrandModel>(_boxName);
    await box.add(brand);
    _refreshNotifier(); // // notifier update
  }

  // Get all brands
  static List<BrandModel> getBrands() {
    final box = Hive.box<BrandModel>(_boxName);
    return box.values.toList().reversed.toList();
  }

  // notifier update method
  static void _refreshNotifier() {
    final box = Hive.box<BrandModel>(_boxName);
    final data = box.values.toList().reversed.toList();
    brandUpdatedNotifier.value = data;
  }
}
