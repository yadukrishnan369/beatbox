import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';
import 'dart:io';

class ProductImagePicker extends StatelessWidget {
  final File? imageFile; // mobile
  final Uint8List? webImage; // web
  final VoidCallback onPick;
  final VoidCallback onRemove;
  final String label;

  const ProductImagePicker({
    super.key,
    required this.imageFile,
    required this.webImage,
    required this.onPick,
    required this.onRemove,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWeb =
            Responsive.isDesktop(context) || constraints.maxWidth > 600;

        return Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: isWeb ? 7.sp : 12.sp,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: onPick,
              child: Container(
                height: isWeb ? 40.w : 80.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Builder(
                  builder: (_) {
                    if (isWeb && webImage != null) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.memory(
                              webImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: isWeb ? 60.w : 80.h,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: onRemove,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: AppColors.textPrimary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: isWeb ? 14.w : 20.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (!isWeb && imageFile != null) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.file(
                              imageFile!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 80.h,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: onRemove,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: AppColors.textPrimary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Icon(
                          Icons.image,
                          size: isWeb ? 18.w : 40.sp,
                          color: AppColors.primary,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Icon(
              Icons.camera_alt,
              size: isWeb ? 14.w : 20.sp,
              color: AppColors.primary,
            ),
          ],
        );
      },
    );
  }
}
