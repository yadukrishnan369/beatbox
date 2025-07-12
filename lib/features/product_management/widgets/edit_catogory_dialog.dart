import 'dart:convert';
import 'dart:io';
import 'package:beatbox/utils/brand_category_validators_utils.dart';
import 'package:beatbox/widgets/Loading_widgets/show_loading_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/category_model.dart';
import 'package:beatbox/features/product_management/controller/category_controller.dart';

class EditCategoryDialog extends StatefulWidget {
  final CategoryModel item;

  const EditCategoryDialog({super.key, required this.item});

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  late TextEditingController nameController;
  String? updatedImagePath;
  Uint8List? updatedImageBytes;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item.categoryName);

    if (kIsWeb) {
      updatedImageBytes = base64Decode(widget.item.categoryImagePath);
    } else {
      updatedImagePath = widget.item.categoryImagePath;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Category', style: TextStyle(color: AppColors.primary)),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // name field
            TextFormField(
              controller: nameController,
              style: TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Category Name',
                labelStyle: TextStyle(color: AppColors.textPrimary),
              ),
              validator:
                  (value) => NameAndImageValidators.validateCategoryName(
                    value,
                    isEdit: true,
                    oldName: widget.item.categoryName,
                  ),
            ),
            SizedBox(height: 16.h),

            // image picker & preview
            GestureDetector(
              onTap: () async {
                final picked = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (picked != null) {
                  final bytes = await picked.readAsBytes();
                  if (kIsWeb) {
                    setState(() => updatedImageBytes = bytes);
                  } else {
                    setState(() => updatedImagePath = picked.path);
                  }
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child:
                    kIsWeb
                        ? (updatedImageBytes != null
                            ? Image.memory(
                              updatedImageBytes!,
                              width: 120.w,
                              height: 120.h,
                              fit: BoxFit.cover,
                            )
                            : Icon(
                              Icons.image_not_supported,
                              size: 80,
                              color: AppColors.textDisabled,
                            ))
                        : (updatedImagePath != null &&
                                File(updatedImagePath!).existsSync()
                            ? Image.file(
                              File(updatedImagePath!),
                              width: 120.w,
                              height: 120.h,
                              fit: BoxFit.cover,
                            )
                            : Icon(
                              Icons.image_not_supported,
                              size: 80,
                              color: AppColors.textDisabled,
                            )),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;

            widget.item.categoryName = nameController.text.trim();

            if (kIsWeb) {
              widget.item.categoryImagePath = base64Encode(updatedImageBytes!);
            } else {
              widget.item.categoryImagePath = updatedImagePath!;
            }

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
