import 'package:beatbox/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyPlaceholder extends StatelessWidget {
  final String imagePath;
  final String message;
  final double imageSize;
  final VoidCallback? onActionTap;
  final String? actionText;
  final IconData? actionIcon;

  const EmptyPlaceholder({
    super.key,
    required this.imagePath,
    required this.message,
    this.imageSize = 150,
    this.onActionTap,
    this.actionText,
    this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: imageSize.w,
              height: imageSize.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onActionTap != null && actionText != null) ...[
              SizedBox(height: 20.h),
              ElevatedButton.icon(
                onPressed: onActionTap,
                label: Text(actionText!),
                icon: Icon(actionIcon),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
