// billing_utils.dart
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

  static bool validateCustomerDetails(
    BuildContext context, {
    required String name,
    required String phone,
    required String email,
    required String discountText,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    if (name.isEmpty || !RegExp(r'[a-zA-Z]').hasMatch(name)) {
      messenger.showSnackBar(
        SnackBar(
          content: Text("Enter a valid name"),
          backgroundColor: AppColors.error,
        ),
      );
      return false;
    }
    if (phone.isEmpty || !RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      messenger.showSnackBar(
        SnackBar(
          content: Text("Enter a valid phone number"),
          backgroundColor: AppColors.error,
        ),
      );
      return false;
    }

    if (email.isNotEmpty &&
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(email)) {
      messenger.showSnackBar(
        SnackBar(
          content: Text("Invalid email"),
          backgroundColor: AppColors.error,
        ),
      );
      return false;
    }

    final enteredDisc = double.tryParse(discountText);
    if (discountText.isNotEmpty &&
        (enteredDisc == null || enteredDisc >= 100)) {
      messenger.showSnackBar(
        SnackBar(
          content: Text("Invalid discount"),
          backgroundColor: AppColors.error,
        ),
      );
      return false;
    }
    return true;
  }

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
          content: Text("Error: \${e.toString()}"),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
