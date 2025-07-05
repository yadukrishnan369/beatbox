import 'dart:async';
import 'package:beatbox/constants/app_images.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showBackupLoadingDialog(BuildContext context) async {
  final completer = Completer<void>();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (_) => _BackupLoadingDialog(
          onFinished: () {
            if (!completer.isCompleted) completer.complete();
          },
        ),
  );

  return completer.future;
}

class _BackupLoadingDialog extends StatefulWidget {
  final VoidCallback onFinished;

  const _BackupLoadingDialog({required this.onFinished});

  @override
  State<_BackupLoadingDialog> createState() => _BackupLoadingDialogState();
}

class _BackupLoadingDialogState extends State<_BackupLoadingDialog> {
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 7000), () {
      if (mounted) {
        setState(() => _showSuccess = true);

        Future.delayed(const Duration(milliseconds: 1200), () {
          if (mounted) {
            Navigator.of(context).pop();
            widget.onFinished();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppImages.logo, height: 65.h),
            SizedBox(height: 20.h),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder:
                  (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
              child:
                  _showSuccess
                      ? Icon(
                        Icons.check_circle_rounded,
                        size: 42.w,
                        color: AppColors.success,
                        key: ValueKey('success'),
                      )
                      : SizedBox(
                        width: 35.w,
                        height: 35.w,
                        key: ValueKey('loading'),
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 5.w,
                        ),
                      ),
            ),
            SizedBox(height: 20.h),
            Text(
              _showSuccess
                  ? "Sales data backed up successfully"
                  : "Exporting all sales data...",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
