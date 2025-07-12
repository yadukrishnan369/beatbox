import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/app_settings_info_management/widgets/faq_expandable_widget.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'FAQs',
          style: TextStyle(
            fontSize: isWeb ? 24 : 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isWeb ? 700 : double.infinity),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: isWeb ? 24 : 16.w,
              vertical: isWeb ? 16 : 8.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // welcome box
                Container(
                  padding: EdgeInsets.all(isWeb ? 20 : 16.w),
                  decoration: BoxDecoration(
                    color: AppColors.contColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'Welcome to the Help Section. Here you\'ll find answers to frequently asked questions (FAQs) and the Terms & Conditions for using this app. We created this section to help you understand how to manage your products better, stay informed, and use the app responsibly. Go through the FAQs for quick help and read the terms to know your rights and responsibilities.',
                    style: TextStyle(
                      fontSize: isWeb ? 15 : 14.sp,
                      height: 1.6,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                SizedBox(height: isWeb ? 20 : 16.h),

                // FAQ widget section
                const FAQExpandableWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
