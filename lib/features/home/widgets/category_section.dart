import 'dart:convert';
import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/category_update_notifier.dart';
import 'package:beatbox/features/product_management/model/category_model.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:beatbox/widgets/shimmer_widgets/shimmer_category_banner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  bool _isShimmering = false;

  @override
  void initState() {
    super.initState();
    if (isFirstTimeCategory.value) {
      _isShimmering = true;
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isShimmering = false;
            isFirstTimeCategory.value = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isShimmering) return const ShimmerCategoryBanner();

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb =
            Responsive.isDesktop(context) || constraints.maxWidth > 600;

        return ValueListenableBuilder<List<CategoryModel>>(
          valueListenable: categoryUpdatedNotifier,
          builder: (context, categories, _) {
            final showViewAll = categories.length > 6;
            final visibleCategories =
                showViewAll ? categories.take(6).toList() : categories;

            if (categories.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: isWeb ? 16 : 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Center(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.asset(
                              'assets/images/empty_image.png',
                              height: isWeb ? 160 : 130.h,
                              width: isWeb ? 700 : 350.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'No categories added yet !',
                            style: TextStyle(
                              fontSize: isWeb ? 14 : 16.sp,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: isWeb ? 16 : 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (showViewAll)
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.brandAndCategory,
                            );
                          },
                          child: Text(
                            'View All',
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: visibleCategories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWeb ? 3 : 2,
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      final category = visibleCategories[index];

                      final imageWidget =
                          kIsWeb
                              ? Image.memory(
                                base64Decode(category.categoryImagePath),
                                width: isWeb ? 60 : 70.w,
                                height: isWeb ? 60 : 70.w,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) =>
                                        const Icon(Icons.image_not_supported),
                              )
                              : Image.file(
                                File(category.categoryImagePath),
                                width: isWeb ? 60 : 70.w,
                                height: isWeb ? 60 : 70.w,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) =>
                                        const Icon(Icons.image_not_supported),
                              );

                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: AppColors.contColor,
                          image: DecorationImage(
                            image: imageWidget.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16.r),
                              bottomRight: Radius.circular(16.r),
                            ),
                          ),
                          child: Text(
                            category.categoryName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
      },
    );
  }
}
