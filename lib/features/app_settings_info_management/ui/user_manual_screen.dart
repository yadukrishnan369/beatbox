import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/app_settings_info_management/widgets/user_manual_expandable_widget.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserManualScreen extends StatelessWidget {
  const UserManualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'User Manual',
          style: TextStyle(
            fontSize: isWeb ? 22 : 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWeb ? 700 : double.infinity,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // welcome box
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.contColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      'Welcome to the User-Guide! This page is specially designed to guide you step-by-step on how to use every important feature of this app effectively. Whether you are a beginner or a regular user, this guide ensures you don’t miss any functionality.',
                      style: TextStyle(
                        fontSize: isWeb ? 15 : 14.sp,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // expandable sections
                  UserManualExpandableWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
