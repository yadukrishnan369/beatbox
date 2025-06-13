import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/constants/app_images.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/home/widgets/bottom_nav_bar.dart';
import 'package:beatbox/features/home/widgets/category_section.dart';
import 'package:beatbox/features/home/widgets/new_arrival_section.dart';
import 'package:beatbox/features/home/widgets/summary_card.dart';
import 'package:beatbox/features/stock_manage/ui/products_screen.dart';
import '../../../widgets/custom_search_bar.dart';

class HomeScreen extends StatelessWidget {
  final int selectedIndex;
  const HomeScreen({super.key, this.selectedIndex = 0});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                // logo and app profile
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w,
                    vertical: 10.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(AppImages.logo, width: 40.w, height: 40.h),
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/icons/home_profile.png',
                          width: 30.w,
                          height: 30.h,
                        ),
                      ),
                    ],
                  ),
                ),

                // summary Card section
                SummaryCard(),

                // custom search bar for navigate product screen
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

                // home screen scroll View
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      //call for showing home screen
                      children: const [NewArrivalSection(), CategorySection()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        //custom bottom navigation bar
        bottomNavigationBar: const CustomBottomNavBar(),
      ),
    );
  }
}
