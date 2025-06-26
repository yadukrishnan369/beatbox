import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/bill_management/widgets/bill_header_section.dart';
import 'package:beatbox/features/bill_management/widgets/bill_table_section.dart';
import 'package:beatbox/features/bill_management/widgets/bill_total_section.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:beatbox/utils/pdf_invoice_generator.dart';
import 'package:beatbox/widgets/Loading_widgets/show_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillDetailsScreen extends StatelessWidget {
  const BillDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bill = ModalRoute.of(context)!.settings.arguments as SalesModel;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Bill Details',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(16.w),
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppColors.contColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BillHeaderSection(bill: bill),
                    SizedBox(height: 20.h),
                    BillTableSection(bill: bill),
                    SizedBox(height: 20.h),
                    BillTotalSection(bill: bill),
                    SizedBox(height: 20.h),
                    Text(
                      'Note: Thank you for choosing us!',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 18.w,
            bottom: 18.w,
            left: 45.w,
            right: 45.w,
          ),
          child: ElevatedButton.icon(
            onPressed: () async {
              // loading dialog
              showLoadingDialog(context, message: 'Generating bill');
              await Future.delayed(Duration(seconds: 2));
              await generateInvoicePdf(bill);
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.download, color: AppColors.white, size: 20.sp),
            label: Text(
              'Save & Share Invoice',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 14.h),
            ),
          ),
        ),
      ),
    );
  }
}
