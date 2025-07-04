import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/app_settings_info_management/widgets/reset_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetAppDataScreen extends StatelessWidget {
  const ResetAppDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          "Reset App Data",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.error,
              size: 40.w,
            ),
            SizedBox(height: 12.h),
            Text(
              "Resetting your app will permanently delete all your data !",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              "- All products, categories, brands, sales history will be removed.\n"
              "- This action cannot be undone.\n"
              "- Please make a backup before resetting (if needed).\n\n"
              "- App settings will be cleared.\n"
              "- Stock quantities and customer records will also be removed.\n"
              "- You will return to a fresh app state as if newly installed.",
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textPrimary.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 20.h),
            _buildResetItems("🧾 All sales history"),
            _buildResetItems("📦 All products and stock"),
            _buildResetItems("🏷️ All categories and brands"),
            _buildResetItems("🛒 Your current cart items"),
            _buildResetItems("📈 GST settings and adjustments"),
            _buildResetItems("⚙️ Any app preferences or settings"),
            SizedBox(height: 20.h),
            Text(
              " We highly recommend exporting or backing up your data before performing this action !",
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.warning,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            SizedBox(height: 30.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.delete_forever_rounded),
                label: Text("Reset Now", style: TextStyle(fontSize: 16.sp)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: () {
                  ResetConfirmationDialog.showFirstDialog(context);
                },
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

Widget _buildResetItems(String text) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 14.5.sp,
        color: AppColors.textPrimary.withOpacity(0.9),
      ),
    ),
  );
}
