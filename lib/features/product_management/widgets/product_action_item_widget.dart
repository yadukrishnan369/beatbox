import 'package:beatbox/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductActionItemWidget extends StatelessWidget {
  const ProductActionItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.iconSize,
    required this.fontSize,
    required this.trailingIconSize,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final double iconSize;
  final double fontSize;
  final double trailingIconSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 6.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
          leading: Icon(icon, color: AppColors.primary, size: iconSize),
          title: Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: trailingIconSize),
          onTap: onTap,
        ),
      ),
    );
  }
}
