import 'dart:convert';
import 'dart:io';
import 'package:beatbox/features/product_management/widgets/product_detail_container_widget.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';

Uint8List? decodeBase64Image(String? base64String) {
  try {
    if (base64String == null || base64String.trim().isEmpty) return null;
    return base64Decode(base64String);
  } catch (e) {
    return null;
  }
}

class ProductDetailSection extends StatelessWidget {
  final ProductModel product;
  final PageController pageController;
  final int currentPage;
  final int quantity;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onQuantityChanged;

  const ProductDetailSection({
    super.key,
    required this.product,
    required this.pageController,
    required this.currentPage,
    required this.quantity,
    required this.onPageChanged,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);
    final double imageHeight = isWeb ? 300 : 250.h;
    final double fontTitle = isWeb ? 18 : 20.sp;
    final double fontText = isWeb ? 14 : 16.sp;
    final double iconSize = isWeb ? 22 : 28.sp;

    final List<dynamic> imageList =
        isWeb
            ? [
              product.webImage1,
              product.webImage2,
              product.webImage3,
            ].where((e) => e != null && e.isNotEmpty).toList()
            : [
              product.image1,
              product.image2,
              product.image3,
            ].where((e) => e != null && e.isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // image slider
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: imageHeight,
              margin: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 0),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: Colors.grey[200],
              ),
              child: PageView.builder(
                controller: pageController,
                itemCount: imageList.length,
                onPageChanged: onPageChanged,
                itemBuilder: (context, index) {
                  final img = imageList[index];
                  if (isWeb) {
                    final bytes = decodeBase64Image(img);
                    return bytes != null
                        ? Image.memory(bytes, fit: BoxFit.cover)
                        : const Center(
                          child: Icon(Icons.broken_image, size: 40),
                        );
                  } else {
                    return File(img!).existsSync()
                        ? Image.file(File(img!), fit: BoxFit.cover)
                        : const Center(
                          child: Icon(Icons.broken_image, size: 40),
                        );
                  }
                },
              ),
            ),
            if (imageList.length > 1)
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _arrowButton(
                        icon: Icons.arrow_back_ios,
                        onTap: () {
                          if (currentPage > 0) {
                            pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                      ),
                      _arrowButton(
                        icon: Icons.arrow_forward_ios,
                        onTap: () {
                          if (currentPage < imageList.length - 1) {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),

        SizedBox(height: 18.h),

        // product info section
        ProductDetailsContainerWidget(
          isWeb: isWeb,
          product: product,
          fontTitle: fontTitle,
          fontText: fontText,
          iconSize: iconSize,
          onQuantityChanged: onQuantityChanged,
          quantity: quantity,
        ),
      ],
    );
  }

  Widget _arrowButton({required IconData icon, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: kIsWeb ? 4.sp : 18),
        onPressed: onTap,
      ),
    );
  }
}
