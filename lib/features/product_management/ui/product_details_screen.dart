import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:beatbox/utils/cart_utils.dart';
import 'package:beatbox/widgets/Loading_widgets/show_loading_dialog.dart';
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

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInitialized) return; // check already initialized

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is ProductModel) {
      product = args;
      imageList =
          [
            product.image1,
            product.image2,
            product.image3,
          ].where((img) => img != null).toList();

      _isInitialized = true;
    } else {
      Navigator.pop(context);
    }
  }

  void _incrementQty() {
    if (quantity < product.productQuantity) {
      setState(() {
        quantity++;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Only ${product.productQuantity} items available"),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _decrementQty() {
    setState(() {
      if (quantity > 1) quantity--;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Product Details',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
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
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'MRP ₹ ${AmountFormatter.format(product.salePrice)}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                    ),
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
      //add to cart buttom
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.w),
        child: SizedBox(
          height: 55.h,
          width: double.infinity,
          child: ElevatedButton(
            onPressed:
                product.productQuantity <= 0
                    ? null
                    : () async {
                      await showLoadingDialog(
                        context,
                        message: "Adding to cart...",
                        showSucess: true,
                      );
                      CartUtils.addProductToCart(product, quantity: quantity);
                      await Future.delayed(const Duration(milliseconds: 300));

                      Navigator.pop(context);
                    },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.r),
              ),
              backgroundColor:
                  product.productQuantity <= 0 ? AppColors.textDisabled : null,
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient:
                    product.productQuantity <= 0
                        ? null
                        : LinearGradient(
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
                  product.productQuantity <= 0 ? 'Out of Stock' : 'Add to Cart',
                  style: TextStyle(
                    fontSize: 22.sp,
                    color:
                        product.productQuantity <= 0
                            ? AppColors.error
                            : AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
