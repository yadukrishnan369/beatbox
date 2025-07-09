import 'dart:convert';
import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/foundation.dart';
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
    final bool isWeb = Responsive.isDesktop(context);
    final isOutOfStock = product.productQuantity == 0;
    final totalValue =
        product.purchaseRate *
        (product.initialQuantity ?? product.productQuantity);
    final profitPerItem = product.salePrice - product.purchaseRate;
    final totalProfit =
        profitPerItem * (product.initialQuantity ?? product.productQuantity);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Stock Details',
          style: TextStyle(
            fontSize: isWeb ? 9.sp : 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Container(
            width: isWeb ? 200.w : double.infinity,
            padding: EdgeInsets.symmetric(horizontal: isWeb ? 18.w : 0),
            child: Column(
              children: [
                SizedBox(height: isWeb ? 20.h : 15.h),

                // product image
                Container(
                  height: isWeb ? 250.h : 200.h,
                  width: double.infinity,
                  color: AppColors.white,
                  child: _buildProductImage(product),
                ),

                // details
                Padding(
                  padding: EdgeInsets.all(isWeb ? 20.r : 16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // name & status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.productName,
                              style: TextStyle(
                                fontSize: isWeb ? 8.sp : 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isWeb ? 5.w : 8.w,
                              vertical: isWeb ? 3.h : 4.h,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  product.isAvailableForSale &&
                                          product.productQuantity > 0
                                      ? AppColors.success
                                      : AppColors.error,
                              borderRadius: BorderRadius.circular(
                                isWeb ? 8.r : 6.r,
                              ),
                            ),
                            child: Text(
                              product.isAvailableForSale &&
                                      product.productQuantity > 0
                                  ? "Active"
                                  : "Inactive",
                              style: TextStyle(
                                fontSize: isWeb ? 6.sp : 13.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isWeb ? 10.h : 8.h),
                      Text(
                        'Headset',
                        style: TextStyle(
                          fontSize: isWeb ? 7.sp : 16.sp,
                          color: AppColors.textDisabled,
                        ),
                      ),
                      SizedBox(height: isWeb ? 26.h : 24.h),

                      // details
                      _buildDetailRow(
                        'Product Entry Date',
                        DateFormat('dd MMM yyyy').format(product.createdDate),
                        isWeb,
                      ),
                      _buildDetailRow(
                        'Purchased Quantity',
                        '${product.initialQuantity}',
                        isWeb,
                      ),
                      _buildDetailRow(
                        'Current Quantity',
                        '${product.productQuantity}',
                        isWeb,
                      ),
                      _buildDetailRow(
                        'Purchase Price per item',
                        '₹${AmountFormatter.format(product.purchaseRate)}',
                        isWeb,
                      ),
                      _buildDetailRow(
                        'For sale per item',
                        '₹${AmountFormatter.format(product.salePrice)}',
                        isWeb,
                      ),
                      _buildDetailRow(
                        'Profit per item',
                        '₹${AmountFormatter.format(profitPerItem)}',
                        isWeb,
                      ),

                      SizedBox(height: isWeb ? 20.h : 16.h),

                      // summary card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(isWeb ? 20.r : 16.r),
                        decoration: BoxDecoration(
                          color: AppColors.contColor,
                          borderRadius: BorderRadius.circular(
                            isWeb ? 10.r : 8.r,
                          ),
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
                                    fontSize: isWeb ? 8.sp : 16.sp,
                                  ),
                                ),
                                Text(
                                  '₹${AmountFormatter.format(totalValue)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isWeb ? 8.sp : 16.sp,
                                    color: AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: isWeb ? 10.w : 16.w,
                                    top: 4.h,
                                  ),
                                  child: Text(
                                    '${AmountFormatter.format(product.purchaseRate)} x ${product.initialQuantity}',
                                    style: TextStyle(
                                      fontSize: isWeb ? 7.sp : 14.sp,
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
                                    fontSize: isWeb ? 8.sp : 16.sp,
                                  ),
                                ),
                                Text(
                                  '₹${AmountFormatter.format(totalProfit)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isWeb ? 8.sp : 16.sp,
                                    color: AppColors.success,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: isWeb ? 10.w : 16.w,
                                    top: 4.h,
                                  ),
                                  child: Text(
                                    '${AmountFormatter.format(profitPerItem)} x ${product.initialQuantity}',
                                    style: TextStyle(
                                      fontSize: isWeb ? 7.sp : 14.sp,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (isOutOfStock)
                              Padding(
                                padding: EdgeInsets.only(top: 8.h),
                                child: Center(
                                  child: Text(
                                    'Out Of Stock',
                                    style: TextStyle(
                                      fontSize: isWeb ? 9.sp : 18.sp,
                                      color: AppColors.error,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isWeb) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label :',
            style: TextStyle(
              fontSize: isWeb ? 7.sp : 16.sp,
              color: AppColors.primary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isWeb ? 8.sp : 17.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(ProductModel product) {
    if (kIsWeb) {
      final base64 = decodeBase64Image(product.webImage1);
      return base64 != null
          ? Image.memory(base64, fit: BoxFit.cover)
          : Center(child: Icon(Icons.image, size: 40.sp));
    } else {
      if (product.image1 != null && File(product.image1!).existsSync()) {
        return Image.file(File(product.image1!), fit: BoxFit.cover);
      } else {
        return Center(child: Icon(Icons.image, size: 40.sp));
      }
    }
  }

  Uint8List? decodeBase64Image(String? base64String) {
    try {
      if (base64String == null || base64String.trim().isEmpty) return null;
      return base64Decode(
        base64String.contains(',')
            ? base64String.split(',').last
            : base64String,
      );
    } catch (e) {
      return null;
    }
  }
}
