import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LimitedStockDetailSection extends StatelessWidget {
  const LimitedStockDetailSection({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = isWeb ? 700 : double.infinity;

        return Align(
          alignment: Alignment.center,
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            margin: EdgeInsets.only(bottom: isWeb ? 16 : 12.h),
            padding: EdgeInsets.symmetric(
              vertical: isWeb ? 14 : 12.h,
              horizontal: isWeb ? 20 : 16.w,
            ),
            decoration: BoxDecoration(
              color: AppColors.contColor,
              borderRadius: BorderRadius.circular(isWeb ? 6 : 5.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: isWeb ? 16 : 16.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(width: isWeb ? 16 : 10.w),
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: isWeb ? 17 : 17.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
