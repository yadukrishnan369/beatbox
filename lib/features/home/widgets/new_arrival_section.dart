import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/utils/new_arrival_utils.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/notifiers/new_arrival_notifier.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/widgets/shimmer_widgets/shimmer_new_arrival_banner.dart';

class NewArrivalSection extends StatefulWidget {
  const NewArrivalSection({super.key});

  @override
  State<NewArrivalSection> createState() => _NewArrivalSectionState();
}

class _NewArrivalSectionState extends State<NewArrivalSection> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  bool _isShimmering = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.90);
    NewArrivalUtils.loadNewArrivalProducts();

    if (isFirstTimeNewArrival.value) {
      _isShimmering = true;
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isShimmering = false;
            isFirstTimeNewArrival.value = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll(List<ProductModel> productList) {
    _timer?.cancel();
    if (productList.isEmpty) return;

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted || !_pageController.hasClients) return;

      if (_currentPage < productList.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isShimmering) {
      return const ShimmerProductBanner();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb =
            Responsive.isDesktop(context) || constraints.maxWidth > 600;

        return ValueListenableBuilder<List<ProductModel>>(
          valueListenable: newArrivalNotifier,
          builder: (context, productList, _) {
            _startAutoScroll(productList);

            if (productList.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New Arrivals',
                      style: TextStyle(
                        fontSize: isWeb ? 16 : 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Center(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.asset(
                              'assets/images/empty_image.png',
                              height: isWeb ? 180 : 130.h,
                              width: isWeb ? 500 : 350.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'No New Products Added Yet !',
                            style: TextStyle(
                              fontSize: isWeb ? 14 : 16.sp,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25.w,
                    vertical: 8.h,
                  ),
                  child: Text(
                    'New Arrivals',
                    style: TextStyle(
                      fontSize: isWeb ? 16 : 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                SizedBox(
                  height: isWeb ? 180 : 150.h,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isWeb ? 700 : double.infinity,
                      ),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: productList.length,
                        itemBuilder: (context, index) {
                          final product = productList[index];
                          final imageWidget =
                              kIsWeb
                                  ? (product.webImage1 != null
                                      ? Image.memory(
                                        base64Decode(product.webImage1!),
                                        fit: BoxFit.cover,
                                      )
                                      : const Icon(Icons.image))
                                  : (product.image1 != null
                                      ? Image.file(
                                        File(product.image1!),
                                        fit: BoxFit.cover,
                                      )
                                      : const Icon(Icons.image));

                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.productDetails,
                                arguments: product,
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 6.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: imageWidget,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
