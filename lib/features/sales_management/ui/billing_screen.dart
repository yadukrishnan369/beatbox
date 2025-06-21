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
    discount = double.tryParse(discountController.text) ?? 0.0;
    if (discount > subtotal + gst) {
      discount = subtotal + gst;
      discountController.text = discount.toStringAsFixed(2);
    }
    _calculateTotals();
  }

  void _confirmBill() async {
    if (nameController.text.trim().isEmpty) {
      _showSnackBar("Please enter customer name!", isError: true);
      return;
    } else if (phoneController.text.trim().isEmpty) {
      _showSnackBar("Please enter customer phone!", isError: true);
      return;
    }

    final sale = SalesModel(
      customerName: nameController.text.trim(),
      customerPhone: phoneController.text.trim(),
      customerEmail: emailController.text.trim(),
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

      //  update stock for each product
      final productBox = Hive.box<ProductModel>('productBox');
      for (var item in cartItems) {
        final id = item.product.id;
        final existingProduct = productBox.values.firstWhere(
          (p) => p.id == id,
          orElse: () => item.product,
        );

        // Prevent negative stock
        final newQty = existingProduct.productQuantity - item.quantity;
        existingProduct.productQuantity = newQty < 0 ? 0 : newQty;

        await existingProduct.save();
      }

      // clear cart
      await CartController.clearCart();

      // show loading and success
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
