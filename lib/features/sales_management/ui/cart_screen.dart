import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/cart_update_notifier.dart';
import 'package:beatbox/features/sales_management/controller/cart_controller.dart';
import 'package:beatbox/features/sales_management/model/cart_item_model.dart';
import 'package:beatbox/features/sales_management/widgets/cart_clear_button.dart';
import 'package:beatbox/features/sales_management/widgets/cart_product_list_section.dart';
import 'package:beatbox/features/sales_management/widgets/proceed_to_bill_button.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:beatbox/utils/cart_utils.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:beatbox/widgets/empty_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    cartUpdatedNotifier.value = CartController.getCartItems();
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

    return ValueListenableBuilder<List<CartItemModel>>(
      valueListenable: cartUpdatedNotifier,
      builder: (context, cartItems, _) {
        final isCartNotEmpty = cartItems.isNotEmpty;
        final totalPrice = CartUtils.getTotalCartPrice();
        final totalItems = CartUtils.getTotalCartQuantity();

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            title: Text(
              'Cart',
              style: TextStyle(
                fontSize: isWeb ? 10.sp : 22.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            actions: isCartNotEmpty ? [CartClearButton()] : [],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              double maxWidth = isWeb ? 700 : double.infinity;

              return Padding(
                padding: EdgeInsets.only(top: 30.h),
                child:
                    isCartNotEmpty
                        ? Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: maxWidth),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                    ),
                                    child: CartProductList(
                                      cartItems: cartItems,
                                    ),
                                  ),
                                ),
                                SizedBox(height: isWeb ? 5.h : 15.h),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 18.w,
                                    vertical: 10.h,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                      horizontal: 10.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.cardColor,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total ($totalItems items)',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: isWeb ? 4.sp : 16.sp,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          '₹ ${AmountFormatter.format(totalPrice)}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: isWeb ? 4.sp : 18.sp,
                                            color: AppColors.success,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        : EmptyPlaceholder(
                          imagePath: 'assets/images/empty_cart.png',
                          message:
                              'Your cart is empty.\nAdd items to start billing !',
                          imageSize: 300.w,
                          actionText: 'Explore Product',
                          actionIcon: Icons.shopping_cart,
                          onActionTap: () {
                            Navigator.pushNamed(context, AppRoutes.products);
                          },
                        ),
              );
            },
          ),
          bottomNavigationBar:
              isCartNotEmpty ? const ProceedToBillButton() : null,
        );
      },
    );
  }
}
