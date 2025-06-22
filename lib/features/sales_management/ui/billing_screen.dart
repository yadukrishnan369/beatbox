import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/features/sales_management/controller/cart_controller.dart';
import 'package:beatbox/features/sales_management/controller/sales_controller.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:beatbox/utils/gst_utils.dart';
import 'package:beatbox/widgets/show_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/sales_management/model/cart_item_model.dart';
import 'package:beatbox/features/sales_management/widgets/customer_info_section.dart';
import 'package:beatbox/features/sales_management/widgets/invoice_info_section.dart';
import 'package:beatbox/features/sales_management/widgets/items_table_section.dart';
import 'package:beatbox/features/sales_management/widgets/billing_summary_section.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  List<CartItemModel> cartItems = [];
  double subtotal = 0.0;
  double gst = 0.0;
  double discount = 0.0;
  double grandTotal = 0.0;
  late String invoiceNumber;
  late DateTime billingDate;
  final double gstRate = GSTUtils.getGSTRate() / 100;

  @override
  void initState() {
    super.initState();
    invoiceNumber =
        'INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    billingDate = DateTime.now();
    discountController.addListener(_updateDiscount);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is List<CartItemModel> && args.isNotEmpty) {
      cartItems = args;
      _calculateTotals();
    }
  }

  void _calculateTotals() {
    subtotal = cartItems.fold(
      0,
      (sum, item) => sum + (item.product.salePrice * item.quantity),
    );
    gst = subtotal * gstRate;
    grandTotal = subtotal + gst - discount;
    if (mounted) setState(() {});
  }

  void _updateDiscount() {
    final enteredPercentage =
        double.tryParse(discountController.text.trim()) ?? 0.0;
    if (discountController.text.trim().isEmpty) {
      discount = 0.0;
      _calculateTotals();
      return;
    }
    // Calculate percentage-based discount
    discount = ((subtotal + gst) * enteredPercentage) / 100;
    _calculateTotals();
  }

  void _confirmBill() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final discountText = discountController.text.trim();

    //  Name validation
    if (name.isEmpty) {
      _showSnackBar("Enter customer name!", isError: true);
      return;
    }
    if (!RegExp(r'[a-zA-Z]').hasMatch(name)) {
      _showSnackBar("Invalid name", isError: true);
      return;
    }

    //  Phone validation
    if (phone.isEmpty) {
      _showSnackBar("Enter phone number!", isError: true);
      return;
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      _showSnackBar("Invalid phone number", isError: true);
      return;
    }

    //  Email Format validation
    if (email.isNotEmpty &&
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(email)) {
      _showSnackBar("Invalid email", isError: true);
      return;
    }

    //  Discount validation
    if (discountText.isNotEmpty) {
      final enteredDisc = double.tryParse(discountText.trim());

      if (enteredDisc == null) {
        _showSnackBar("Invalid discount", isError: true);
        return;
      }

      if (enteredDisc >= 100) {
        _showSnackBar("Discount can't be 100% or more", isError: true);
        return;
      }
    }

    /// save to DB after all validations
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
      // save to sales
      await SalesController.addSale(sale);

      // update stock
      final productBox = Hive.box<ProductModel>('productBox');
      for (var item in cartItems) {
        final id = item.product.id;

        final matchingList =
            productBox.values.where((p) => p.id == id).toList();

        if (matchingList.isNotEmpty) {
          final product = matchingList.first;

          // Reduce quantity
          final newQty = product.productQuantity - item.quantity;
          product.productQuantity = newQty < 0 ? 0 : newQty;

          // Save updated product
          await product.save();
        }
      }

      await CartController.clearCart();

      await showLoadingDialog(
        context,
        message: 'Saving Bill...',
        showSucess: true,
      );

      await Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) Navigator.pop(context);
      });
    } catch (e) {
      _showSnackBar("Error: ${e.toString()}", isError: true);
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          "Billing Invoice",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            CustomerInfoSection(
              nameController: nameController,
              phoneController: phoneController,
              emailController: emailController,
            ),
            SizedBox(height: 24.h),
            InvoiceInfoSection(
              invoiceNumber: invoiceNumber,
              billingDate: DateFormat('dd-MM-yyyy').format(billingDate),
              itemCount: cartItems.length,
            ),
            SizedBox(height: 24.h),
            ItemsTableSection(cartItems: cartItems),
            SizedBox(height: 24.h),
            BillingSummarySection(
              subtotal: subtotal,
              gst: gst,
              gstRate: gstRate,
              discountController: discountController,
              grandTotal: grandTotal,
              onDiscountChanged: _updateDiscount,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: _confirmBill,
            child: Text(
              'CONFIRM BILL',
              style: TextStyle(fontSize: 18.sp, color: AppColors.white),
            ),
          ),
        ),
      ),
    );
  }
}
