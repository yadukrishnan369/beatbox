import 'package:beatbox/constants/app_images.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/home/widgets/bottom_nav_bar.dart';
import 'package:beatbox/features/home/widgets/category_section.dart';
import 'package:beatbox/features/home/widgets/new_arrival_section.dart';
import 'package:beatbox/features/home/widgets/summary_card.dart';
import 'package:beatbox/features/product_management/ui/products_screen.dart';
import 'package:beatbox/widgets/custom_search_bar.dart';
import 'package:beatbox/features/home/widgets/custom_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeWebView extends StatelessWidget {
  final int selectedIndex;
  const HomeWebView({super.key, this.selectedIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder:
            (context) => Center(
              child: Container(
                width: 1200.w, // max width for web view
                padding: EdgeInsets.all(16.0.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // profile icon
                          GestureDetector(
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                            child: Container(
                              width: 40.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              padding: EdgeInsets.all(4.r),
                              child: Image.asset(
                                'assets/icons/home_profile.png',
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),

                          // app logo
                          Image.asset(
                            AppImages.logo,
                            width: 50.w,
                            height: 50.h,
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),
                      const SummaryCard(),
                      SizedBox(height: 16.h),

                      // search bar
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => const ProductsScreen(
                                    shouldFocusSearch: true,
                                  ),
                            ),
                          );
                        },
                        child: const AbsorbPointer(
                          child: CustomSearchBar(
                            hintText: "Search products...",
                            onFilterTap: null,
                            showFilterIcon: false,
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),
                      const NewArrivalSection(),
                      SizedBox(height: 20.h),
                      const CategorySection(),
                      SizedBox(height: 90.h),
                    ],
                  ),
                ),
              ),
            ),
      ),
      drawer: const CustomDrawer(), // drawer
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
