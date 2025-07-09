import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterButtons extends StatefulWidget {
  final Function(DateTime, DateTime) onFilterSelected;

  const FilterButtons({super.key, required this.onFilterSelected});

  @override
  State<FilterButtons> createState() => _FilterButtonsState();
}

class _FilterButtonsState extends State<FilterButtons> {
  String selectedFilter = 'Today';

  void _handleQuickRange(String label, int days) {
    setState(() => selectedFilter = label);
    final now = DateTime.now();
    final start = now.subtract(Duration(days: days - 1));
    widget.onFilterSelected(start, now);
  }

  void _pickCustomRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => selectedFilter = 'Select Range');
      widget.onFilterSelected(picked.start, picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = Responsive.isDesktop(context);
        final double height = isWeb ? 42 : 46.h;
        final double paddingBottom = isWeb ? 10 : 1.h;

        return Padding(
          padding: EdgeInsets.only(bottom: paddingBottom),
          child: SizedBox(
            height: height,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: isWeb ? 10 : 8.w),
                  _buildFilterButton(
                    "Select Range",
                    () => _pickCustomRange(context),
                    isWeb,
                  ),
                  _buildFilterButton(
                    "Today",
                    () => _handleQuickRange("Today", 1),
                    isWeb,
                  ),
                  _buildFilterButton(
                    "1 Week",
                    () => _handleQuickRange("1 Week", 7),
                    isWeb,
                  ),
                  _buildFilterButton(
                    "1 Month",
                    () => _handleQuickRange("1 Month", 30),
                    isWeb,
                  ),
                  _buildFilterButton(
                    "6 Months",
                    () => _handleQuickRange("6 Months", 180),
                    isWeb,
                  ),
                  SizedBox(width: isWeb ? 10 : 8.w),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterButton(String label, VoidCallback onPressed, bool isWeb) {
    final isSelected = label == selectedFilter;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 12 : 6.w),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.primary : AppColors.cardColor,
          foregroundColor: isSelected ? AppColors.white : AppColors.textPrimary,
          elevation: isSelected ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isWeb ? 18 : 20.r),
            side:
                isSelected
                    ? BorderSide.none
                    : BorderSide(color: AppColors.contColor),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isWeb ? 26 : 16.w,
            vertical: isWeb ? 8 : 10.h,
          ),
          textStyle: TextStyle(
            fontSize: isWeb ? 14 : 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
