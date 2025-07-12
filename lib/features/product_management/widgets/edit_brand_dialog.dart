import 'dart:convert';
import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/controller/brand_controller.dart';
import 'package:beatbox/features/product_management/model/brand_model.dart';
import 'package:beatbox/utils/brand_category_validators_utils.dart';
import 'package:beatbox/widgets/Loading_widgets/show_loading_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class EditBrandDialog extends StatefulWidget {
  final BrandModel item;

  const EditBrandDialog({super.key, required this.item});

  @override
  State<EditBrandDialog> createState() => _EditBrandDialogState();
}

class _EditBrandDialogState extends State<EditBrandDialog> {
  late TextEditingController nameController;
  String? updatedImagePath;
  Uint8List? updatedImageBytes;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item.brandName);

    if (kIsWeb) {
      updatedImageBytes = base64Decode(widget.item.brandImagePath);
    } else {
      updatedImagePath = widget.item.brandImagePath;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Brand', style: TextStyle(color: AppColors.primary)),
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
                labelText: 'Brand Name',
                labelStyle: TextStyle(color: AppColors.textPrimary),
              ),
              validator:
                  (value) => NameAndImageValidators.validateBrandName(
                    value,
                    isEdit: true,
                    oldName: widget.item.brandName,
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

            widget.item.brandName = nameController.text.trim();

            if (kIsWeb) {
              widget.item.brandImagePath = base64Encode(updatedImageBytes!);
            } else {
              widget.item.brandImagePath = updatedImagePath!;
            }

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
