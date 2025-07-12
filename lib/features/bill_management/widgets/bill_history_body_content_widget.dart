import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/bill_notifier.dart';
import 'package:beatbox/features/bill_management/widgets/bill_item_card_widget.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:beatbox/widgets/empty_placeholder.dart';
import 'package:beatbox/widgets/shimmer_widgets/shimmer_bill_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillHistoryBodyContent extends StatelessWidget {
  const BillHistoryBodyContent({super.key, required this.isWeb});

  final bool isWeb;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder<bool>(
        valueListenable: isBillLoadingNotifier,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: isWeb ? 12.w : 16.w),
              itemCount: 6,
              separatorBuilder: (_, __) => SizedBox(height: isWeb ? 8.h : 12.h),
              itemBuilder: (_, __) => const ShimmerBillTile(),
            );
          }

          return ValueListenableBuilder<List<SalesModel>>(
            valueListenable: filteredBillNotifier,
            builder: (context, bills, _) {
              return ValueListenableBuilder<List<SalesModel>>(
                valueListenable: allBillNotifier,
                builder: (context, allBills, _) {
                  if (allBills.isEmpty) {
                    return const EmptyPlaceholder(
                      imagePath: 'assets/images/empty_product.png',
                      message:
                          'No bills found yet.\nOnce you create a sale, the bill will appear here !',
                    );
                  }

                  if (bills.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: isWeb ? 40.sp : 60.sp,
                            color: AppColors.primary,
                          ),
                          SizedBox(height: isWeb ? 12.h : 16.h),
                          Text(
                            "No matching bill found",
                            style: TextStyle(
                              fontSize: isWeb ? 14.sp : 18.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWeb ? 12.w : 16.w,
                    ),
                    itemCount: bills.length,
                    itemBuilder: (context, index) {
                      final bill = bills[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: isWeb ? 8.h : 12.h),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.billDetails,
                              arguments: bill,
                            );
                          },
                          child: BillItemCard(bill: bill),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
