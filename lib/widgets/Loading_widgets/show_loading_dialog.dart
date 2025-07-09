import 'dart:async';
import 'package:beatbox/constants/app_images.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showLoadingDialog(
  BuildContext context, {
  String? message,
  bool? showSucess,
}) async {
  final completer = Completer<void>();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (_) => _AnimatedLoadingDialog(
          message: message,
          showSucess: showSucess,
          onFinish: () {
            if (!completer.isCompleted) {
              completer.complete();
            }
          },
        ),
  );

  return completer.future;
}

class _AnimatedLoadingDialog extends StatefulWidget {
  final String? message;
  final bool? showSucess;
  final VoidCallback? onFinish;

  const _AnimatedLoadingDialog({this.message, this.showSucess, this.onFinish});

  @override
  State<_AnimatedLoadingDialog> createState() => _AnimatedLoadingDialogState();
}

class _AnimatedLoadingDialogState extends State<_AnimatedLoadingDialog> {
  bool success = false;

  @override
  void initState() {
    super.initState();
    final bool shouldShowSuccess = widget.showSucess == true;

    Future.delayed(Duration(milliseconds: shouldShowSuccess ? 1000 : 800), () {
      if (widget.showSucess!) {
        setState(() {
          success = true;
        });

        Future.delayed(Duration(milliseconds: 1000), () {
          if (mounted) {
            Navigator.of(context).pop();
            widget.onFinish?.call();
          }
        });
      } else {
        if (mounted) {
          Navigator.of(context).pop();
          widget.onFinish?.call();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb = kIsWeb;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isWeb ? 20 : 16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(isWeb ? 30 : 20.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppImages.logo,
              width: isWeb ? 60 : 45.w,
              height: isWeb ? 60 : 45.h,
            ),
            SizedBox(width: isWeb ? 30 : 20.w),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder:
                  (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
              child:
                  success
                      ? Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: isWeb ? 35 : 30.w,
                      )
                      : SizedBox(
                        width: isWeb ? 30 : 24.w,
                        height: isWeb ? 30 : 24.w,
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
            ),
            SizedBox(width: isWeb ? 30 : 20.w),
            Text(
              success ? 'Success' : (widget.message ?? 'Loading...'),
              style: TextStyle(
                fontSize: isWeb ? 18 : 14.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
