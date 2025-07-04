import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class TableShimmerWidget extends StatelessWidget {
  const TableShimmerWidget({super.key});

  Color getBaseColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[700]!
        : Colors.grey[300]!;
  }

  Color getHighlightColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[500]!
        : Colors.grey[100]!;
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = getBaseColor(context);
    final highlightColor = getHighlightColor(context);
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(baseColor),
            SizedBox(height: 16.h),
            ...List.generate(
              6,
              (index) => _buildRowShimmer(index, baseColor, highlightColor),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color baseColor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: baseColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(flex: 5, child: _headerBox(baseColor)),
          Expanded(flex: 3, child: _headerBox(baseColor)),
          Expanded(flex: 3, child: _headerBox(baseColor)),
          Expanded(flex: 3, child: _headerBox(baseColor)),
        ],
      ),
    );
  }

  Widget _headerBox(Color baseColor) {
    return Container(
      height: 18.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      color: baseColor,
    );
  }

  Widget _buildRowShimmer(int index, Color baseColor, Color highlightColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Row(
          children: [
            Expanded(flex: 5, child: _shimmerBox(baseColor)), // Name/Product
            Expanded(
              flex: 3,
              child: _shimmerBox(baseColor, center: true),
            ), // Date
            Expanded(
              flex: 3,
              child: _shimmerBox(baseColor, center: true),
            ), // Amount
            Expanded(
              flex: 3,
              child: _shimmerBox(baseColor, center: true),
            ), // Qty/Profit
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox(Color baseColor, {bool center = false}) {
    return Container(
      height: 18.h,
      alignment: center ? Alignment.center : Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}
