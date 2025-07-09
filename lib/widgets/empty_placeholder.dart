import 'package:beatbox/core/app_colors.dart';
import 'package:flutter/foundation.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = kIsWeb || constraints.maxWidth > 600;

        return Center(
          child: Padding(
            padding: EdgeInsets.all(isWeb ? 32 : 24.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWeb ? 500 : double.infinity,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    imagePath,
                    width: isWeb ? 150 : imageSize.w,
                    height: isWeb ? 150 : imageSize.w,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: isWeb ? 24 : 20.h),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: isWeb ? 18 : 22.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (onActionTap != null && actionText != null) ...[
                    SizedBox(height: isWeb ? 24 : 20.h),
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
          ),
        );
      },
    );
  }
}
