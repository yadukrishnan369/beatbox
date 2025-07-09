import 'package:beatbox/features/product_management/widgets/category_list_tile_widget.dart';
import 'package:beatbox/features/product_management/widgets/brand_list_tile_widget.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/controller/brand_controller.dart';
import 'package:beatbox/features/product_management/controller/category_controller.dart';

class BrandAndCategoryScreen extends StatefulWidget {
  const BrandAndCategoryScreen({super.key});

  @override
  State<BrandAndCategoryScreen> createState() => _BrandAndCategoryScreenState();
}

class _BrandAndCategoryScreenState extends State<BrandAndCategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    CategoryController.initBox();
    BrandController.initBox();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildResponsiveView(Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb =
            Responsive.isDesktop(context) || constraints.maxWidth > 600;
        final double maxWidth = isWeb ? 600.w : double.infinity;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWeb ? 24.w : 0,
                vertical: isWeb ? 12.h : 0,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb =
            Responsive.isDesktop(context) || constraints.maxWidth > 600;

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            title: Text(
              'Brands & Categories',
              style: TextStyle(
                fontSize: isWeb ? 8.sp : 22.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(80.h),
              child: Container(
                color: AppColors.white,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.primary,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textDisabled,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.category, size: isWeb ? 10.sp : 24.sp),
                      text: 'Categories',
                    ),
                    Tab(
                      icon: Icon(
                        Icons.branding_watermark,
                        size: isWeb ? 10.sp : 24.sp,
                      ),
                      text: 'Brands',
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildResponsiveView(const CatogoryListTabTile()),
              _buildResponsiveView(const BrandListTabTile()),
            ],
          ),
        );
      },
    );
  }
}
