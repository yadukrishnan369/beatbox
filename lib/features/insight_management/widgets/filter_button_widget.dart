import 'package:beatbox/core/app_colors.dart';
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
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: SizedBox(
        height: 46.h,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: 8.w),
              _buildFilterButton(
                "Select Range",
                () => _pickCustomRange(context),
              ),
              _buildFilterButton("Today", () => _handleQuickRange("Today", 1)),
              _buildFilterButton(
                "1 Week",
                () => _handleQuickRange("1 Week", 7),
              ),
              _buildFilterButton(
                "1 Month",
                () => _handleQuickRange("1 Month", 30),
              ),
              _buildFilterButton(
                "6 Months",
                () => _handleQuickRange("6 Months", 180),
              ),
              SizedBox(width: 8.w),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, VoidCallback onPressed) {
    final isSelected = label == selectedFilter;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.primary : AppColors.cardColor,
          foregroundColor: isSelected ? AppColors.white : AppColors.textPrimary,
          elevation: isSelected ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
            side:
                isSelected
                    ? BorderSide.none
                    : BorderSide(color: AppColors.contColor),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          textStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
        ),
        child: Text(label),
      ),
    );
  }
}
