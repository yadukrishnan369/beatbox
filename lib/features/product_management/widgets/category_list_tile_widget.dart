import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/brand_update_notifier.dart';
import 'package:beatbox/features/product_management/controller/brand_controller.dart';
import 'package:beatbox/features/product_management/model/brand_model.dart';
import 'package:beatbox/features/product_management/widgets/edit_catogory_brand_dialogs.dart';
import 'package:beatbox/widgets/Loading_widgets/show_loading_dialog.dart';
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
          return Center(
            child: Text(
              "No Brands Found\n please add brands",
              style: TextStyle(fontSize: 16.sp),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: brandList.length,
          itemBuilder: (context, index) {
            final item = brandList[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12.h),
              elevation: 3,
              child: ListTile(
                contentPadding: EdgeInsets.all(16.w),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.file(
                    File(item.brandImagePath),
                    width: 70.w,
                    height: 70.h,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  item.brandName,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: AppColors.primary),
                      onPressed:
                          () => showDialog(
                            context: context,
                            builder: (context) => EditBrandDialog(item: item),
                          ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: AppColors.error),
                      onPressed:
                          () => (BrandModel item) {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
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
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Cancel'),
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
                          }(item),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
