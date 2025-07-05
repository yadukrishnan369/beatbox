import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/utils/backup_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackupConfirmationDialog {
  static void showFirstDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: Text(
              "Export All Sales?",
              style: TextStyle(color: AppColors.primary),
            ),
            content: Text(
              "This will generate PDF files for all your sales and store them in device storage.\n\nDo you want to continue?",
              style: TextStyle(color: AppColors.textPrimary, fontSize: 14.sp),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel", style: TextStyle(color: AppColors.error)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  showFinalDialog(context);
                },
                child: Text(
                  "Yes, Continue",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  static void showFinalDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: Text(
              "Are you sure?",
              style: TextStyle(color: AppColors.primary),
            ),
            content: Text(
              "This may take some time depending on number of sales.\nDo not close the app during export !",
              style: TextStyle(color: AppColors.textPrimary, fontSize: 14.sp),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("No", style: TextStyle(color: AppColors.error)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  await BackupUtils.generateAllSalesBackup(context);
                },
                child: Text(
                  "Yes, Export Now",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
