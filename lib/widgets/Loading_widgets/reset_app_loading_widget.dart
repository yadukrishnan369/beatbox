import 'dart:async';
import 'package:beatbox/constants/app_images.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showResetAppLoadingDialog(BuildContext context) async {
  final completer = Completer<void>();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (_) => _ResetAppLoadingDialog(
          onFinished: () {
            if (!completer.isCompleted) completer.complete();
          },
        ),
  );

  return completer.future;
}

class _ResetAppLoadingDialog extends StatefulWidget {
  final VoidCallback onFinished;

  const _ResetAppLoadingDialog({required this.onFinished});

  @override
  State<_ResetAppLoadingDialog> createState() => _ResetAppLoadingDialogState();
}

class _ResetAppLoadingDialogState extends State<_ResetAppLoadingDialog> {
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
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppImages.logo, height: 85.h),
            SizedBox(height: 30.h),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder:
                  (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
              child:
                  _showSuccess
                      ? Icon(
                        Icons.check_circle_rounded,
                        size: 50.w,
                        color: AppColors.success,
                        key: ValueKey('success'),
                      )
                      : SizedBox(
                        width: 40.w,
                        height: 40.w,
                        key: ValueKey('loading'),
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 5.w,
                        ),
                      ),
            ),
            SizedBox(height: 30.h),
            Text(
              _showSuccess ? "App data reset successfully" : "Resetting app...",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
