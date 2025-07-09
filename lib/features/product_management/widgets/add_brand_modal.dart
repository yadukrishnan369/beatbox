import 'dart:convert';
import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/controller/brand_controller.dart';
import 'package:beatbox/features/product_management/model/brand_model.dart';
import 'package:beatbox/utils/brand_category_validators_utils.dart';
import 'package:beatbox/utils/image_picker_utils.dart';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:beatbox/widgets/Loading_widgets/show_loading_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

class AddBrandModal extends StatefulWidget {
  final Function(String, File?)? onSubmit;

  const AddBrandModal({super.key, this.onSubmit});

  @override
  State<AddBrandModal> createState() => _AddBrandModalState();
}

class _AddBrandModalState extends State<AddBrandModal> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  File? _selectedImage;
  Uint8List? _webImage;
  final uuid = Uuid();
  String? _imageErrorText;

  void onSubmit() async {
    final isValid = _formKey.currentState!.validate();

    final imageError = NameAndImageValidators.validateBrandImage(
      webImage: _webImage,
      mobileImage: _selectedImage,
    );

    setState(() => _imageErrorText = imageError);

    if (!isValid || imageError != null) return;

    if (kIsWeb) {
      final newBrand = BrandModel(
        id: uuid.v4(),
        brandName: _brandController.text.trim(),
        brandImagePath: base64Encode(_webImage!),
      );

      BrandController.addBrand(newBrand);
      await showLoadingDialog(context, message: "Saving...", showSucess: true);
      widget.onSubmit?.call(_brandController.text, null);
    } else {
      final newBrand = BrandModel(
        id: uuid.v4(),
        brandName: _brandController.text.trim(),
        brandImagePath: _selectedImage!.path,
      );

      BrandController.addBrand(newBrand);
      await showLoadingDialog(context, message: "Saving...", showSucess: true);
      widget.onSubmit?.call(_brandController.text, _selectedImage);
    }

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _brandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWeb =
        Responsive.isDesktop(context) ||
        MediaQuery.of(context).size.width > 600;

    final double fontSizeTitle = isWeb ? 10.sp : 20.sp;
    final double spacing = isWeb ? 15.h : 20.h;
    final double iconSize = isWeb ? 15.w : 40.w;
    final double imageHeight = 120.h;
    final double horizontalPadding = isWeb ? 14.w : 16.w;
    final double maxWidth = isWeb ? 80.w : double.infinity;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: spacing,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Add Brand',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: fontSizeTitle,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: spacing),

                  // brand name field
                  TextFormField(
                    controller: _brandController,
                    style: TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Brand Name',
                      border: const OutlineInputBorder(),
                      floatingLabelStyle: TextStyle(color: AppColors.primary),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 2.0,
                        ),
                      ),
                    ),
                    validator:
                        (value) =>
                            NameAndImageValidators.validateBrandName(value),
                  ),
                  SizedBox(height: spacing),

                  // image picker
                  GestureDetector(
                    onTap: () async {
                      if (kIsWeb) {
                        final bytes = await pickImageAsBytesForWeb();
                        if (bytes != null) {
                          setState(() {
                            _webImage = bytes;
                            _selectedImage = null;
                            _imageErrorText = null;
                          });
                        }
                      } else {
                        File? picked = await pickImageFromGallery();
                        if (picked != null) {
                          setState(() {
                            _selectedImage = picked;
                            _webImage = null;
                            _imageErrorText = null;
                          });
                        }
                      }
                    },
                    child: Container(
                      height: imageHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Builder(
                        builder: (_) {
                          if (kIsWeb && _webImage != null) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.memory(
                                _webImage!,
                                fit: BoxFit.cover,
                              ),
                            );
                          } else if (!kIsWeb &&
                              _selectedImage != null &&
                              _selectedImage!.existsSync()) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => Center(
                                      child: Text(
                                        "Image Not Found!",
                                        style: TextStyle(
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ),
                              ),
                            );
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo, size: iconSize),
                                SizedBox(height: 8.h),
                                Text(
                                  'Add Brand Image',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ),

                  // image error message
                  if (_imageErrorText != null)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h, left: 4.w),
                      child: Text(
                        _imageErrorText!,
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: isWeb ? 3.5.sp : 12.6.sp,
                        ),
                      ),
                    ),

                  SizedBox(height: spacing),

                  // buttons
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
      ),
    );
  }
}
