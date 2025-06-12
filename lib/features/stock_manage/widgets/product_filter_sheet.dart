import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/stock_manage/model/brand_model.dart';
import 'package:beatbox/features/stock_manage/model/category_model.dart';
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
    return Padding(
      padding: EdgeInsets.only(
        top: 20.h,
        left: 20.w,
        right: 20.w,
        bottom: 20.h + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          categories.isNotEmpty || brands.isNotEmpty
              ? Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Text(
                  'Filter Products',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.sp,
                  ),
                ),
              )
              : Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Text(
                  'No Filter Available',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.sp,
                  ),
                ),
              ),

          Text(
            'Filter by Category',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
          SizedBox(height: 10.h),
          categories.isEmpty
              ? Text(
                'No categories available',
                style: TextStyle(
                  color: AppColors.textDisabled,
                  fontSize: 14.sp,
                ),
              )
              : Wrap(
                spacing: 10.w,
                children:
                    categories.map((cat) {
                      final isSelected = selectedCategories.contains(
                        cat.categoryName,
                      );
                      return FilterChip(
                        label: Text(cat.categoryName),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            selected
                                ? selectedCategories.add(cat.categoryName)
                                : selectedCategories.remove(cat.categoryName);
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

          SizedBox(height: 20.h),
          Text(
            'Filter by Brand',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
          SizedBox(height: 10.h),
          brands.isEmpty
              ? Text(
                'No brands available',
                style: TextStyle(
                  color: AppColors.textDisabled,
                  fontSize: 14.sp,
                ),
              )
              : Wrap(
                spacing: 10.w,
                children:
                    brands.map((brand) {
                      final isSelected = selectedBrands.contains(
                        brand.brandName,
                      );
                      return FilterChip(
                        label: Text(brand.brandName),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            selected
                                ? selectedBrands.add(brand.brandName)
                                : selectedBrands.remove(brand.brandName);
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

          SizedBox(height: 25.h),
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
                    foregroundColor: AppColors.white,
                  ),
                  child: Text('Apply Filter'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
