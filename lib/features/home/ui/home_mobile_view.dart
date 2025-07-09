import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/constants/app_images.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/home/widgets/summary_card.dart';
import 'package:beatbox/features/home/widgets/category_section.dart';
import 'package:beatbox/features/home/widgets/new_arrival_section.dart';
import 'package:beatbox/widgets/custom_search_bar.dart';
import 'package:beatbox/features/home/widgets/custom_drawer_widget.dart';
import 'package:beatbox/features/home/widgets/bottom_nav_bar.dart';
import 'package:beatbox/features/product_management/ui/products_screen.dart';

class HomeMobileView extends StatelessWidget {
  final int selectedIndex;
  HomeMobileView({super.key, this.selectedIndex = 0});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const CustomDrawer(),
        bottomNavigationBar: const CustomBottomNavBar(),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primary, AppColors.white],
              stops: [0.0, 0.4],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w,
                    vertical: 10.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        icon: Image.asset(
                          'assets/icons/home_profile.png',
                          width: 30.w,
                          height: 30.h,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Image.asset(AppImages.logo, width: 40.w, height: 40.h),
                    ],
                  ),
                ),

                const SummaryCard(),

                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                const ProductsScreen(shouldFocusSearch: true),
                      ),
                    );
                  },
                  child: AbsorbPointer(
                    child: CustomSearchBar(
                      hintText: 'Search products...',
                      onFilterTap: null,
                      showFilterIcon: false,
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: const [NewArrivalSection(), CategorySection()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
