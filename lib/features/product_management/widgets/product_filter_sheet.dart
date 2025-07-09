import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/brand_model.dart';
import 'package:beatbox/features/product_management/model/category_model.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';

class ProductFilterSheet extends StatefulWidget {
  final List<String> selectedCategories;
  final List<String> selectedBrands;
  final VoidCallback onClear;
  final VoidCallback onApply;
  final Function(List<String>) onCategorySelected;
  final Function(List<String>) onBrandSelected;

  const ProductFilterSheet({
    super.key,
    required this.selectedCategories,
    required this.selectedBrands,
    required this.onClear,
    required this.onApply,
    required this.onCategorySelected,
    required this.onBrandSelected,
  });

  @override
  State<ProductFilterSheet> createState() => _ProductFilterSheetState();
}

class _ProductFilterSheetState extends State<ProductFilterSheet> {
  late List<CategoryModel> categories;
  late List<BrandModel> brands;

  List<String> selectedCategories = [];
  List<String> selectedBrands = [];

  @override
  void initState() {
    super.initState();
    selectedCategories = List.from(widget.selectedCategories);
    selectedBrands = List.from(widget.selectedBrands);

    final categoryBox = Hive.box<CategoryModel>('categoryBox');
    final brandBox = Hive.box<BrandModel>('brandBox');

    categories = categoryBox.values.toList();
    brands = brandBox.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.only(
        top: 20.h,
        left: 20.w,
        right: 20.w,
        bottom: 20.h + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          // drag handle
          Container(
            width: 40.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter Products',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: isWeb ? 9.sp : 22.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // category Filters
                  Text(
                    'Filter by Category',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: isWeb ? 5.sp : 16.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  categories.isEmpty
                      ? Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'No categories available',
                          style: TextStyle(
                            color: AppColors.textDisabled,
                            fontSize: isWeb ? 4 : 14.sp,
                          ),
                        ),
                      )
                      : Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 10.w,
                          runSpacing: 10.h,
                          children:
                              categories.map((cat) {
                                final isSelected = selectedCategories.contains(
                                  cat.categoryName,
                                );
                                return FilterChip(
                                  label: Text(cat.categoryName),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() {
                                      selected
                                          ? selectedCategories.add(
                                            cat.categoryName,
                                          )
                                          : selectedCategories.remove(
                                            cat.categoryName,
                                          );
                                    });
                                  },
                                  selectedColor: AppColors.primary,
                                  backgroundColor: AppColors.offWhite,
                                  labelStyle: TextStyle(
                                    color:
                                        isSelected
                                            ? AppColors.white
                                            : AppColors.textPrimary,
                                  ),
                                );
                              }).toList(),
                        ),
                      ),

                  SizedBox(height: 20.h),

                  // brand Filters
                  Text(
                    'Filter by Brand',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: isWeb ? 5.sp : 16.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  brands.isEmpty
                      ? Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'No brands available',
                          style: TextStyle(
                            color: AppColors.textDisabled,
                            fontSize: isWeb ? 4 : 14.sp,
                          ),
                        ),
                      )
                      : Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 10.w,
                          runSpacing: 10.h,
                          children:
                              brands.map((brand) {
                                final isSelected = selectedBrands.contains(
                                  brand.brandName,
                                );
                                return FilterChip(
                                  label: Text(brand.brandName),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() {
                                      selected
                                          ? selectedBrands.add(brand.brandName)
                                          : selectedBrands.remove(
                                            brand.brandName,
                                          );
                                    });
                                  },
                                  selectedColor: AppColors.primary,
                                  backgroundColor: AppColors.offWhite,
                                  labelStyle: TextStyle(
                                    color:
                                        isSelected
                                            ? AppColors.white
                                            : AppColors.textPrimary,
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                ],
              ),
            ),
          ),

          // apply & Clear buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (categories.isNotEmpty || brands.isNotEmpty)
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedCategories.clear();
                      selectedBrands.clear();
                    });
                    widget.onClear();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Clear Filters',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              if (categories.isNotEmpty || brands.isNotEmpty)
                ElevatedButton(
                  onPressed: () {
                    widget.onCategorySelected(selectedCategories);
                    widget.onBrandSelected(selectedBrands);
                    widget.onApply();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Apply Filter'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
