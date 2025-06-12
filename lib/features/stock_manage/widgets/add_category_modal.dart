import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/stock_manage/controller/category_controller.dart';
import 'package:beatbox/features/stock_manage/model/category_model.dart';
import 'package:beatbox/utils/image_picker_utils.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

class AddCategoryModal extends StatefulWidget {
  final Function(String, File?)? onSubmit;

  const AddCategoryModal({super.key, this.onSubmit});

  @override
  State<AddCategoryModal> createState() => _AddCategoryModalState();
}

class _AddCategoryModalState extends State<AddCategoryModal> {
  final _formKey = GlobalKey<FormState>();
  final _categoryController = TextEditingController();
  File? _selectedImage;
  bool _isImageSelected = true;

  final uuid = Uuid();

  void onSubmit() {
    bool isValid = _formKey.currentState!.validate();
    bool hasImage = _selectedImage != null;

    setState(() {
      _isImageSelected = hasImage;
    });

    if (isValid && hasImage) {
      final newCategory = CategoryModel(
        id: uuid.v4(),
        categoryName: _categoryController.text.trim(),
        categoryImagePath: _selectedImage!.path,
      );

      CategoryController.addCategory(newCategory);

      widget.onSubmit?.call(_categoryController.text, _selectedImage);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Category added successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.of(context).pop(true);
    }
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Add Category',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Category Name Field
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                    labelText: 'Category Name',
                    border: OutlineInputBorder(),
                    floatingLabelStyle: TextStyle(color: AppColors.primary),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2.0,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),

                // Image Field
                GestureDetector(
                  onTap: () async {
                    File? picked = await pickImageFromGallery();
                    if (picked != null) {
                      setState(() {
                        _selectedImage = picked;
                      });
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 120.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child:
                            _selectedImage == null
                                ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_a_photo, size: 40.w),
                                    SizedBox(height: 8.h),
                                    const Text('Add Category Image'),
                                  ],
                                )
                                : ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Text(
                                          "Image Not Found!",
                                          style: TextStyle(
                                            color: AppColors.error,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                      ),
                      if (!_isImageSelected)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h, left: 8.w),
                          child: Text(
                            'Please select an image',
                            style: TextStyle(
                              color: AppColors.error,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                      child: const Text('Cancel'),
                    ),
                    SizedBox(width: 10.w),
                    ElevatedButton(
                      onPressed: onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: AppColors.white,
                      ),
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
