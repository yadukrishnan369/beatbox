import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/cart_update_notifier.dart';
import 'package:beatbox/utils/cart_utils.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartClearButton extends StatelessWidget {
  const CartClearButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

    return Padding(
      padding: EdgeInsets.only(
        right: isWeb ? 10.w : 25.w,
        top: isWeb ? 12.h : 10.h,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.contColor,
          borderRadius: BorderRadius.circular(isWeb ? 60.r : 50.r),
        ),
        child: IconButton(
          icon: Icon(
            Icons.delete_forever_outlined,
            color: AppColors.error,
            size: isWeb ? 7.sp : 30.sp,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text(
                      'Confirmation',
                      style: TextStyle(color: AppColors.primary),
                    ),
                    content: Text(
                      'Are you sure you want to clear all this cart items?',
                      style: TextStyle(color: AppColors.textPrimary),
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
