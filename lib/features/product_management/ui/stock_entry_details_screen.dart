import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class StockEntryDetailsScreen extends StatefulWidget {
  const StockEntryDetailsScreen({super.key});

  @override
  State<StockEntryDetailsScreen> createState() =>
      _StockEntryDetailsScreenState();
}

class _StockEntryDetailsScreenState extends State<StockEntryDetailsScreen> {
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
    final totalValue = product.purchaseRate * product.productQuantity;
    final profitPerItem = product.salePrice - product.purchaseRate;
    final totalProfit = profitPerItem * product.productQuantity;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Stock Details',
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
              // Product Image
              Container(
                height: 200.h,
                width: double.infinity,
                color: AppColors.white,
                child:
                    product.image1 != null
                        ? Image.file(File(product.image1!), fit: BoxFit.cover)
                        : Icon(
                          Icons.headset,
                          size: 100.sp,
                          color: AppColors.primary,
                        ),
              ),

              // Details
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
                        'Headset',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textDisabled,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      _buildDetailRow(
                        'Purchased Date',
                        DateFormat('dd MMM yyyy').format(product.createdDate),
                      ),
                      _buildDetailRow(
                        'Quantity',
                        product.productQuantity.toString(),
                      ),
                      _buildDetailRow(
                        'Purchase Price per item',
                        '₹${product.purchaseRate.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      ),
                      _buildDetailRow(
                        'For sale per item',
                        '₹${product.salePrice.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      ),
                      _buildDetailRow(
                        'Profit per item',
                        '₹ ${profitPerItem.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: AppColors.contColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'STOCK TOTAL',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                Text(
                                  '₹${totalValue.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                    color: AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 16.w,
                                    top: 4.h,
                                  ),
                                  child: Text(
                                    '${product.purchaseRate.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} x ${product.productQuantity}',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'EXPECTED PROFIT',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                Text(
                                  '₹${totalProfit.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                    color: AppColors.success,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 16.w,
                                    top: 4.h,
                                  ),
                                  child: Text(
                                    '${profitPerItem.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} x ${product.productQuantity}',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label :',
            style: TextStyle(fontSize: 16.sp, color: AppColors.primary),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
