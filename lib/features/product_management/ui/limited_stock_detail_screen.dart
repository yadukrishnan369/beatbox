import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/features/product_management/widgets/limited_stock_detail_section_widget.dart';
import 'package:beatbox/features/product_management/widgets/update_quantity_widget.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class LimitedStockDetailScreen extends StatefulWidget {
  const LimitedStockDetailScreen({super.key});

  @override
  State<LimitedStockDetailScreen> createState() =>
      _LimitedStockDetailScreenState();
}

class _LimitedStockDetailScreenState extends State<LimitedStockDetailScreen> {
  late ProductModel product;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      product = ModalRoute.of(context)!.settings.arguments as ProductModel;
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final profitPerItem = product.salePrice - product.purchaseRate;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Limited Stock Details',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200.h,
                width: double.infinity,
                color: AppColors.white,
                child:
                    product.image1 != null
                        ? Image.file(File(product.image1!), fit: BoxFit.cover)
                        : Icon(
                          Icons.inventory,
                          size: 100.sp,
                          color: AppColors.primary,
                        ),
              ),
              Container(
                color: AppColors.white,
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productName,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        product.productCategory,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textDisabled,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      LimitedStockDetailSection(
                        label: 'Purchased Date',
                        value: DateFormat(
                          'dd MMM yyyy',
                        ).format(product.createdDate),
                      ),
                      LimitedStockDetailSection(
                        label: 'Current Quantity',
                        value: product.productQuantity.toString(),
                      ),
                      LimitedStockDetailSection(
                        label: 'Purchase Price per item',
                        value:
                            '₹${AmountFormatter.format(product.purchaseRate)}',
                      ),
                      LimitedStockDetailSection(
                        label: 'For sale per item',
                        value: '₹${AmountFormatter.format(product.salePrice)}',
                      ),
                      LimitedStockDetailSection(
                        label: 'Profit per item',
                        value: '₹ ${AmountFormatter.format(profitPerItem)}',
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.r),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          onPressed: () {
            showQuantityPopup(context: context, product: product);
          },

          child: Text(
            'Update Quantity',
            style: TextStyle(fontSize: 16.sp, color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
