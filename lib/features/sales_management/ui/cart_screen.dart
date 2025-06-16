import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/sales_management/controller/cart_controller.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/utils/cart_utils.dart';
import 'package:beatbox/widgets/empty_placeholder.dart';
import 'package:beatbox/widgets/show_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:beatbox/core/notifiers/cart_update_notifier.dart';
import 'package:beatbox/features/sales_management/model/cart_item_model.dart';
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
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Cart',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          if (cartUpdatedNotifier.value.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(right: 25.w, top: 10.h),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.contColor,
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.delete_forever_outlined,
                    color: AppColors.error,
                    size: 30.sp,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Confirmation'),
                          content: Text(
                            'Are you sure you want to clear all this cart items?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                CartUtils.clearEntireCart();
                                Navigator.pop(context);
                              },
                              child: Text('Yes'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 30.h),
        child: ValueListenableBuilder<List<CartItemModel>>(
          valueListenable: cartUpdatedNotifier,
          builder: (context, cartItems, child) {
            if (cartItems.isEmpty) {
              return EmptyPlaceholder(
                imagePath: 'assets/images/empty_cart.webp',
                message: 'Your cart is empty!',
                imageSize: 300.w,
                actionText: 'Explore Product',
                actionIcon: Icons.shopping_cart,
                onActionTap: () {
                  Navigator.pushNamed(context, AppRoutes.products);
                },
              );
            }

            final totalPrice = CartUtils.getTotalCartPrice();
            final totalItems = CartUtils.getTotalCartQuantity();

            return Column(
              children: [
                // cart Items List
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: _buildCartItem(cartItems),
                  ),
                ),
                SizedBox(height: 15.h),

                // bottom Section with Total
                Padding(
                  padding: EdgeInsets.only(
                    top: 0.h,
                    bottom: 0.h,
                    right: 18.w,
                    left: 18.w,
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                    decoration: BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Total ($totalItems items)',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '₹ ${totalPrice.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar:
          cartUpdatedNotifier.value.isNotEmpty
              ? Padding(
                padding: EdgeInsets.all(16.w),
                child: SizedBox(
                  height: 55.h,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await showLoadingDialog(
                        context,
                        message: 'Process to bill',
                        showSucess: false,
                      );
                      await Future.delayed(Duration(milliseconds: 1000), () {
                        Navigator.pushNamed(context, AppRoutes.billing);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
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
                          'Proceed to Bill',
                          style: TextStyle(
                            fontSize: 22.sp,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              : null,
    );
  }

  ListView _buildCartItem(List<CartItemModel> cartItems) {
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.contColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              // Product Image
              Container(
                width: 70.w,
                height: 70.h,
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child:
                    item.product.image1 != null &&
                            item.product.image1!.isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.file(
                            File(item.product.image1!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.headphones,
                                color: AppColors.primary,
                                size: 30.sp,
                              );
                            },
                          ),
                        )
                        : Icon(
                          Icons.headphones,
                          color: AppColors.primary,
                          size: 30.sp,
                        ),
              ),
              SizedBox(width: 12.w),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.productName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      item.product.productCategory,
                      style: TextStyle(
                        color: AppColors.textDisabled,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'MRP ₹ ${item.product.salePrice.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                        color: AppColors.error,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Total ₹ ${item.totalPrice.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),

              // quantity controls and remove button
              Column(
                children: [
                  // quantity controls
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.bottomNavColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // decrease quantity logic
                            if (item.quantity > 1) {
                              CartUtils.changeQuantity(
                                item.product,
                                item.quantity - 1,
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.r),
                            child: Icon(
                              Icons.remove,
                              color: AppColors.white,
                              size: 16.sp,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          child: Text(
                            '${item.quantity}',
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // increase quantity logic
                            CartUtils.changeQuantity(
                              item.product,
                              item.quantity + 1,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.r),
                            child: Icon(
                              Icons.add,
                              color: AppColors.white,
                              size: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // remove Button
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Confirmation'),
                            content: Text(
                              'Are you sure you want to remove this item?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  CartUtils.removeProductFromCart(item.product);
                                  Navigator.pop(context);
                                },
                                child: Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'Remove',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
