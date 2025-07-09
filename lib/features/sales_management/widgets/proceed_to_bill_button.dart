import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/cart_update_notifier.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/widgets/Loading_widgets/show_loading_dialog.dart';

class ProceedToBillButton extends StatelessWidget {
  const ProceedToBillButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

    final double height = isWeb ? 65 : 55.h;
    final double fontSize = isWeb ? 18 : 22.sp;
    final double horizontalPadding =
        isWeb ? MediaQuery.of(context).size.width * 0.3 : 16.w;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 16.h,
      ),
      child: SizedBox(
        height: height,
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
              height: height,
              child: Text(
                'Proceed to Bill',
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.white,
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
