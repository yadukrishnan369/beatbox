import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/features/product_management/model/category_model.dart';
import 'package:beatbox/core/notifiers/category_update_notifiers.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CategoryModel>>(
      valueListenable: categoryUpdatedNotifier,
      builder: (context, categories, _) {
        final isMoreThan6 = categories.length > 6;
        final visibleCategories =
            isMoreThan6 ? categories.take(6).toList() : categories;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title and view all option
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (isMoreThan6)
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.brandAndCategory,
                        );
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Placeholder Image
            if (categories.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/empty_image.png',
                      height: 130.h,
                      width: 350.w,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'No categories added yet!',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            else
              // Show category list
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                  ),
                  itemCount: visibleCategories.length,
                  itemBuilder: (context, index) {
                    final category = visibleCategories[index];

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: AppColors.contColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.file(
                                  File(category.categoryImagePath),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              category.categoryName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                                color: AppColors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
