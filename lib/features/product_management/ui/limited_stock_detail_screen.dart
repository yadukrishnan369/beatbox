import 'dart:convert';
import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/features/product_management/widgets/limited_stock_detail_section_widget.dart';
import 'package:beatbox/features/product_management/widgets/update_quantity_widget.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/foundation.dart';
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

  Uint8List? decodeBase64Image(String? base64String) {
    try {
      if (base64String == null || base64String.isEmpty) return null;
      return base64Decode(base64String);
    } catch (e) {
      print("Image decode error: $e");
      return null;
    }
  }

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
    final profitPerItem = product.salePrice - product.purchaseRate;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Limited Stock Details',
          style: TextStyle(
            fontSize: isWeb ? 22 : 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = isWeb ? 600 : double.infinity;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Padding(
                padding: EdgeInsets.only(
                  top: isWeb ? 20 : 15.h,
                  bottom: isWeb ? 20 : 15.h,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: isWeb ? 240.h : 200.h,
                        width: double.infinity,
                        color: AppColors.white,
                        child: isWeb ? _webImageWidget() : _mobileImageWidget(),
                      ),
                      Container(
                        color: AppColors.white,
                        child: Padding(
                          padding: EdgeInsets.all(isWeb ? 24 : 16.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.productName,
                                style: TextStyle(
                                  fontSize: isWeb ? 20 : 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: isWeb ? 10 : 8.h),
                              Text(
                                product.productCategory,
                                style: TextStyle(
                                  fontSize: isWeb ? 16 : 16.sp,
                                  color: AppColors.textDisabled,
                                ),
                              ),

                              SizedBox(height: isWeb ? 30 : 24.h),
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
                                value:
                                    '₹${AmountFormatter.format(product.salePrice)}',
                              ),
                              LimitedStockDetailSection(
                                label: 'Profit per item',
                                value:
                                    '₹ ${AmountFormatter.format(profitPerItem)}',
                              ),
                              SizedBox(height: isWeb ? 20 : 16.h),
                            ],
                          ),
                        ),
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
        padding: EdgeInsets.all(isWeb ? 24 : 16.r),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            padding: EdgeInsets.symmetric(vertical: isWeb ? 16 : 14.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          onPressed: () {
            showQuantityPopup(context: context, product: product);
          },
          child: Text(
            'Update Quantity',
            style: TextStyle(
              fontSize: isWeb ? 16 : 16.sp,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _webImageWidget() {
    final bytes = decodeBase64Image(product.webImage1);
    if (bytes != null) {
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackIcon(),
      );
    }
    return _fallbackIcon();
  }

  Widget _mobileImageWidget() {
    if (product.image1 != null &&
        product.image1!.isNotEmpty &&
        File(product.image1!).existsSync()) {
      return Image.file(
        File(product.image1!),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackIcon(),
      );
    }
    return _fallbackIcon();
  }

  Widget _fallbackIcon() {
    final isWeb = kIsWeb;
    return Center(
      child: Icon(
        Icons.inventory,
        size: isWeb ? 100 : 100.sp,
        color: AppColors.primary,
      ),
    );
  }
}
