import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';

class BrandCategoryDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final IconData icon;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;

  const BrandCategoryDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.icon,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb =
            Responsive.isDesktop(context) || constraints.maxWidth > 600;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: isWeb ? 8.sp : 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 4.h),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWeb ? 200.w : double.infinity,
              ),
              child: DropdownButtonFormField<String>(
                key: ValueKey(value),
                value: value != null && items.contains(value) ? value : null,
                hint: Text(
                  'Select $label',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                decoration: InputDecoration(
                  prefixIcon: Icon(icon),
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: AppColors.blue),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isWeb ? 14.w : 16.w,
                    vertical: isWeb ? 14.h : 16.h,
                  ),
                ),
                menuMaxHeight: 300.h,
                validator: validator,
                onChanged: onChanged,
                items:
                    items
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(color: AppColors.textPrimary),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        );
      },
    );
  }
}
