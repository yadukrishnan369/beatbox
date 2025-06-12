import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/stock_manage/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late ProductModel product;
  late List<String?> imageList;
  int _currentPage = 0;
  int quantity = 1;
  final PageController _pageController = PageController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is ProductModel) {
      product = args;
      imageList =
          [
            product.image1,
            product.image2,
            product.image3,
          ].where((img) => img != null).toList();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _incrementQty() => setState(() => quantity++);
  void _decrementQty() => setState(() {
    if (quantity > 1) quantity--;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details', style: TextStyle(fontSize: 20.sp))),
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.w),
        child: SizedBox(
          height: 55.h,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
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
                height: 55.h,
                child: Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: imageList.length,
                    onPageChanged:
                        (index) => setState(() => _currentPage = index),
                    itemBuilder: (context, index) {
                      final path = imageList[index];
                      return path != null
                          ? Image.file(File(path), fit: BoxFit.cover)
                          : const Center(child: Icon(Icons.image));
                    },
                  ),
                ),
                Positioned(
                  left: 10.w,
                  top: 150.h,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.white,
                      size: 40.sp,
                    ),
                    onPressed: () {
                      if (_currentPage > 0) {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                  ),
                ),
                Positioned(
                  right: 10.w,
                  top: 150.h,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.white,
                      size: 40.sp,
                    ),
                    onPressed: () {
                      if (_currentPage < imageList.length - 1) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(25.w),
              decoration: BoxDecoration(
                color: AppColors.contColor,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '${product.productCategory} | ${product.productBrand} | code-${product.productCode}',
                    style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'MRP ₹ ${product.salePrice}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    product.description,
                    style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.remove,
                          size: 30.sp,
                          color: AppColors.textPrimary,
                        ),
                        onPressed: _decrementQty,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        '$quantity',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          size: 28.sp,
                          color: AppColors.textPrimary,
                        ),
                        onPressed: _incrementQty,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
