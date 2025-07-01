import 'package:beatbox/features/product_management/controller/brand_controller.dart';
import 'package:beatbox/features/product_management/controller/category_controller.dart';

class NameValidators {
  static String? validateBrandName(
    String? value, {
    bool isEdit = false,
    String? oldName,
  }) {
    if (value == null || value.trim().isEmpty) {
      return 'Brand name is required';
    }

    final name = value.trim();
    final lowerName = name.toLowerCase();

    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(name);
    if (!hasLetter) {
      return 'Invalid brand name';
    }

    // Check for duplicates
    final allBrands = BrandController.getBrands();
    final exists = allBrands.any(
      (brand) =>
          brand.brandName.trim().toLowerCase() == lowerName &&
          (!isEdit || brand.brandName.trim() != oldName?.trim()),
    );

    if (exists) return 'Brand already exists in store';
    return null;
  }

  static String? validateCategoryName(
    String? value, {
    bool isEdit = false,
    String? oldName,
  }) {
    if (value == null || value.trim().isEmpty) {
      return 'Category name is required';
    }

    final name = value.trim();
    final lowerName = name.toLowerCase();

    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(name);
    if (!hasLetter) {
      return 'Invalid category name';
    }

    // Check for duplicates
    final allCategories = CategoryController.getAllCategory();
    final exists = allCategories.any(
      (cat) =>
          cat.categoryName.trim().toLowerCase() == lowerName &&
          (!isEdit || cat.categoryName.trim() != oldName?.trim()),
    );

    if (exists) return 'Category already exists in store';
    return null;
  }
}
