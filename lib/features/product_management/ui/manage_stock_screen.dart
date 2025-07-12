import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/widgets/add_brand_modal.dart';
import 'package:beatbox/features/product_management/widgets/add_category_modal.dart';
import 'package:beatbox/features/product_management/widgets/manage_stock_screen_body_content_widget.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StockManageScreen extends StatefulWidget {
  const StockManageScreen({super.key});

  @override
  State<StockManageScreen> createState() => _StockManageScreenState();
}

class _StockManageScreenState extends State<StockManageScreen> {
  int _selectedIndex = 0;

  static const List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.category, color: Colors.white),
      label: 'Add category',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.branding_watermark, color: Colors.white),
      label: 'Add Brand',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.warning_amber_rounded, color: Colors.white),
      label: 'Limited Stock',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.inventory_2, color: Colors.white),
      label: 'Current Stock',
    ),
  ];

  void _onNavBarTap(int index) {
    setState(() => _selectedIndex = index);

    if (index == 0) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AddCategoryModal(onSubmit: (name, image) {}),
      );
    } else if (index == 1) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AddBrandModal(onSubmit: (name, image) {}),
      );
    } else if (index == 2) {
      Navigator.pushNamed(context, AppRoutes.limitedStock);
    } else if (index == 3) {
      Navigator.pushNamed(context, AppRoutes.currentStock);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb =
            Responsive.isDesktop(context) || constraints.maxWidth > 600;

        final double cardWidth = isWeb ? 70.w : 160.w;
        final double cardHeight = isWeb ? 150.h : 120.h;
        final double appBarTitleSize = isWeb ? 8.sp : 22.sp;
        final double iconSize = isWeb ? 10.sp : 24.sp;
        final double actionTitleFontSize = isWeb ? 8.sp : 16.sp;
        final double actionIconSize = isWeb ? 8.sp : 24.sp;
        final double trailingIconSize = isWeb ? 8.sp : 18.sp;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 16.w,
            title: Text(
              'Manage Stock',
              style: TextStyle(
                fontSize: appBarTitleSize,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            actions: [
              IconButton(
                onPressed:
                    () => Navigator.pushNamed(context, AppRoutes.appSettings),
                icon: Icon(Icons.settings_outlined, size: iconSize),
                color: AppColors.textPrimary,
              ),
              SizedBox(width: 8.w),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            // manage stock screen body section widget
            child: ManageStockScreenBodyContent(
              isWeb: isWeb,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
              actionIconSize: actionIconSize,
              actionTitleFontSize: actionTitleFontSize,
              trailingIconSize: trailingIconSize,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: AppColors.bottomNavColor,
            items: bottomNavItems,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            onTap: _onNavBarTap,
            type: BottomNavigationBarType.fixed,
          ),
        );
      },
    );
  }
}
