import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:beatbox/core/app_colors.dart';

class DateRangeInfoWidget extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final VoidCallback onClear;

  const DateRangeInfoWidget({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onClear,
  });

  String _format(DateTime? date) {
    return date != null ? DateFormat('dd MMM yyyy').format(date) : '';
  }

  @override
  Widget build(BuildContext context) {
    if (startDate == null && endDate == null) return const SizedBox();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.cardColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'From: ${_format(startDate)}',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15.sp,
                  ),
                ),
                Text(
                  'To: ${_format(endDate)}',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15.sp,
                  ),
                ),
              ],
            ),
          ),
          IconButton(icon: Icon(Icons.clear, size: 18.sp), onPressed: onClear),
        ],
      ),
    );
  }
}
