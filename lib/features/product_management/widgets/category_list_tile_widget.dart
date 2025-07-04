import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/category_update_notifier.dart';
import 'package:beatbox/features/product_management/controller/category_controller.dart';
import 'package:beatbox/features/product_management/model/category_model.dart';
import 'package:beatbox/features/product_management/widgets/edit_catogory_brand_dialogs.dart';
import 'package:beatbox/widgets/Loading_widgets/show_loading_dialog.dart';
import 'package:beatbox/widgets/empty_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CatogoryListTabTile extends StatelessWidget {
  const CatogoryListTabTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CategoryModel>>(
      valueListenable: categoryUpdatedNotifier,
      builder: (context, categoryList, _) {
        if (categoryList.isEmpty) {
          return EmptyPlaceholder(
            imagePath: 'assets/images/empty_product.png',
            message: 'No Category added yet.\n please add Category !',
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: categoryList.length,
          itemBuilder: (context, index) {
            final item = categoryList[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12.h),
              elevation: 3,
              child: ListTile(
                contentPadding: EdgeInsets.all(16.w),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.file(
                    File(item.categoryImagePath),
                    width: 70.w,
                    height: 70.h,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  item.categoryName,
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
                            builder:
                                (context) => EditCategoryDialog(item: item),
                          ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: AppColors.error),
                      onPressed:
                          () => (CategoryModel item) {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: Text(
                                      'Delete Category',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    content: Text(
                                      'Are you sure you want to delete "${item.categoryName}"?',
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
                                          CategoryController.initBox();
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
