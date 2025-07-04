import 'dart:io';
import 'package:beatbox/core/notifiers/product_edit_delete_notifier.dart';
import 'package:beatbox/core/notifiers/stock_entry_notifier.dart';
import 'package:beatbox/utils/new_arrival_utils.dart';
import 'package:beatbox/utils/stock_entry_utils.dart';
import 'package:flutter/material.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/features/product_management/controller/product_controller.dart';
import 'package:beatbox/core/notifiers/product_add_notifier.dart';
import 'package:beatbox/utils/product_utils.dart';
import 'package:beatbox/widgets/Loading_widgets/show_loading_dialog.dart';

class ProductValidators {
  static String? validateName(
    String? value, {
    bool isEdit = false,
    String? oldName,
  }) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) return 'Enter valid name';

    final trimmedValue = value.trim().toLowerCase();

    // if editing and the name not changed, skip duplicate check
    if (isEdit && trimmedValue == oldName?.toLowerCase()) return null;

    // Check for duplicates
    final existing = ProductController.getAllProducts().any(
      (product) => product.productName.trim().toLowerCase() == trimmedValue,
    );

    if (existing) return 'This product already exists in the store.';
    return null;
  }

  static String? validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    final qty = int.tryParse(value);
    if (qty == null || qty <= 0) return 'Invalid quantity';
    return null;
  }

  static String? validateCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    final input = value.trim();
    final hasLetters = RegExp(r'[a-zA-Z]').hasMatch(input);
    final hasNumbers = RegExp(r'\d').hasMatch(input);

    if (!(hasLetters && hasNumbers)) {
      return 'Invalid code';
    }
    return null;
  }

  static String? validatePurchasePrice(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    final price = double.tryParse(value);
    if (price == null || price <= 0) return 'Invalid purchase price';
    return null;
  }

  static String? validateSalePrice(String? value, String purchasePriceText) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    final sales = double.tryParse(value);
    final purchase = double.tryParse(purchasePriceText);
    if (sales == null) return 'Invalid sales price';
    if (purchase != null && sales <= purchase) {
      return 'Must be greater than purchase price';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    return null;
  }
}

class AddEditProductUtils {
  static Future<bool?> showConfirmationDialog(
    BuildContext context,
    String action,
  ) async {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Confirm $action',
              style: TextStyle(color: AppColors.primary),
            ),
            content: Text(
              'Are you sure you want to $action this product?',
              style: TextStyle(color: AppColors.textPrimary),
            ),

            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel', style: TextStyle(color: AppColors.error)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(action, style: TextStyle(color: AppColors.success)),
              ),
            ],
          ),
    );
  }

  static void showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.success),
    );
  }

  static void resetForm({
    required TextEditingController nameController,
    required TextEditingController quantityController,
    required TextEditingController codeController,
    required TextEditingController purchaseRateController,
    required TextEditingController salePriceController,
    required TextEditingController descriptionController,
    required void Function(
      File? image1,
      File? image2,
      File? image3,
      String? category,
      String? brand,
    )
    updateState,
  }) {
    nameController.clear();
    quantityController.clear();
    codeController.clear();
    purchaseRateController.clear();
    salePriceController.clear();
    descriptionController.clear();
    updateState(null, null, null, null, null);
  }

  static Future<void> processProductUpdate(
    BuildContext context,
    ProductModel product,
  ) async {
    await showLoadingDialog(context, message: "Updating...", showSucess: true);
    await ProductController.updateProduct(product);
    isProductReloadNeeded.value = true;
    await ProductUtils.loadProducts();
    await NewArrivalUtils.loadNewArrivalProducts();
    isStockEntryReloadNeeded.value = true;
    await StockEntryUtils.loadAllProducts();
    isEditProductReloadNeeded.value = true;
    showSuccessMessage(context, 'Product updated successfully');
    if (context.mounted) Navigator.pop(context);
  }

  static Future<void> processProductAdd(
    BuildContext context,
    ProductModel product,
  ) async {
    await showLoadingDialog(context, message: "Adding...", showSucess: true);
    await ProductController.addProduct(product);
    isProductReloadNeeded.value = true;
    await ProductUtils.loadProducts();
    await NewArrivalUtils.loadNewArrivalProducts();
    isStockEntryReloadNeeded.value = true;
    await StockEntryUtils.loadAllProducts();
    isEditProductReloadNeeded.value = true;
    showSuccessMessage(context, 'Product added successfully');
    if (context.mounted) Navigator.pop(context);
  }
}
