import 'package:beatbox/constants/app_images.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppInfoBodyContent extends StatelessWidget {
  const AppInfoBodyContent({
    super.key,
    required this.isWeb,
    required this.version,
    required this.lastUpdated,
    required this.developer,
    required List<String> privacyPolicyPoints,
    required List<String> termsConditionsPoints,
  }) : _privacyPolicyPoints = privacyPolicyPoints,
       _termsConditionsPoints = termsConditionsPoints;

  final bool isWeb;
  final String version;
  final String lastUpdated;
  final String developer;
  final List<String> _privacyPolicyPoints;
  final List<String> _termsConditionsPoints;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // app info logo & header
        Row(
          children: [
            Image.asset(
              AppImages.logo,
              width: isWeb ? 50 : 40.w,
              height: isWeb ? 50 : 40.h,
            ),
            SizedBox(width: isWeb ? 12 : 8.w),
            Text(
              'App Information',
              style: TextStyle(
                fontSize: isWeb ? 24 : 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: isWeb ? 24 : 20.h),

        // version details
        ...[
          'App Version: $version',
          'Last Updated: $lastUpdated',
          'Developed by $developer',
        ].map(
          (e) => Padding(
            padding: EdgeInsets.only(bottom: isWeb ? 10 : 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: isWeb ? 8 : 6.h,
                    right: isWeb ? 10 : 8.w,
                  ),
                  width: 4.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    e,
                    style: TextStyle(
                      fontSize: isWeb ? 15 : 14.sp,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: isWeb ? 20 : 16.h),
        Text(
          'This is the latest version of the app with improved performance and minor fixes. Please make sure to keep the app updated for the best experience.',
          style: TextStyle(
            fontSize: isWeb ? 15 : 14.sp,
            color: AppColors.textPrimary,
            height: 1.5,
          ),
        ),
        SizedBox(height: isWeb ? 30 : 24.h),

        // legal section
        Text(
          'Support & Legal',
          style: TextStyle(
            fontSize: isWeb ? 22 : 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: isWeb ? 20 : 15.h),
        Text(
          '• Privacy Policy',
          style: TextStyle(
            fontSize: isWeb ? 18 : 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          'Learn how we collect, use, and protect your personal information.',
          style: TextStyle(
            fontSize: isWeb ? 15 : 14.sp,
            color: AppColors.textPrimary,
            height: 1.5,
          ),
        ),
        SizedBox(height: isWeb ? 20 : 15.h),
        ..._privacyPolicyPoints.map(
          (e) => Padding(
            padding: EdgeInsets.only(
              bottom: isWeb ? 10 : 6.h,
              left: isWeb ? 16 : 12.w,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: TextStyle(
                    fontSize: isWeb ? 15 : 14.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                Expanded(
                  child: Text(
                    e,
                    style: TextStyle(
                      fontSize: isWeb ? 15 : 14.sp,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: isWeb ? 24 : 20.h),
        Text(
          '• Terms & Conditions',
          style: TextStyle(
            fontSize: isWeb ? 18 : 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: isWeb ? 20 : 15.h),
        ..._termsConditionsPoints.map(
          (e) => Padding(
            padding: EdgeInsets.only(
              bottom: isWeb ? 10 : 6.h,
              left: isWeb ? 16 : 12.w,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: TextStyle(
                    fontSize: isWeb ? 15 : 14.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                Expanded(
                  child: Text(
                    e,
                    style: TextStyle(
                      fontSize: isWeb ? 15 : 14.sp,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
