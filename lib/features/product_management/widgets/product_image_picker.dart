import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';
import 'dart:io';

class ProductImagePicker extends StatelessWidget {
  final File? image;
  final VoidCallback onPick;
  final VoidCallback onRemove;
  final String label;

  const ProductImagePicker({
    super.key,
    required this.image,
    required this.onPick,
    required this.onRemove,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: onPick,
          child: Container(
            height: 80.h,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.primary),
            ),
            child:
                image != null
                    ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.file(
                            image!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 80.h,
                          ),
                        ),
                        Positioned(
                          top: 4.h,
                          right: 4.w,
                          child: GestureDetector(
                            onTap: onRemove,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.textPrimary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: AppColors.white,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                    : Center(
                      child: Icon(
                        Icons.image,
                        size: 40.sp,
                        color: AppColors.primary,
                      ),
                    ),
          ),
        ),
        SizedBox(height: 8.h),
        Icon(Icons.camera_alt, size: 20.sp, color: AppColors.primary),
      ],
    );
  }
}
