import 'dart:io';
import 'package:beatbox/utils/brand_category_validators_utils.dart';
import 'package:beatbox/widgets/Loading_widgets/show_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/category_model.dart';
import 'package:beatbox/features/product_management/model/brand_model.dart';
import 'package:beatbox/features/product_management/controller/brand_controller.dart';
import 'package:beatbox/features/product_management/controller/category_controller.dart';

class EditCategoryDialog extends StatefulWidget {
  final CategoryModel item;

  const EditCategoryDialog({super.key, required this.item});

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  late TextEditingController nameController;
  late String updatedImagePath;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item.categoryName);
    updatedImagePath = widget.item.categoryImagePath;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      title: Text('Edit Category', style: TextStyle(color: AppColors.primary)),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Category Name',
                labelStyle: TextStyle(color: AppColors.primary),
              ),
              validator:
                  (value) => NameValidators.validateCategoryName(
                    value,
                    isEdit: true,
                    oldName: widget.item.categoryName,
                  ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () async {
                final picked = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (picked != null) {
                  setState(() => updatedImagePath = picked.path);
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.file(
                  File(updatedImagePath),
                  width: 120.w,
                  height: 120.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;

            widget.item.categoryName = nameController.text.trim();
            widget.item.categoryImagePath = updatedImagePath;
            await showLoadingDialog(
              context,
              message: "Updating...",
              showSucess: true,
            );
            await widget.item.save();
            CategoryController.initBox();
            Navigator.pop(context);
          },
          child: Text('Save', style: TextStyle(color: AppColors.success)),
        ),
      ],
    );
  }
}

class EditBrandDialog extends StatefulWidget {
  final BrandModel item;

  const EditBrandDialog({super.key, required this.item});

  @override
  State<EditBrandDialog> createState() => _EditBrandDialogState();
}

class _EditBrandDialogState extends State<EditBrandDialog> {
  late TextEditingController nameController;
  late String updatedImagePath;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item.brandName);
    updatedImagePath = widget.item.brandImagePath;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      title: Text('Edit Brand', style: TextStyle(color: AppColors.primary)),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Brand Name',
                labelStyle: TextStyle(color: AppColors.primary),
              ),
              validator:
                  (value) => NameValidators.validateBrandName(
                    value,
                    isEdit: true,
                    oldName: widget.item.brandName,
                  ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () async {
                final picked = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (picked != null) {
                  setState(() => updatedImagePath = picked.path);
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.file(
                  File(updatedImagePath),
                  width: 120.w,
                  height: 120.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: AppColors.primary)),
        ),
        TextButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;

            widget.item.brandName = nameController.text.trim();
            widget.item.brandImagePath = updatedImagePath;
            await showLoadingDialog(
              context,
              message: "Updating...",
              showSucess: true,
            );
            await widget.item.save();
            BrandController.initBox();
            Navigator.pop(context);
          },
          child: Text('Save', style: TextStyle(color: AppColors.success)),
        ),
      ],
    );
  }
}
