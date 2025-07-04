import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:beatbox/core/app_colors.dart';

class TableShimmerWidget extends StatelessWidget {
  const TableShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(), // disable extra scroll
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 16.h),
            ...List.generate(6, (index) => _buildRowShimmer(index)),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: AppColors.textDisabled.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(flex: 4, child: _headerBox()),
          Expanded(flex: 2, child: _headerBox()),
          Expanded(flex: 3, child: _headerBox()),
          Expanded(flex: 3, child: _headerBox()),
        ],
      ),
    );
  }

  Widget _headerBox() {
    return Container(
      height: 18.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      color: Colors.grey.shade300,
    );
  }

  Widget _buildRowShimmer(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          children: [
            Expanded(flex: 4, child: _shimmerBox()),
            Expanded(flex: 2, child: _shimmerBox(center: true)),
            Expanded(flex: 3, child: _shimmerBox(center: true)),
            Expanded(flex: 3, child: _shimmerBox(center: true)),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox({bool center = false}) {
    return Container(
      height: 18.h,
      alignment: center ? Alignment.center : Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}
