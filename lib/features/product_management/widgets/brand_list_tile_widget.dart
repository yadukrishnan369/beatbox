import 'dart:convert';
import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/brand_update_notifier.dart';
import 'package:beatbox/features/product_management/controller/brand_controller.dart';
import 'package:beatbox/features/product_management/model/brand_model.dart';
import 'package:beatbox/features/product_management/widgets/edit_catogory_brand_dialogs.dart';
import 'package:beatbox/features/product_management/widgets/edit_delete_warning_modal.dart';
import 'package:beatbox/utils/brand_category_validators_utils.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:beatbox/widgets/Loading_widgets/show_loading_dialog.dart';
import 'package:beatbox/widgets/empty_placeholder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrandListTabTile extends StatelessWidget {
  const BrandListTabTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<BrandModel>>(
      valueListenable: brandUpdatedNotifier,
      builder: (context, brandList, _) {
        if (brandList.isEmpty) {
          return EmptyPlaceholder(
            imagePath: 'assets/images/empty_product.png',
            message: 'No Brands added yet.\nPlease add Brands!',
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isWeb =
                Responsive.isDesktop(context) || constraints.maxWidth > 600;

            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: brandList.length,
              itemBuilder: (context, index) {
                final item = brandList[index];

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isWeb ? 200.w : double.infinity,
                    ),
                    child: Card(
                      margin: EdgeInsets.only(bottom: isWeb ? 10.h : 12.h),
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isWeb ? 10.w : 12.w,
                          vertical: isWeb ? 8.h : 12.h,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child:
                                  kIsWeb
                                      ? Image.memory(
                                        base64Decode(item.brandImagePath),
                                        width: isWeb ? 20.w : 70.w,
                                        height: isWeb ? 20.w : 70.w,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (_, __, ___) => const Icon(
                                              Icons.image_not_supported,
                                            ),
                                      )
                                      : Image.file(
                                        File(item.brandImagePath),
                                        width: isWeb ? 20.w : 70.w,
                                        height: isWeb ? 20.w : 70.w,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (_, __, ___) => const Icon(
                                              Icons.image_not_supported,
                                            ),
                                      ),
                            ),
                            SizedBox(width: isWeb ? 10.w : 12.w),

                            // title
                            Expanded(
                              child: Text(
                                item.brandName,
                                style: TextStyle(
                                  fontSize: isWeb ? 6.sp : 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),

                            // edit & delete actions
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: AppColors.primary,
                                    size: isWeb ? 6.sp : 20.sp,
                                  ),
                                  onPressed: () {
                                    final isUsed =
                                        NameAndImageValidators.isBrandUsedInCart(
                                          item.brandName,
                                        );
                                    if (isUsed) {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (
                                              _,
                                            ) => const EditDeleteWarningDialog(
                                              title: "Cannot Proceed !",
                                              message:
                                                  "This brand is used in the cart.\nRemove related products before editing.",
                                            ),
                                      );
                                      return;
                                    }
                                    showDialog(
                                      context: context,
                                      builder:
                                          (_) => EditBrandDialog(item: item),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: AppColors.error,
                                    size: isWeb ? 6.sp : 20.sp,
                                  ),
                                  onPressed: () {
                                    final isUsed =
                                        NameAndImageValidators.isBrandUsedInCart(
                                          item.brandName,
                                        );
                                    if (isUsed) {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (
                                              _,
                                            ) => const EditDeleteWarningDialog(
                                              title: "Cannot Proceed !",
                                              message:
                                                  "This brand is used in the cart.\nRemove related products before deleting.",
                                            ),
                                      );
                                      return;
                                    }
                                    showDialog(
                                      context: context,
                                      builder:
                                          (_) => AlertDialog(
                                            title: Text(
                                              'Delete Brand',
                                              style: TextStyle(
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            content: Text(
                                              'Are you sure you want to delete "${item.brandName}"?',
                                              style: TextStyle(
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await showLoadingDialog(
                                                    context,
                                                    message: "Deleting...",
                                                    showSucess: true,
                                                  );
                                                  await item.delete();
                                                  Navigator.pop(context);
                                                  BrandController.initBox();
                                                },
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    color: AppColors.error,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
