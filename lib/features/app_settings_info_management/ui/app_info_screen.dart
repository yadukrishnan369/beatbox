import 'package:beatbox/constants/app_images.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppInfoScreen extends StatelessWidget {
  AppInfoScreen({super.key});

  final String version = '1.0.0';
  final String lastUpdated = 'July 03, 2025';
  final String developer = 'YADUKRISHNAN';

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'App info',
          style: TextStyle(
            fontSize: isWeb ? 20 : 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: isWeb ? 24 : 16.w,
          vertical: isWeb ? 16 : 8.h,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWeb ? 600 : double.infinity,
            ),
            child: Container(
              padding: EdgeInsets.all(isWeb ? 24 : 16.w),
              decoration: BoxDecoration(
                color: AppColors.contColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
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
                  ].map((e) => _buildBulletText(e, isWeb)),

                  SizedBox(height: isWeb ? 20 : 16.h),
                  _buildParagraph(
                    'This is the latest version of the app with improved performance and minor fixes. Please make sure to keep the app updated for the best experience.',
                    isWeb,
                  ),
                  SizedBox(height: isWeb ? 30 : 24.h),

                  // legal section
                  _buildSectionTitle('Support & Legal', isWeb),
                  SizedBox(height: isWeb ? 20 : 15.h),
                  _buildSubTitle('• Privacy Policy', isWeb),
                  _buildParagraph(
                    'Learn how we collect, use, and protect your personal information.',
                    isWeb,
                  ),
                  SizedBox(height: isWeb ? 20 : 15.h),
                  ..._privacyPolicyPoints.map(
                    (e) => _buildSmallBullet(e, isWeb),
                  ),

                  SizedBox(height: isWeb ? 24 : 20.h),
                  _buildSubTitle('• Terms & Conditions', isWeb),
                  SizedBox(height: isWeb ? 20 : 15.h),
                  ..._termsConditionsPoints.map(
                    (e) => _buildSmallBullet(e, isWeb),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBulletText(String text, bool isWeb) {
    return Padding(
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

  Widget _buildParagraph(String text, bool isWeb) {
    return Text(
      text,
      style: TextStyle(
        fontSize: isWeb ? 15 : 14.sp,
        color: AppColors.textPrimary,
        height: 1.5,
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isWeb) {
    return Text(
      title,
      style: TextStyle(
        fontSize: isWeb ? 22 : 20.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildSubTitle(String title, bool isWeb) {
    return Text(
      title,
      style: TextStyle(
        fontSize: isWeb ? 18 : 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildSmallBullet(String text, bool isWeb) {
    return Padding(
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

  // data lists
  final List<String> _privacyPolicyPoints = [
    'We collect basic product data and user interactions locally only.',
    'No personal information is uploaded to external servers.',
    'All data remains on the device unless explicitly exported by the user.',
    'We do not share, sell, or trade any data with third parties.',
  ];

  final List<String> _termsConditionsPoints = [
    'The app is designed for managing products, stock, billing, and basic sales.',
    'All data is stored locally using secure device storage.',
    'Users are responsible for regular data backup using the export feature.',
    'The app does not guarantee cloud backups or sync features.',
    'Any misuse of the app or data is the sole responsibility of the user.',
  ];
}
