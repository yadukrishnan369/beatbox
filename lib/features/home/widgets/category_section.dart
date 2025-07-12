import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/category_update_notifier.dart';
import 'package:beatbox/features/home/widgets/category_grid_widget.dart';
import 'package:beatbox/features/product_management/model/category_model.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:beatbox/widgets/shimmer_widgets/shimmer_category_banner.dart';
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
                CategoryGridWidget(
                  visibleCategories: visibleCategories,
                  isWeb: isWeb,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
