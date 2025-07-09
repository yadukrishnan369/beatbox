import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerDetailCard extends StatelessWidget {
  final SalesModel sale;

  const CustomerDetailCard({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    final bool isWeb = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isWeb ? 18 : 16.w),
      decoration: BoxDecoration(
        color: AppColors.contColor,
        borderRadius: BorderRadius.circular(isWeb ? 10 : 12.r),
        border: Border.all(
          color: AppColors.textPrimary,
          width: isWeb ? 1.2 : 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Customer name', sale.customerName, isWeb),
          SizedBox(height: isWeb ? 14 : 12.h),
          _buildDetailRow('Phone', sale.customerPhone, isWeb),
          SizedBox(height: isWeb ? 14 : 12.h),
          _buildDetailRow('Email', sale.customerEmail, isWeb),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isWeb) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: isWeb ? 140 : 120.w,
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: isWeb ? 14 : 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          ': ',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: isWeb ? 14 : 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: isWeb ? 14 : 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
