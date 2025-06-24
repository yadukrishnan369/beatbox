import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/cart_update_notifier.dart';
import 'package:beatbox/utils/cart_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartClearButton extends StatelessWidget {
  const CartClearButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 25.w, top: 10.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.contColor,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: IconButton(
          icon: Icon(
            Icons.delete_forever_outlined,
            color: AppColors.error,
            size: 30.sp,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    backgroundColor: AppColors.white,
                    title: Text(
                      'Confirmation',
                      style: TextStyle(color: AppColors.primary),
                    ),
                    content: const Text(
                      'Are you sure you want to clear all this cart items?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          CartUtils.clearEntireCart();
                          cartUpdatedNotifier.value = [];
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Clear All',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
            );
          },
        ),
      ),
    );
  }
}
