import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/app_settings_info_management/controller/theme_controller.dart';
import 'package:beatbox/features/app_settings_info_management/widgets/gst_adjustment.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          'App settings',
          style: TextStyle(
            fontSize: isWeb ? 24 : 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: isWeb ? 20 : 15.h),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWeb ? 600 : double.infinity,
            ),
            child: ListView(
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: ThemeController.isDarkMode,
                  builder: (context, isDark, _) {
                    return _buildSettingItem(
                      context,
                      isWeb: isWeb,
                      title: 'Dark mode',
                      leading: Icon(
                        Icons.dark_mode_outlined,
                        size: isWeb ? 26 : null,
                      ),
                      trailing: Transform.scale(
                        scale: isWeb ? 1.0 : 0.9.w,
                        child: Switch(
                          value: isDark,
                          onChanged: (value) async {
                            await ThemeController.toggleTheme(value);
                            AppColors.updateTheme(value);
                          },
                        ),
                      ),
                      onTap: () async {
                        final value = !isDark;
                        await ThemeController.toggleTheme(value);
                        AppColors.updateTheme(value);
                      },
                    );
                  },
                ),
                SizedBox(height: isWeb ? 14 : 10.h),

                _buildSettingItem(
                  context,
                  isWeb: isWeb,
                  leading: Icon(Icons.backup_outlined, size: isWeb ? 26 : null),
                  title: 'Backup or Export Data',
                  trailing: Icon(Icons.chevron_right, size: isWeb ? 26 : 24.w),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.backupData);
                  },
                ),
                SizedBox(height: isWeb ? 14 : 10.h),

                _buildSettingItem(
                  context,
                  isWeb: isWeb,
                  leading: Icon(Icons.refresh, size: isWeb ? 26 : null),
                  title: 'Reset App Data',
                  trailing: Icon(Icons.chevron_right, size: isWeb ? 26 : 24.w),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.resetApp);
                  },
                ),
                SizedBox(height: isWeb ? 14 : 10.h),

                _buildSettingItem(
                  context,
                  isWeb: isWeb,
                  leading: Icon(
                    Icons.account_balance_outlined,
                    size: isWeb ? 26 : null,
                  ),
                  title: 'Adjust GST(%)',
                  trailing: Icon(Icons.add, size: isWeb ? 26 : 24.w),
                  onTap: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => const GSTAdjustmentDialog(),
                    );
                  },
                ),
                SizedBox(height: isWeb ? 14 : 10.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required String title,
    required Widget leading,
    required Widget trailing,
    required VoidCallback onTap,
    required bool isWeb,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 20 : 16.w),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: isWeb ? 10 : 0,
              vertical: isWeb ? 4 : 0,
            ),
            leading: leading,
            title: Text(
              title,
              style: TextStyle(
                fontSize: isWeb ? 18 : 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            trailing: trailing,
            onTap: onTap,
          ),
          SizedBox(height: isWeb ? 12 : 10.h),
          Divider(height: isWeb ? 1.5 : 1.h),
        ],
      ),
    );
  }
}
