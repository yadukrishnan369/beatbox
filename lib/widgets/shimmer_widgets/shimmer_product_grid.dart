import 'package:beatbox/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProductGrid extends StatelessWidget {
  final bool isGridView;

  const ShimmerProductGrid({super.key, required this.isGridView});

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
    return isGridView ? _buildGridView(context) : _buildListView(context);
  }

  Widget _buildGridView(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: 6,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        return _buildShimmerGridItem(context);
      },
    );
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: _buildShimmerListItem(context),
        );
      },
    );
  }

  Widget _buildShimmerGridItem(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: getBaseColor(context),
      highlightColor: getHighlightColor(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: getBaseColor(context),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 12.h),
            Container(height: 14.h, width: 80.w, color: getBaseColor(context)),
            SizedBox(height: 8.h),
            Container(height: 14.h, width: 50.w, color: getBaseColor(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerListItem(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: getBaseColor(context),
      highlightColor: getHighlightColor(context),
      child: Container(
        height: 100.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: getBaseColor(context),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 14.h,
                    width: 120.w,
                    color: getBaseColor(context),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 14.h,
                    width: 80.w,
                    color: getBaseColor(context),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 14.h,
                    width: 60.w,
                    color: getBaseColor(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
