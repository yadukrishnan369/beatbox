import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/app_settings_info_management/widgets/backup_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackupExportDataScreen extends StatelessWidget {
  const BackupExportDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          "Backup & Export Data",
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
            Icon(Icons.backup_rounded, color: AppColors.success, size: 40.w),
            SizedBox(height: 12.h),
            Text(
              "Create a backup copy of all your sales records !",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              "- Each sale will be exported as a separate PDF file.\n"
              "- You can view or share the generated PDFs later.\n"
              "- This helps in record-keeping and data safety.\n"
              "- Backups are saved in your internal storage.\n"
              "- You can also use them for external audits or prints.",
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textPrimary.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 20.h),
            _buildBackupItems("🧾 Sales invoices with full item details"),
            _buildBackupItems("👤 Customer info per invoice"),
            _buildBackupItems("📅 Date, time, order & invoice number"),
            _buildBackupItems("💰 Taxes, discounts, grand total"),
            _buildBackupItems("🖨️ Printable and shareable format"),
            _buildBackupItems("📂 Files stored as PDF in safe location"),
            SizedBox(height: 20.h),
            Text(
              " We recommend creating backups periodically to avoid data loss !",
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.warning,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            SizedBox(height: 35.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.download_for_offline_rounded),
                label: Text("Backup Now", style: TextStyle(fontSize: 16.sp)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: () async {
                  BackupConfirmationDialog.showFirstDialog(context);
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

Widget _buildBackupItems(String text) {
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
