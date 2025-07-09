import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/app_settings_info_management/widgets/backup_confirmation_dialog.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackupExportDataScreen extends StatelessWidget {
  const BackupExportDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          "Backup & Export Data",
          style: TextStyle(
            fontSize: isWeb ? 24 : 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(isWeb ? 32 : 20.w),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWeb ? 700 : double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.backup_rounded,
                  color: AppColors.success,
                  size: isWeb ? 48 : 40.w,
                ),
                SizedBox(height: isWeb ? 16 : 12.h),
                Text(
                  "Create a backup copy of all your sales records !",
                  style: TextStyle(
                    fontSize: isWeb ? 20 : 18.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: isWeb ? 18 : 14.h),
                Text(
                  "- Each sale will be exported as a separate PDF file.\n"
                  "- You can view or share the generated PDFs later.\n"
                  "- This helps in record-keeping and data safety.\n"
                  "- Backups are saved in your internal storage.\n"
                  "- You can also use them for external audits or prints.",
                  style: TextStyle(
                    fontSize: isWeb ? 15 : 14.sp,
                    color: AppColors.textPrimary.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: isWeb ? 24 : 20.h),
                _buildBackupItems(
                  "🧾 Sales invoices with full item details",
                  isWeb,
                ),
                _buildBackupItems("👤 Customer info per invoice", isWeb),
                _buildBackupItems(
                  "📅 Date, time, order & invoice number",
                  isWeb,
                ),
                _buildBackupItems("💰 Taxes, discounts, grand total", isWeb),
                _buildBackupItems("🖨️ Printable and shareable format", isWeb),
                _buildBackupItems(
                  "📂 Files stored as PDF in safe location",
                  isWeb,
                ),
                SizedBox(height: isWeb ? 24 : 20.h),
                Text(
                  " We recommend creating backups periodically to avoid data loss !",
                  style: TextStyle(
                    fontSize: isWeb ? 15 : 14.sp,
                    color: AppColors.warning,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: isWeb ? 40 : 35.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.download_for_offline_rounded,
                      size: isWeb ? 24 : null,
                    ),
                    label: Text(
                      "Backup Now",
                      style: TextStyle(fontSize: isWeb ? 18 : 16.sp),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: isWeb ? 16 : 14.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isWeb ? 14 : 12.r),
                      ),
                    ),
                    onPressed: () async {
                      BackupConfirmationDialog.showFirstDialog(context);
                    },
                  ),
                ),
                SizedBox(height: isWeb ? 24 : 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackupItems(String text, bool isWeb) {
    return Padding(
      padding: EdgeInsets.only(bottom: isWeb ? 10 : 8.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isWeb ? 15.5 : 14.5.sp,
          color: AppColors.textPrimary.withOpacity(0.9),
        ),
      ),
    );
  }
}
