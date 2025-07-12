import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/app_settings_info_management/widgets/app_info_body_content_widget.dart';
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
              child: AppInfoBodyContent(
                isWeb: isWeb,
                version: version,
                lastUpdated: lastUpdated,
                developer: developer,
                privacyPolicyPoints: _privacyPolicyPoints,
                termsConditionsPoints: _termsConditionsPoints,
              ),
            ),
          ),
        ),
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
