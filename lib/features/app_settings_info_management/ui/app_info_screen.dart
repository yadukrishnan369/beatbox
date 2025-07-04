import 'package:beatbox/constants/app_images.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppInfoScreen extends StatelessWidget {
  AppInfoScreen({super.key});

  final String version = '1.0.0';
  final String lastUpdated = 'July 03, 2025';
  final String developer = 'YADUKRISHNAN';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'App info',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.contColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Info logo & Header
              Row(
                children: [
                  Image.asset(AppImages.logo, width: 40.w, height: 40.h),
                  SizedBox(width: 8.w),
                  Text(
                    'App Information',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Version Details
              ...[
                'App Version: $version',
                'Last Updated: $lastUpdated',
                'Developed by $developer',
              ].map(_buildBulletText),

              SizedBox(height: 16.h),
              _buildParagraph(
                'This is the latest version of the app with improved performance and minor fixes. Please make sure to keep the app updated for the best experience.',
              ),
              SizedBox(height: 24.h),

              // Legal Section
              _buildSectionTitle('Support & Legal'),
              SizedBox(height: 15.h),
              _buildSubTitle('• Privacy Policy'),
              _buildParagraph(
                'Learn how we collect, use, and protect your personal information.',
              ),
              SizedBox(height: 15.h),
              ..._privacyPolicyPoints.map(_buildSmallBullet),

              SizedBox(height: 20.h),
              _buildSubTitle('• Terms & Conditions'),
              SizedBox(height: 15.h),
              ..._termsConditionsPoints.map(_buildSmallBullet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletText(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
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
                fontSize: 14.sp,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        color: AppColors.textPrimary,
        height: 1.5,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildSubTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildSmallBullet(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, left: 12.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Data Lists
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
