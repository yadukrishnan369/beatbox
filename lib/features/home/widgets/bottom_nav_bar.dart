import 'package:beatbox/core/notifiers/cart_update_notifier.dart';
import 'package:beatbox/routes/app_routes.dart';
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
        Navigator.pushNamed(context, '/insight');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 75.h,
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.bottomNavColor,
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                BoxShadow(color: AppColors.primary, blurRadius: 10.r),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(context, Icons.home, "Home", 0),
                _buildNavItem(context, Icons.inventory, "Stock", 1),
                SizedBox(width: 60.w),
                _buildNavItem(context, Icons.shopping_bag, "Product", 3),
                _buildNavItem(context, Icons.bar_chart, "Insight", 4),
              ],
            ),
          ),
          // Cart Button with Badge Indicator
          Positioned(
            bottom: 15.5.h,
            child: GestureDetector(
              onTap: () => _onItemTapped(context, 2),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    height: 68.h,
                    width: 68.w,
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
                      size: 32.sp,
                    ),
                  ),

                  // badge of cart
                  Positioned(
                    right: 10,
                    top: 7,
                    child: ValueListenableBuilder(
                      valueListenable: cartUpdatedNotifier,
                      builder: (context, cartItems, _) {
                        if (cartItems.isEmpty) return SizedBox.shrink();

                        return Container(
                          padding: EdgeInsets.all(5.r),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${cartItems.length}',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14.sp,
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
  ) {
    return GestureDetector(
      onTap: () => _onItemTapped(context, index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.white, size: 24.sp),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
