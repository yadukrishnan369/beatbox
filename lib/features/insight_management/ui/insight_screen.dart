import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/insight_notifier.dart';
import 'package:beatbox/features/insight_management/widgets/chart_bar_widget.dart';
import 'package:beatbox/features/insight_management/widgets/filter_button_widget.dart';
import 'package:beatbox/features/insight_management/widgets/sale_table_widget.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:beatbox/utils/insight_utils.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:beatbox/widgets/shimmer_widgets/shimmer_insight_sale_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InsightScreen extends StatefulWidget {
  const InsightScreen({super.key});

  @override
  State<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen> {
  @override
  void initState() {
    super.initState();
    _initializeInsight();
  }

  Future<void> _initializeInsight() async {
    isInsightLoadingNotifier.value = true;

    await loadInsightSales();

    final today = DateTime.now();
    filterInsightSalesByRange(today, today);

    await Future.delayed(const Duration(milliseconds: 200));
    isInsightLoadingNotifier.value = false;
  }

  void _onRangeSelected(DateTime start, DateTime end) {
    isInsightLoadingNotifier.value = true;
    filterInsightSalesByRange(start, end);
    Future.delayed(const Duration(milliseconds: 300), () {
      isInsightLoadingNotifier.value = false;
    });
  }

  Map<String, double> _calculateTotals() {
    double totalSales = 0;
    double totalProfit = 0;

    for (var sale in insightSalesNotifier.value) {
      for (var item in sale.cartItems) {
        final qty = item.quantity;
        final sell = item.product.salePrice;
        final cost = item.product.purchaseRate;
        final discount = sale.discount;
        final profit = (sell - cost) * qty;

        totalSales += sell * qty;
        totalProfit += profit - discount;
      }
    }

    return {'sales': totalSales, 'profit': totalProfit};
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        title: Text(
          'Insights',
          style: TextStyle(
            fontSize: isWeb ? 8.sp : 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWeb =
              Responsive.isDesktop(context) || constraints.maxWidth > 600;
          final double maxWidth = isWeb ? 900 : double.infinity;
          final double horizontalPadding = isWeb ? 32.w : 16.w;

          return ValueListenableBuilder<bool>(
            valueListenable: isInsightLoadingNotifier,
            builder: (context, isLoading, _) {
              return SingleChildScrollView(
                child: Center(
                  child: Container(
                    width: maxWidth,
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // chart
                        ValueListenableBuilder(
                          valueListenable: insightSalesNotifier,
                          builder: (context, _, __) {
                            return const BarChartWidget();
                          },
                        ),

                        // total sales & profit
                        ValueListenableBuilder(
                          valueListenable: insightSalesNotifier,
                          builder: (context, _, __) {
                            final totals = _calculateTotals();
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Sales: ₹ ${AmountFormatter.format(totals['sales']!)}",
                                    style: TextStyle(
                                      fontSize: isWeb ? 18 : 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.blue,
                                    ),
                                  ),
                                  Text(
                                    "Profit: ₹ ${AmountFormatter.format(totals['profit']!)}",
                                    style: TextStyle(
                                      fontSize: isWeb ? 18 : 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.success,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 10.h),

                        // filter buttons
                        FilterButtons(onFilterSelected: _onRangeSelected),

                        SizedBox(height: 10.h),

                        // table or shimmer section
                        Container(
                          constraints: BoxConstraints(
                            minHeight: 300.h,
                            maxHeight: isWeb ? 500.h : 400.h,
                          ),
                          child:
                              isLoading
                                  ? Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isWeb ? 0 : 16.0,
                                    ),
                                    child: const TableShimmerWidget(),
                                  )
                                  : const SalesTable(),
                        ),

                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
