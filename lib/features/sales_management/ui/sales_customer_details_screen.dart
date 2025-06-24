import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/sales_management/widgets/sale_customer_detail_card_widget.dart';
import 'package:beatbox/features/sales_management/widgets/sale_invoice_card_widget.dart';
import 'package:beatbox/features/sales_management/widgets/sale_item_list_widget.dart';
import 'package:beatbox/features/sales_management/widgets/sale_summary_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';

class SalesAndCustomerDetailsScreen extends StatelessWidget {
  const SalesAndCustomerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sale = ModalRoute.of(context)!.settings.arguments as SalesModel;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Sales details',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Invoice Card
              InvoiceCardWidget(sale: sale),
              SizedBox(height: 20.h),
              // Customer Details
              CustomerDetailCard(sale: sale),
              SizedBox(height: 20.h),
              // Sale bill Summary
              SaleSummaryCard(sale: sale),
              SizedBox(height: 20.h),
              //Sold item Details
              SaleItemListWidget(sale: sale),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'View Invoice',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
