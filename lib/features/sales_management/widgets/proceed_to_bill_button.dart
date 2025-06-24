import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/cart_update_notifier.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/widgets/Loading_widgets/show_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProceedToBillButton extends StatelessWidget {
  const ProceedToBillButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: SizedBox(
        height: 55.h,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            await showLoadingDialog(
              context,
              message: 'Process to bill',
              showSucess: false,
            );
            await Future.delayed(const Duration(milliseconds: 1000), () {
              Navigator.pushNamed(
                context,
                AppRoutes.billing,
                arguments: cartUpdatedNotifier.value,
              );
            });
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.r),
            ),
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.bottomNavColor,
                  const Color.fromARGB(255, 144, 166, 177),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(35.r),
            ),
            child: Container(
              alignment: Alignment.center,
              height: 55.h,
              child: Text(
                'Proceed to Bill',
                style: TextStyle(
                  fontSize: 22.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
