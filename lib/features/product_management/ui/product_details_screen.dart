import 'package:beatbox/features/product_management/widgets/add_to_cart_button_widget.dart';
import 'package:beatbox/features/product_management/widgets/product_detail_section_widget.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/utils/cart_utils.dart';
import 'package:beatbox/widgets/Loading_widgets/show_loading_dialog.dart';

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
    if (_isInitialized) return;

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

  Future<void> _addToCart() async {
    await showLoadingDialog(
      context,
      message: "Adding to cart...",
      showSucess: true,
    );
    CartUtils.addProductToCart(product, quantity: quantity);
    await Future.delayed(const Duration(milliseconds: 300));
    Navigator.pop(context);
  }

  void _updateQuantity(int newQuantity) {
    setState(() => quantity = newQuantity);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Product Details',
          style: TextStyle(
            fontSize: isWeb ? 20 : 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isWeb ? 1000 : double.infinity),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWeb ? 24 : 16.w,
              vertical: 16.h,
            ),
            child: ProductDetailSection(
              product: product,
              pageController: _pageController,
              currentPage: _currentPage,
              quantity: quantity,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              onQuantityChanged: _updateQuantity,
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isWeb ? 24 : 8.w,
          vertical: isWeb ? 8 : 10.w,
        ),
        child: AddToCartSection(
          product: product,
          quantity: quantity,
          onAddToCart: _addToCart,
        ),
      ),
    );
  }
}
