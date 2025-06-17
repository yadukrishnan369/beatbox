import 'package:beatbox/utils/gst_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/sales_management/model/cart_item_model.dart';
import 'package:beatbox/features/sales_management/widgets/customer_info_section.dart';
import 'package:beatbox/features/sales_management/widgets/invoice_info_section.dart';
import 'package:beatbox/features/sales_management/widgets/items_table_section.dart';
import 'package:beatbox/features/sales_management/widgets/billing_summary_section.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  // Data
  List<CartItemModel> cartItems = [];
  double subtotal = 0.0;
  double gst = 0.0;
  double discount = 0.0;
  double grandTotal = 0.0;
  late String invoiceNumber;
  late String billingDate;
  final double gstRate = GSTUtils.getGSTRate() / 100;

  @override
  void initState() {
    super.initState();
    invoiceNumber =
        'INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    billingDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
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

    try {
      //bill confirmation logic
      await Future.delayed(Duration(seconds: 1));
      _showSnackBar("Bill confirmed successfully!", isError: false);
      Future.delayed(Duration(seconds: 2), () => Navigator.pop(context));
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
              billingDate: billingDate,
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
