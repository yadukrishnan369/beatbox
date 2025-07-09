import 'package:beatbox/core/notifiers/cart_update_notifier.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.stock);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.cart);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.products);
        break;
      case 4:
        Navigator.pushNamed(context, AppRoutes.insight);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb =
        Responsive.isDesktop(context) ||
        MediaQuery.of(context).size.width > 600;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isWeb ? 16.h : 12.h,
        horizontal: isWeb ? 24.w : 16.w,
      ),
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: isWeb ? 80.h : 75.h,
            decoration: BoxDecoration(
              color: AppColors.bottomNavColor,
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [BoxShadow(color: AppColors.primary, blurRadius: 2.r)],
            ),
            padding: EdgeInsets.symmetric(horizontal: isWeb ? 24.w : 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(context, Icons.home, "Home", 0, isWeb),
                _buildNavItem(context, Icons.inventory, "Stock", 1, isWeb),
                SizedBox(width: isWeb ? 80.w : 60.w),
                _buildNavItem(context, Icons.shopping_bag, "Product", 3, isWeb),
                _buildNavItem(context, Icons.bar_chart, "Insight", 4, isWeb),
              ],
            ),
          ),

          // bart button
          Positioned(
            bottom: isWeb ? 3.h : 3.3.h,
            child: GestureDetector(
              onTap: () => _onItemTapped(context, 2),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    height: isWeb ? 75.h : 68.h,
                    width: isWeb ? 75.w : 68.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                      border: Border.all(color: AppColors.primary, width: 3.w),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textPrimary,
                          blurRadius: 6.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.shopping_cart,
                      color: AppColors.textPrimary,
                      size: isWeb ? 10.sp : 32.sp,
                    ),
                  ),

                  // cart badge
                  Positioned(
                    right: isWeb ? 26.w : 10.w,
                    top: isWeb ? -10.h : 7.h,
                    child: ValueListenableBuilder(
                      valueListenable: cartUpdatedNotifier,
                      builder: (context, cartItems, _) {
                        if (cartItems.isEmpty) return SizedBox.shrink();
                        return Container(
                          padding: EdgeInsets.all(isWeb ? 10.r : 5.r),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${cartItems.length}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isWeb ? 7.sp : 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
    bool isWeb,
  ) {
    return GestureDetector(
      onTap: () => _onItemTapped(context, index),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isWeb ? 12.w : 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: isWeb ? 10.sp : 24.sp),
            SizedBox(height: isWeb ? 0.h : 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: isWeb ? 4.sp : 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
