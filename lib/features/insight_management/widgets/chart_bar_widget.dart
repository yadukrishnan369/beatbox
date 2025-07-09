import 'package:beatbox/utils/insight_utils.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/insight_notifier.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb = Responsive.isDesktop(context);
        final double outerPadding = isWeb ? 24.w : 16.w;
        final double cardPadding = isWeb ? 5.w : 16.w;
        final double chartHeight = isWeb ? 400.h : 260.h;
        final double labelFontSize = isWeb ? 12.0 : 10.sp;
        final double legendFontSize = isWeb ? 13.0 : 12.sp;
        final double infoFontSize = isWeb ? 16.0 : 14.sp;

        return ValueListenableBuilder(
          valueListenable: insightSalesNotifier,
          builder: (context, _, __) {
            final chartData = getInsightChartData();
            final sortedDates = chartData.keys.toList()..sort();
            final maxY = _getMaxY(chartData);

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: outerPadding,
                vertical: 12.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(cardPadding),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.white, AppColors.contColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(isWeb ? 20.r : 16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cardColor.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    height: chartHeight,
                    child: BarChart(
                      BarChartData(
                        maxY: maxY,
                        minY: 0,
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final label = rodIndex == 0 ? "Sales" : "Profit";
                              return BarTooltipItem(
                                '$label\n\u20B9${rod.toY.toStringAsFixed(2)}',
                                TextStyle(
                                  fontSize: labelFontSize,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      rodIndex == 0
                                          ? AppColors.blue
                                          : AppColors.success,
                                ),
                              );
                            },
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          drawHorizontalLine: true,
                          horizontalInterval: _getInterval(maxY),
                          verticalInterval: 1,
                          getDrawingHorizontalLine:
                              (value) => FlLine(
                                color: AppColors.textDisabled.withOpacity(0.3),
                                strokeWidth: 1,
                                dashArray: [5, 4],
                              ),
                          getDrawingVerticalLine:
                              (value) => FlLine(
                                color: AppColors.cardColor.withOpacity(0.2),
                                strokeWidth: 1,
                                dashArray: [5, 5],
                              ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: const Border(
                            bottom: BorderSide(
                              color: Colors.black26,
                              width: 1.5,
                            ),
                            left: BorderSide(color: Colors.black26, width: 1.5),
                            top: BorderSide(color: Colors.transparent),
                            right: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 36,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index < 0 || index >= sortedDates.length) {
                                  return const SizedBox.shrink();
                                }
                                final date = sortedDates[index];
                                return Padding(
                                  padding: EdgeInsets.only(top: 8.h),
                                  child: Text(
                                    DateFormat('MMM d').format(date),
                                    style: TextStyle(
                                      fontSize: labelFontSize,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 48,
                              interval: _getInterval(maxY),
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '₹${value.toInt()}',
                                  style: TextStyle(
                                    fontSize: labelFontSize,
                                    color: AppColors.textPrimary,
                                  ),
                                );
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        barGroups: List.generate(sortedDates.length, (index) {
                          final date = sortedDates[index];
                          final sales = chartData[date]!['sales'] ?? 0;
                          final profit = chartData[date]!['profit'] ?? 0;

                          return BarChartGroupData(
                            x: index,
                            barsSpace: 8,
                            barRods: [
                              BarChartRodData(
                                toY: sales,
                                width: isWeb ? 3.w : 10.w,
                                borderRadius: BorderRadius.circular(6.r),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade200,
                                    Colors.blue.shade600,
                                  ],
                                ),
                              ),
                              BarChartRodData(
                                toY: profit,
                                width: isWeb ? 3.w : 10.w,
                                borderRadius: BorderRadius.circular(6.r),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.green.shade300,
                                    Colors.green.shade800,
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeOutQuart,
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // sales profits info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSalesProfitInfo(
                        color: AppColors.blue,
                        label: 'Sales',
                        fontSize: legendFontSize,
                      ),
                      SizedBox(width: 20.w),
                      _buildSalesProfitInfo(
                        color: AppColors.success,
                        label: 'Profit',
                        fontSize: legendFontSize,
                      ),
                    ],
                  ),

                  if (chartData.isEmpty) ...[
                    SizedBox(height: 20.h),
                    Center(
                      child: Text(
                        "No data available for selected range !",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: infoFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSalesProfitInfo({
    required Color color,
    required String label,
    required double fontSize,
  }) {
    return Row(
      children: [
        Container(
          width: kIsWeb ? 6.w : 12.w,
          height: kIsWeb ? 6.w : 12.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(fontSize: fontSize, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  double _getMaxY(Map<DateTime, Map<String, double>> chartData) {
    double maxY = 0;
    for (var data in chartData.values) {
      maxY = [
        maxY,
        data['sales'] ?? 0,
        data['profit'] ?? 0,
      ].reduce((a, b) => a > b ? a : b);
    }
    return (maxY + 500).ceilToDouble();
  }

  double _getInterval(double maxY) {
    if (maxY <= 1000) return 200;
    if (maxY <= 5000) return 1000;
    return (maxY / 4).ceilToDouble();
  }
}
