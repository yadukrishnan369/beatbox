import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:beatbox/utils/sales_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class SummaryCard extends StatefulWidget {
  const SummaryCard({super.key});

  @override
  State<SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard> {
  double todaySales = 0.0;
  double todayProfit = 0.0;

  @override
  void initState() {
    super.initState();
    fetchTodaySummary();
  }

  Future<void> fetchTodaySummary() async {
    final data = await SalesUtils.getTodaySalesAndProfit();
    setState(() {
      todaySales = data['sales'] ?? 0.0;
      todayProfit = data['profit'] ?? 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String today = DateFormat('dd MMM yyyy').format(DateTime.now());

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      width: double.infinity,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.textPrimary,
                AppColors.blue,
              ],
            ),
          ),
          padding: EdgeInsets.all(16.w),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today\'s Sales',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      Text(
                        today,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  // Sales Amount
                  Text(
                    '₹${AmountFormatter.format(todaySales)}',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: 15.h),

                  // Profit
                  Text(
                    'Profit: ₹${AmountFormatter.format(todayProfit)}',
                    style: TextStyle(fontSize: 18.sp, color: AppColors.white),
                  ),
                ],
              ),

              // arrow icon
              Positioned(
                right: 0,
                top: 35.h,
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.white.withOpacity(0.2),
                    shape: const CircleBorder(),
                    padding: EdgeInsets.all(8.r),
                  ),
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 18.sp,
                    color: AppColors.white,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
