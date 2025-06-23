import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/utils/amount_formatter.dart';
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
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.primary, width: 2.w),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Invoice Number',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            sale.invoiceNumber,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1.w,
                      height: 40.h,
                      color: AppColors.white,
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${sale.billingDate.day}-${sale.billingDate.month.toString().padLeft(2, '0')}-${sale.billingDate.year}',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Customer Details
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.contColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.textPrimary, width: 1.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Customer name', sale.customerName),
                    SizedBox(height: 12.h),
                    _buildDetailRow('Phone', sale.customerPhone),
                    SizedBox(height: 12.h),
                    _buildDetailRow('Email', sale.customerEmail),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Sale Summary
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.primary, width: 2.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Invoice ID', sale.invoiceNumber),
                    SizedBox(height: 12.h),
                    _buildDetailRow(
                      'Date',
                      '${sale.billingDate.day}-${sale.billingDate.month.toString().padLeft(2, '0')}-${sale.billingDate.year}',
                    ),
                    SizedBox(height: 12.h),
                    _buildDetailRow(
                      'Time',
                      '${sale.billingDate.hour.toString().padLeft(2, '0')}:${sale.billingDate.minute.toString().padLeft(2, '0')} ${sale.billingDate.hour >= 12 ? 'PM' : 'AM'}',
                    ),
                    SizedBox(height: 12.h),
                    _buildDetailRow(
                      'Total Amount',
                      '₹${AmountFormatter.format(sale.subtotal)}',
                    ),
                    SizedBox(height: 12.h),
                    _buildDetailRow(
                      'GST',
                      '₹${AmountFormatter.format(sale.gst)}',
                    ),
                    SizedBox(height: 12.h),
                    _buildDetailRow(
                      'discount',
                      '₹${AmountFormatter.format(sale.discount)}',
                    ),
                    SizedBox(height: 12.h),
                    _buildDetailRow(
                      'Grand Total',
                      '₹${AmountFormatter.format(sale.grandTotal)}',
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.contColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.textPrimary, width: 1.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...sale.cartItems.map(
                      (item) => Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: _buildProductItem(
                          item.product.productName,
                          item.product.productBrand,
                          item.quantity,
                          item.product.purchaseRate,
                          item.product.salePrice,
                          item.totalPrice,
                          sale.discount,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

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

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120.w,
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          ': ',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductItem(
    String productName,
    String brand,
    int qty,
    double purchaseRate,
    double salePrice,
    double total,
    double discount,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$productName      $brand',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Text(
                'Qty: $qty',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 18.w),
              Text(
                'purchase rate: $purchaseRate',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 18.w),
              Text(
                'sale rate: $salePrice',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              Text(
                'Discount: ₹${AmountFormatter.format(discount)}',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 18.w),
              Text(
                'total: ${total - discount}',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              Text(
                'Sale profit: ₹${AmountFormatter.format((total - (purchaseRate * qty) - discount))}',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
