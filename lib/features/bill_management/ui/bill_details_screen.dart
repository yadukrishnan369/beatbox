import 'dart:math';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/bill_management/widgets/bill_header_section.dart';
import 'package:beatbox/features/bill_management/widgets/bill_table_section.dart';
import 'package:beatbox/features/bill_management/widgets/bill_total_section.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:beatbox/utils/bill_utils.dart';
import 'package:beatbox/utils/pdf_invoice_generator.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:beatbox/widgets/Loading_widgets/show_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillDetailsScreen extends StatelessWidget {
  const BillDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bill = ModalRoute.of(context)!.settings.arguments as SalesModel;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb =
            Responsive.isDesktop(context) || constraints.maxWidth > 600;
        final double screenWidth = constraints.maxWidth;
        final double bottomInset =
            isWeb ? max((screenWidth - 400.w) / 2, 0) : 45.w;

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            title: Text(
              'Bill Details',
              style: TextStyle(
                fontSize: isWeb ? 8.sp : 22.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            actions: [
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: AppColors.textPrimary,
                  size: isWeb ? 8.sp : 24.sp,
                ),
                onSelected: (value) {
                  if (value == 'delete') {
                    BillUtils.confirmAndDeleteBill(context, bill);
                  }
                },
                itemBuilder:
                    (_) => [
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: AppColors.error,
                              size: isWeb ? 6.sp : 20.sp,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'Delete',
                              style: TextStyle(fontSize: isWeb ? 5.sp : 14.sp),
                            ),
                          ],
                        ),
                      ),
                    ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                width: isWeb ? 700 : double.infinity,
                margin: EdgeInsets.symmetric(
                  vertical: isWeb ? 12.h : 16.h,
                  horizontal: isWeb ? 12.w : 16.w,
                ),
                padding: EdgeInsets.all(isWeb ? 16.w : 20.w),
                decoration: BoxDecoration(
                  color: AppColors.contColor,
                  borderRadius: BorderRadius.circular(isWeb ? 8.r : 12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BillHeaderSection(bill: bill),
                    SizedBox(height: isWeb ? 16.h : 5.h),
                    BillTableSection(bill: bill),
                    SizedBox(height: isWeb ? 16.h : 18.h),
                    BillTotalSection(bill: bill),
                    SizedBox(height: isWeb ? 16.h : 20.h),
                    Text(
                      'Note: Thank you for choosing us!',
                      style: TextStyle(
                        fontSize: isWeb ? 5.sp : 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: bottomInset,
                vertical: isWeb ? 6.h : 18.h,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWeb ? 50.w : double.infinity,
                ),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    showLoadingDialog(context, message: 'Generating bill');
                    await Future.delayed(const Duration(seconds: 2));
                    await generateInvoicePdf(bill, shouldOpen: true);
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.download,
                    color: Colors.white,
                    size: isWeb ? 8.sp : 20.sp,
                  ),
                  label: Text(
                    'Save & Share Invoice',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isWeb ? 7.sp : 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isWeb ? 8.r : 12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: isWeb ? 6.h : 14.h),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
