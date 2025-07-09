import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/utils/amount_formatter.dart';
import 'package:beatbox/utils/insight_utils.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalesTable extends StatelessWidget {
  const SalesTable({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);
    final tableData = getInsightTableData();

    if (tableData.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: isWeb ? 10 : 40.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.bar_chart_outlined,
                size: isWeb ? 70 : 50.sp,
                color: AppColors.primary.withOpacity(0.6),
              ),
              SizedBox(height: isWeb ? 16 : 8.h),
              Text(
                "No sales records found !",
                style: TextStyle(
                  fontSize: isWeb ? 18 : 20.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(isWeb ? 24 : 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderRow(),
          Divider(thickness: 1, color: AppColors.cardColor),
          SizedBox(height: isWeb ? 12 : 8.h),
          Expanded(
            child: ListView.separated(
              itemCount: tableData.length,
              separatorBuilder:
                  (_, __) => Divider(color: AppColors.cardColor, height: 1),
              itemBuilder: (context, index) {
                final item = tableData[index];
                return Container(
                  padding: EdgeInsets.symmetric(
                    vertical: isWeb ? 12 : 10.h,
                    horizontal: isWeb ? 16 : 8.w,
                  ),
                  decoration: BoxDecoration(
                    color:
                        index % 2 == 0 ? AppColors.cardColor : AppColors.white,
                    borderRadius: BorderRadius.circular(isWeb ? 10 : 6.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          item['product'],
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: isWeb ? 13 : 12.sp,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            "${item['qty']}",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: isWeb ? 13 : 12.sp,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            "₹ ${AmountFormatter.format(item['total'])}",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: isWeb ? 13 : 12.sp,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            "₹ ${AmountFormatter.format(item['profit'])}",
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: isWeb ? 13 : 12.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: kIsWeb ? 12 : 10.h,
        horizontal: kIsWeb ? 16 : 8.w,
      ),
      decoration: BoxDecoration(
        color: AppColors.contColor,
        borderRadius: BorderRadius.circular(kIsWeb ? 10 : 6.r),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text("Product", style: _headerStyle())),
          Expanded(
            flex: 1,
            child: Center(child: Text("Qty", style: _headerStyle())),
          ),
          Expanded(
            flex: 2,
            child: Center(child: Text("Total", style: _headerStyle())),
          ),
          Expanded(
            flex: 2,
            child: Center(child: Text("Profit", style: _headerStyle())),
          ),
        ],
      ),
    );
  }

  TextStyle _headerStyle() => TextStyle(
    fontSize: kIsWeb ? 14 : 13.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
}
