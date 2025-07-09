import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = Responsive.isDesktop(context);

    return Drawer(
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      width: isWeb ? 280 : null,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWeb ? 12 : 16,
            vertical: isWeb ? 16 : 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // header row
              Row(
                children: [
                  Container(
                    width: isWeb ? 28 : 36,
                    height: isWeb ? 28 : 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.textPrimary,
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.arrow_back,
                        size: isWeb ? 16 : 20,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: isWeb ? 8 : 12),
                  Text(
                    'Help & Support',
                    style: TextStyle(
                      fontSize: isWeb ? 16 : 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),

              SizedBox(height: isWeb ? 20 : 25),

              // menu section
              Container(
                decoration: BoxDecoration(
                  color: AppColors.contColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      context,
                      icon: Icons.person_outline,
                      title: 'User Manual',
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.userManual);
                      },
                      isWeb: isWeb,
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      context,
                      icon: Icons.help_outline,
                      title: 'FAQs section',
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.faq);
                      },
                      isWeb: isWeb,
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      context,
                      icon: Icons.info_outline,
                      title: 'App info',
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.appInfo);
                      },
                      isWeb: isWeb,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isWeb,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isWeb ? 12 : 16,
          vertical: isWeb ? 10 : 14,
        ),
        child: Row(
          children: [
            Icon(icon, size: isWeb ? 20 : 22.sp, color: AppColors.textPrimary),
            SizedBox(width: isWeb ? 12 : 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: isWeb ? 14 : 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: isWeb ? 14 : 16.sp,
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1.h,
      color: AppColors.textPrimary.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(horizontal: 12),
    );
  }
}
