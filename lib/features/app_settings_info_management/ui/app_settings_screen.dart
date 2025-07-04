import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/app_settings_info_management/controller/theme_controller.dart';
import 'package:beatbox/features/app_settings_info_management/widgets/gst_adjustment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          'App settings',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.h),
        child: ListView(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: ThemeController.isDarkMode,
              builder: (context, isDark, _) {
                return _buildSettingItem(
                  context,
                  title: 'Dark mode',
                  leading: Icon(Icons.dark_mode_outlined),
                  trailing: Transform.scale(
                    scale: 0.9.w,
                    child: Switch(
                      value: isDark,
                      onChanged: (value) async {
                        await ThemeController.toggleTheme(value);
                        AppColors.updateTheme(
                          value,
                        ); // update AppColors dark/light
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

            SizedBox(height: 10.h),
            _buildSettingItem(
              context,
              leading: Icon(Icons.backup_outlined),
              title: 'Backup or Export Data',
              trailing: Icon(Icons.chevron_right, size: 24.w),
              onTap: () {},
            ),
            SizedBox(height: 10.h),
            _buildSettingItem(
              context,
              leading: Icon(Icons.refresh),
              title: 'Reset App Data',
              trailing: Icon(Icons.chevron_right, size: 24.w),
              onTap: () {},
            ),
            SizedBox(height: 10.h),
            _buildSettingItem(
              context,
              leading: Icon(Icons.account_balance_outlined),
              title: 'Adjust GST(%)',
              trailing: Icon(Icons.add, size: 24.w),
              onTap: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => GSTAdjustmentDialog(),
                );
              },
            ),
            SizedBox(height: 10.h),
          ],
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
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          ListTile(
            leading: leading,
            title: Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            trailing: trailing,
            onTap: onTap,
          ),
          SizedBox(height: 10.h),
          Divider(height: 1.h),
        ],
      ),
    );
  }
}
