import 'dart:convert';
import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/utils/new_arrival_utils.dart';
import 'package:beatbox/utils/product_enable_disable_toggle_utils.dart';
import 'package:beatbox/utils/product_utils.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:beatbox/widgets/Loading_widgets/show_loading_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurrentStockTile extends StatefulWidget {
  final ProductModel product;

  const CurrentStockTile({super.key, required this.product});

  @override
  State<CurrentStockTile> createState() => _CurrentStockTileState();
}

class _CurrentStockTileState extends State<CurrentStockTile> {
  bool get isAvailable => widget.product.isAvailableForSale;

  Uint8List? decodeBase64Image(String? base64String) {
    try {
      if (base64String == null || base64String.isEmpty) return null;
      return base64Decode(base64String);
    } catch (e) {
      print("Web image decode failed: $e");
      return null;
    }
  }

  Future<void> toggleSaleStatus() async {
    await showLoadingDialog(context, message: 'Loading...', showSucess: false);
    final newStatus = await ProductToggleUtils.toggleSaleStatus(widget.product);
    setState(() => widget.product.isAvailableForSale = newStatus);
    await ProductUtils.loadProducts();
    await NewArrivalUtils.loadNewArrivalProducts();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb =
            Responsive.isDesktop(context) || constraints.maxWidth > 600;
        final double maxTileWidth = isWeb ? 600 : double.infinity;

        return Align(
          alignment: Alignment.center,
          child: Container(
            width: maxTileWidth,
            margin: EdgeInsets.only(bottom: isWeb ? 12 : 12.h),
            decoration: BoxDecoration(
              color: AppColors.contColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(isWeb ? 12 : 10.r),
              leading: Container(
                width: isWeb ? 70 : 60.w,
                height: isWeb ? 65 : 60.h,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: isWeb ? _webImageWidget() : _mobileImageWidget(),
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.product.productName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: isWeb ? 15 : 16.sp,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: isWeb ? 10 : 6.w),
                  Container(
                    width: isWeb ? 12 : 10.w,
                    height: isWeb ? 12 : 10.w,
                    decoration: BoxDecoration(
                      color: isAvailable ? AppColors.success : AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "code: ${widget.product.productCode}",
                    style: TextStyle(
                      fontSize: isWeb ? 12 : 13.sp,
                      color: AppColors.textDisabled,
                    ),
                  ),
                  SizedBox(height: isWeb ? 6 : 6.h),
                  GestureDetector(
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder:
                            (ctx) => AlertDialog(
                              title: Text(
                                "Are you sure?",
                                style: TextStyle(color: AppColors.primary),
                              ),
                              content: Text(
                                isAvailable
                                    ? "Do you want to stop sale for this product?"
                                    : "Do you want to mark this product as ready for sale?",
                                style: TextStyle(color: AppColors.textPrimary),
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

                      if (confirm == true) await toggleSaleStatus();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWeb ? 10 : 8.w,
                        vertical: isWeb ? 6 : 6.h,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isAvailable ? AppColors.error : AppColors.success,
                        border: Border.all(
                          color:
                              isAvailable ? AppColors.error : AppColors.success,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        isAvailable ? "Stop Sale" : "Ready for Sale",
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: isWeb ? 12 : 11.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              trailing: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isWeb ? 8 : 5.w,
                  vertical: isWeb ? 5 : 4.h,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textPrimary),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  "Available: ${widget.product.productQuantity}",
                  style: TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                    fontSize: isWeb ? 12.5 : 12.sp,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _webImageWidget() {
    final bytes = decodeBase64Image(widget.product.webImage1);
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
    if (widget.product.image1 != null &&
        widget.product.image1!.isNotEmpty &&
        File(widget.product.image1!).existsSync()) {
      return Image.file(
        File(widget.product.image1!),
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
        Icons.image,
        color: AppColors.primary,
        size: isWeb ? 30 : 24.sp,
      ),
    );
  }
}
