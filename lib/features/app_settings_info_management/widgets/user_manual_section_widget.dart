import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserManualSection extends StatelessWidget {
  final String title;
  final List<String> points;

  const UserManualSection({
    super.key,
    required this.title,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 8.w),
        childrenPadding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 8.h),
        title: Text(
          title,
          style: TextStyle(
            fontSize: isWeb ? 18 : 15.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        children:
            points.map((point) {
              if (point.startsWith('•')) {
                return _buildSubBulletPoint(
                  point.replaceFirst('•', '').trim(),
                  isWeb,
                );
              } else {
                return _buildBulletPoint(point, isWeb);
              }
            }).toList(),
      ),
    );
  }

  Widget _buildBulletPoint(String text, bool isWeb) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6.h, right: 8.w),
            width: 4.w,
            height: 4.w,
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: isWeb ? 15 : 14.sp,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubBulletPoint(String text, bool isWeb) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, left: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6.h, right: 8.w),
            width: 4.w,
            height: 4.w,
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: isWeb ? 15 : 14.sp,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
