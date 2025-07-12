import 'dart:convert';
import 'dart:io';
import 'package:beatbox/utils/responsive_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/controller/brand_controller.dart';
import 'package:beatbox/features/product_management/controller/category_controller.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/features/product_management/widgets/brand_category_dropdown_field.dart';
import 'package:beatbox/features/product_management/widgets/product_image_picker.dart';
import 'package:beatbox/features/product_management/widgets/product_text_field.dart';
import 'package:beatbox/utils/add_edit_product_utils.dart';
import 'package:beatbox/utils/image_picker_utils.dart';

class AddProductScreen extends StatefulWidget {
  final ProductModel? productToEdit;
  const AddProductScreen({super.key, this.productToEdit});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String? selectedCategory;
  String? selectedBrand;
  List<String> categoryList = [];
  List<String> brandList = [];
  final _formKey = GlobalKey<FormState>();
  final uuid = Uuid();
  File? _image1, _image2, _image3;
  Uint8List? _webImage1, _webImage2, _webImage3;

  final _productNameController = TextEditingController();
  final _productCodeController = TextEditingController();
  final _purchaseRateController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDropdownData();
    if (widget.productToEdit != null) _initializeFormWithProductData();
  }

  Future<void> fetchDropdownData() async {
    final categories = CategoryController.getAllCategory();
    final brands = BrandController.getBrands();
    setState(() {
      categoryList = categories.map((e) => e.categoryName).toList();
      brandList = brands.map((e) => e.brandName).toList();
    });
  }

  void _initializeFormWithProductData() {
    final p = widget.productToEdit!;
    _productNameController.text = p.productName;
    _productCodeController.text = p.productCode;
    _purchaseRateController.text = p.purchaseRate.toString();
    _salePriceController.text = p.salePrice.toString();
    _descriptionController.text = p.description;
    _quantityController.text = p.productQuantity.toString();
    selectedCategory = p.productCategory;
    selectedBrand = p.productBrand;

    if (kIsWeb) {
      if (p.webImage1 != null) _webImage1 = base64Decode(p.webImage1!);
      if (p.webImage2 != null) _webImage2 = base64Decode(p.webImage2!);
      if (p.webImage3 != null) _webImage3 = base64Decode(p.webImage3!);
    } else {
      if (p.image1 != null) _image1 = File(p.image1!);
      if (p.image2 != null) _image2 = File(p.image2!);
      if (p.image3 != null) _image3 = File(p.image3!);
    }
  }

  Future<void> _pickImage(int num) async {
    if (kIsWeb) {
      final picked = await pickImageAsBytesForWeb();
      if (picked != null) {
        setState(() {
          if (num == 1) _webImage1 = picked;
          if (num == 2) _webImage2 = picked;
          if (num == 3) _webImage3 = picked;
        });
      }
    } else {
      final picked = await pickImageFromGallery();
      if (picked != null) {
        setState(() {
          if (num == 1) _image1 = picked;
          if (num == 2) _image2 = picked;
          if (num == 3) _image3 = picked;
        });
      }
    }
  }

  void _resetForm() {
    AddEditProductUtils.resetForm(
      nameController: _productNameController,
      quantityController: _quantityController,
      codeController: _productCodeController,
      purchaseRateController: _purchaseRateController,
      salePriceController: _salePriceController,
      descriptionController: _descriptionController,
      updateState: (img1, img2, img3, cat, brand) {
        setState(() {
          _image1 = img1;
          _image2 = img2;
          _image3 = img3;
          _webImage1 = _webImage2 = _webImage3 = null;
          selectedCategory = cat;
          selectedBrand = brand;
        });
      },
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_image1 == null &&
        _image2 == null &&
        _image3 == null &&
        _webImage1 == null &&
        _webImage2 == null &&
        _webImage3 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please upload at least one image'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final product = ProductModel(
      id: widget.productToEdit?.id ?? uuid.v4(),
      productName: _productNameController.text.trim(),
      productCategory: selectedCategory ?? '',
      productBrand: selectedBrand ?? '',
      productQuantity: int.tryParse(_quantityController.text.trim()) ?? 0,
      initialQuantity: int.tryParse(_quantityController.text.trim()) ?? 0,
      productCode: _productCodeController.text.trim(),
      purchaseRate: double.tryParse(_purchaseRateController.text.trim()) ?? 0.0,
      salePrice: double.tryParse(_salePriceController.text.trim()) ?? 0.0,
      description: _descriptionController.text.trim(),
      image1: _image1?.path,
      image2: _image2?.path,
      image3: _image3?.path,
      webImage1: _webImage1 != null ? base64Encode(_webImage1!) : null,
      webImage2: _webImage2 != null ? base64Encode(_webImage2!) : null,
      webImage3: _webImage3 != null ? base64Encode(_webImage3!) : null,
      createdDate: widget.productToEdit?.createdDate ?? DateTime.now(),
    );

    if (widget.productToEdit != null) {
      final confirm = await AddEditProductUtils.showConfirmationDialog(
        context,
        'Update',
      );
      if (confirm != true) return;
      await AddEditProductUtils.processProductUpdate(context, product);
    } else {
      await AddEditProductUtils.processProductAdd(context, product);
    }

    _resetForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: Text(
          widget.productToEdit != null ? 'Edit Product' : 'Add Product',
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWeb =
              Responsive.isDesktop(context) || constraints.maxWidth > 600;
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWeb ? 200.w : double.infinity,
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              ProductTextField(
                                controller: _productNameController,
                                label: 'Product Name',
                                hintText: 'Enter product name',
                                icon: Icons.shopping_bag_outlined,
                                validator:
                                    (val) => ProductValidators.validateName(
                                      val,
                                      isEdit: widget.productToEdit != null,
                                      oldName:
                                          widget.productToEdit?.productName,
                                    ),
                              ),
                              BrandCategoryDropdownField(
                                label: 'Category',
                                value: selectedCategory,
                                items: categoryList,
                                icon: Icons.category_outlined,
                                validator:
                                    (v) =>
                                        v == null
                                            ? 'Please select category'
                                            : null,
                                onChanged:
                                    (v) => setState(() => selectedCategory = v),
                              ),
                              BrandCategoryDropdownField(
                                label: 'Brand',
                                value: selectedBrand,
                                items: brandList,
                                icon: Icons.branding_watermark_outlined,
                                validator:
                                    (v) =>
                                        v == null
                                            ? 'Please select brand'
                                            : null,
                                onChanged:
                                    (v) => setState(() => selectedBrand = v),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ProductTextField(
                                      controller: _quantityController,
                                      label: 'Quantity',
                                      hintText: 'Enter quantity',
                                      icon: Icons.numbers,
                                      keyboardType: TextInputType.number,
                                      validator:
                                          ProductValidators.validateQuantity,
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: ProductTextField(
                                      controller: _productCodeController,
                                      label: 'Product Code',
                                      hintText: 'Enter code',
                                      icon: Icons.qr_code,
                                      validator: ProductValidators.validateCode,
                                    ),
                                  ),
                                ],
                              ),
                              ProductTextField(
                                controller: _purchaseRateController,
                                label: 'Purchase Price',
                                hintText: 'Enter price',
                                icon: Icons.attach_money,
                                validator:
                                    ProductValidators.validatePurchasePrice,
                                keyboardType: TextInputType.number,
                              ),
                              ProductTextField(
                                controller: _salePriceController,
                                label: 'Sale Price',
                                hintText: 'Enter price',
                                icon: Icons.sell_outlined,
                                validator:
                                    (v) => ProductValidators.validateSalePrice(
                                      v,
                                      _purchaseRateController.text,
                                    ),
                                keyboardType: TextInputType.number,
                              ),
                              ProductTextField(
                                controller: _descriptionController,
                                label: 'Description',
                                hintText: 'Enter description',
                                icon: Icons.description_outlined,
                                validator:
                                    ProductValidators.validateDescription,
                                maxLines: 4,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: Text(
                                  'Upload at least 1 image *',
                                  style: TextStyle(
                                    fontSize: isWeb ? 7.sp : 14.sp,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ProductImagePicker(
                                      label: 'Image 1',
                                      imageFile: _image1,
                                      webImage: _webImage1,
                                      onPick: () => _pickImage(1),
                                      onRemove:
                                          () => setState(() {
                                            _image1 = null;
                                            _webImage1 = null;
                                          }),
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: ProductImagePicker(
                                      label: 'Image 2',
                                      imageFile: _image2,
                                      webImage: _webImage2,
                                      onPick: () => _pickImage(2),
                                      onRemove:
                                          () => setState(() {
                                            _image2 = null;
                                            _webImage2 = null;
                                          }),
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: ProductImagePicker(
                                      label: 'Image 3',
                                      imageFile: _image3,
                                      webImage: _webImage3,
                                      onPick: () => _pickImage(3),
                                      onRemove:
                                          () => setState(() {
                                            _image3 = null;
                                            _webImage3 = null;
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isWeb ? 200.w : double.infinity,
                      ),
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 16.h),
                        child: ElevatedButton(
                          onPressed: _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            widget.productToEdit != null
                                ? 'Update Product'
                                : 'Add Product',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isWeb ? 7.sp : 16.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
