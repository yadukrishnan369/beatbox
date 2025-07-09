import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/sales_management/widgets/sale_customer_detail_card_widget.dart';
import 'package:beatbox/features/sales_management/widgets/sale_order_number_card_widget.dart';
import 'package:beatbox/features/sales_management/widgets/sale_item_list_widget.dart';
import 'package:beatbox/features/sales_management/widgets/sale_summary_card_widget.dart';
import 'package:beatbox/utils/sales_utils.dart';
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
        title: LayoutBuilder(
          builder: (context, constraints) {
            final isWeb = constraints.maxWidth > 600;
            return Text(
              'Sales details',
              style: TextStyle(
                fontSize: isWeb ? 20 : 22.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            );
          },
        ),
        centerTitle: false,
        actions: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isWeb = constraints.maxWidth > 600;
              return SizedBox(
                width: isWeb ? 60 : 80.w,
                child: PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: AppColors.textPrimary),
                  onSelected: (value) {
                    if (value == 'delete') {
                      SalesUtils.confirmAndDeleteSale(context, sale);
                    }
                  },
                  itemBuilder:
                      (BuildContext context) => [
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: AppColors.error,
                              ),
                              SizedBox(width: isWeb ? 6 : 8.w),
                              const Text('Delete'),
                            ],
                          ),
                        ),
                      ],
                ),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWeb = constraints.maxWidth > 600;
          final double maxContentWidth = isWeb ? 800 : double.infinity;
          final EdgeInsets contentPadding = EdgeInsets.symmetric(
            horizontal: isWeb ? constraints.maxWidth * 0.1 : 16.w,
            vertical: isWeb ? 20 : 0,
          );

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: Padding(
                  padding: contentPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OrderNumberCardWidget(sale: sale),
                      SizedBox(height: isWeb ? 16 : 20.h),
                      CustomerDetailCard(sale: sale),
                      SizedBox(height: isWeb ? 16 : 20.h),
                      SaleSummaryCard(sale: sale),
                      SizedBox(height: isWeb ? 16 : 20.h),
                      SaleItemListWidget(sale: sale),
                      SizedBox(height: isWeb ? 16 : 20.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          final isWeb = constraints.maxWidth > 400;
          final double paddingH = isWeb ? constraints.maxWidth * 0.1 : 18.w;

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: paddingH,
                vertical: isWeb ? 20 : 12.h,
              ),
              child: SizedBox(
                width: isWeb ? 200 : double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/billDetails',
                      arguments: sale,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isWeb ? 10 : 12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: isWeb ? 16 : 14.h),
                  ),
                  child: Text(
                    'View Invoice',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: isWeb ? 15 : 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
