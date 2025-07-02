import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/bill_notifier.dart';
import 'package:beatbox/core/notifiers/sales_notifier.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/features/sales_management/controller/cart_controller.dart';
import 'package:beatbox/features/sales_management/controller/sales_controller.dart';
import 'package:beatbox/features/sales_management/model/cart_item_model.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/widgets/Loading_widgets/show_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class BillingUtils {
  //  billing calculations
  static double calculateSubtotal(List<CartItemModel> cartItems) {
    return cartItems.fold(
      0.0,
      (sum, item) => sum + (item.product.salePrice * item.quantity),
    );
  }

  static double calculateGst(double subtotal, double gstRate) {
    return subtotal * gstRate;
  }

  static double calculateDiscount(
    String discountText,
    double subtotal,
    double gst,
  ) {
    final enteredPercentage = double.tryParse(discountText.trim()) ?? 0.0;
    return ((subtotal + gst) * enteredPercentage) / 100;
  }

  static double calculateGrandTotal(
    double subtotal,
    double gst,
    double discount,
  ) {
    return subtotal + gst - discount;
  }

  //  TextFormField Validators
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Name is required";
    }
    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return "Enter a valid name";
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone number is required";
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return "Enter a valid 10-digit phone";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value != null &&
        value.isNotEmpty &&
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
      return "Enter valid email";
    }
    return null;
  }

  static String? validateDiscount(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final val = double.tryParse(value.trim());
    if (val == null || val < 0 || val >= 100) {
      return "invalid discount";
    }
    return null;
  }

  static Future<List<Map<String, String>>> getPreviousCustomerDetails() async {
    final box = await Hive.openBox<SalesModel>('salesBox');
    final List<Map<String, String>> customers = [];

    for (var sale in box.values) {
      customers.add({
        'name': sale.customerName,
        'phone': sale.customerPhone,
        'email': sale.customerEmail,
      });
    }

    // Remove duplicates by name
    final seen = <String>{};
    return customers.where((c) => seen.add(c['name']!)).toList();
  }

  //  Confirm & Save Bill
  static Future<void> confirmAndSaveBill(
    BuildContext context, {
    required String name,
    required String phone,
    required String email,
    required String invoiceNumber,
    required DateTime billingDate,
    required List<CartItemModel> cartItems,
    required double subtotal,
    required double gst,
    required double discount,
    required double grandTotal,
    required String orderNumber,
  }) async {
    final sale = SalesModel(
      customerName: name,
      customerPhone: phone,
      customerEmail: email,
      invoiceNumber: invoiceNumber,
      billingDate: billingDate,
      cartItems: cartItems,
      subtotal: subtotal,
      gst: gst,
      discount: discount,
      grandTotal: grandTotal,
      orderNumber: orderNumber,
    );

    try {
      await SalesController.addSale(sale);
      isSalesReloadNeeded.value = true;
      isBillReloadNeeded.value = true;

      final productBox = Hive.box<ProductModel>('productBox');
      for (var item in cartItems) {
        final product = productBox.values.firstWhere(
          (p) => p.id == item.product.id,
        );
        final newQty = product.productQuantity - item.quantity;
        product.productQuantity = newQty < 0 ? 0 : newQty;
        await product.save();
      }

      await CartController.clearCart();
      await showLoadingDialog(
        context,
        message: 'Saving Bill...',
        showSucess: true,
      );
      await Future.delayed(const Duration(milliseconds: 800));
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.billHistory);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
