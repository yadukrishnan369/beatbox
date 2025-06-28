import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/utils/new_arrival_utils.dart';
import 'package:beatbox/utils/product_enable_disable_toggle_utils.dart';
import 'package:beatbox/utils/product_utils.dart';
import 'package:beatbox/widgets/Loading_widgets/show_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurrentStockTile extends StatefulWidget {
  final ProductModel product;

  const CurrentStockTile({super.key, required this.product});

  @override
  State<CurrentStockTile> createState() => _CurrentStockTileState();
}

class _CurrentStockTileState extends State<CurrentStockTile> {
  // Always fetch fresh value from product model
  bool get isAvailable => widget.product.isAvailableForSale;

  Future<void> toggleSaleStatus() async {
    await showLoadingDialog(context, message: 'Loading...', showSucess: false);
    final newStatus = await ProductToggleUtils.toggleSaleStatus(widget.product);

    // update model inside setState
    setState(() {
      widget.product.isAvailableForSale = newStatus;
    });

    // Refresh full product list
    await ProductUtils.loadProducts();
    await NewArrivalUtils.loadNewArrivalProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.contColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(10.r),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child:
              widget.product.image1 != null
                  ? Image.file(
                    File(widget.product.image1!),
                    width: 60.w,
                    height: 60.h,
                    fit: BoxFit.cover,
                  )
                  : Icon(Icons.image, size: 40.sp),
        ),
        title: Text(
          widget.product.productName,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "code: ${widget.product.productCode}",
              style: TextStyle(fontSize: 13.sp),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder:
                      (ctx) => AlertDialog(
                        backgroundColor: AppColors.white,
                        title: Text(
                          "Are you sure?",
                          style: TextStyle(color: AppColors.primary),
                        ),
                        content: Text(
                          isAvailable
                              ? "Do you want to stop sale for this product?"
                              : "Do you want to mark this product as ready for sale?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: AppColors.error),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: Text(
                              "Yes",
                              style: TextStyle(color: AppColors.success),
                            ),
                          ),
                        ],
                      ),
                );

                if (confirm == true) {
                  await toggleSaleStatus();
                }
              },

              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isAvailable ? AppColors.error : AppColors.success,
                  border: Border.all(
                    color: isAvailable ? AppColors.error : AppColors.success,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  isAvailable ? "Stop Sale" : "Ready for Sale",
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.success),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            "Available: ${widget.product.productQuantity}",
            style: TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
              fontSize: 10.sp,
            ),
          ),
        ),
      ),
    );
  }
}
