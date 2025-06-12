import 'package:beatbox/core/notifiers/category_update_notifiers.dart';
import 'package:hive/hive.dart';
import '../model/category_model.dart';

class CategoryController {
  static const String _boxName = 'categoryBox'; //store box name in a variable

  // open category box
  static Future<void> initBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<CategoryModel>(_boxName);
    }
    _refreshNotifier(); // initial load
  }

  // add categories
  static Future<void> addCategory(CategoryModel category) async {
    final box = Hive.box<CategoryModel>(_boxName);
    await box.add(category);
    _refreshNotifier(); // notifier update
  }

  // get all category
  static List<CategoryModel> getAllCategory() {
    final box = Hive.box<CategoryModel>(_boxName);
    return box.values.toList();
  }

  // notifier update method
  static void _refreshNotifier() {
    final box = Hive.box<CategoryModel>(_boxName);
    final data = box.values.toList().reversed.toList();
    categoryUpdatedNotifier.value = data;
  }
}
