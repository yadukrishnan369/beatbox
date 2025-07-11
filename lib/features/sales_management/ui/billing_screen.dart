import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/sales_management/model/cart_item_model.dart';
import 'package:beatbox/features/sales_management/widgets/billing_summary_section.dart';
import 'package:beatbox/features/sales_management/widgets/customer_info_section.dart';
import 'package:beatbox/features/sales_management/widgets/invoice_info_section.dart';
import 'package:beatbox/features/sales_management/widgets/items_table_section.dart';
import 'package:beatbox/utils/billing_utils.dart';
import 'package:beatbox/utils/gst_utils.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final _formKey = GlobalKey<FormState>();

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
  late String orderNumber;
  late DateTime billingDate;
  final double gstRate = GSTUtils.getGSTPercentage() / 100;

  @override
  void initState() {
    super.initState();
    billingDate = DateTime.now();

    invoiceNumber =
        'INV-${billingDate.microsecondsSinceEpoch.toString().substring(7)}';
    orderNumber =
        'ORD-${(billingDate.millisecondsSinceEpoch % 100000).toString().padLeft(5, '0')}';

    discountController.addListener(() {
      discount = BillingUtils.calculateDiscount(
        discountController.text,
        subtotal,
        gst,
      );
      grandTotal = BillingUtils.calculateGrandTotal(subtotal, gst, discount);
      setState(() {});
    });
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
    subtotal = BillingUtils.calculateSubtotal(cartItems);
    gst = BillingUtils.calculateGst(subtotal, gstRate);
    grandTotal = BillingUtils.calculateGrandTotal(subtotal, gst, discount);
    setState(() {});
  }

  void _confirmBill() async {
    if (!_formKey.currentState!.validate()) return;

    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();

    await BillingUtils.confirmAndSaveBill(
      context,
      name: name,
      phone: phone,
      email: email,
      invoiceNumber: invoiceNumber,
      orderNumber: orderNumber,
      billingDate: billingDate,
      cartItems: cartItems,
      subtotal: subtotal,
      gst: gst,
      discount: discount,
      grandTotal: grandTotal,
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
    final bool isWeb = Responsive.isDesktop(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          title: Text(
            "Billing Invoice",
            style: TextStyle(
              fontSize: isWeb ? 8.sp : 22.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: isWeb ? constraints.maxWidth * 0.1 : 16.w,
                right: isWeb ? constraints.maxWidth * 0.1 : 16.w,
                top: 16.h,
                bottom: MediaQuery.of(context).viewInsets.bottom + 80.h,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomerInfoSection(
                          nameController: nameController,
                          phoneController: phoneController,
                          emailController: emailController,
                        ),
                        SizedBox(height: isWeb ? 16 : 24.h),
                        InvoiceInfoSection(
                          invoiceNumber: invoiceNumber,
                          billingDate: DateFormat(
                            'dd-MM-yyyy',
                          ).format(billingDate),
                          itemCount: cartItems.length,
                        ),
                        SizedBox(height: isWeb ? 16 : 24.h),
                        ItemsTableSection(cartItems: cartItems),
                        SizedBox(height: isWeb ? 16 : 24.h),
                        BillingSummarySection(
                          subtotal: subtotal,
                          gst: gst,
                          gstRate: gstRate,
                          discountController: discountController,
                          grandTotal: grandTotal,
                          onDiscountChanged: () {
                            discount = BillingUtils.calculateDiscount(
                              discountController.text,
                              subtotal,
                              gst,
                            );
                            grandTotal = BillingUtils.calculateGrandTotal(
                              subtotal,
                              gst,
                              discount,
                            );
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            left: isWeb ? MediaQuery.of(context).size.width * 0.4 : 16.w,
            right: isWeb ? MediaQuery.of(context).size.width * 0.4 : 16.w,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              padding: EdgeInsets.symmetric(vertical: isWeb ? 20 : 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: _confirmBill,
            child: Text(
              'CONFIRM BILL',
              style: TextStyle(
                fontSize: isWeb ? 18 : 18.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
