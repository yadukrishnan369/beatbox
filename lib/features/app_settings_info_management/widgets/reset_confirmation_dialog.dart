import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/app_settings_info_management/controller/reset_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetConfirmationDialog {
  static void showFirstDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: Text(
              "Reset App?",
              style: TextStyle(color: AppColors.primary),
            ),
            content: Text(
              "This will delete all your data including products, brands, categories and sales !\n\nDo you want to continue?",
              style: TextStyle(color: AppColors.textPrimary, fontSize: 14.sp),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: AppColors.success),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
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
              "Are you 100% sure?",
              style: TextStyle(color: AppColors.primary),
            ),
            content: Text(
              "This action is irreversible.\nAll stored app data will be erased permanently !",
              style: TextStyle(color: AppColors.textPrimary, fontSize: 14.sp),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("No", style: TextStyle(color: AppColors.success)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                onPressed: () async {
                  await ResetController.resetAppData(context); // reset call
                },
                child: Text(
                  "Yes, Reset Now",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
