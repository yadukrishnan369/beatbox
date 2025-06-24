// Updated AddProductScreen (Refactored)

import 'dart:io';
import 'package:beatbox/features/product_management/controller/brand_controller.dart';
import 'package:beatbox/features/product_management/controller/category_controller.dart';
import 'package:beatbox/features/product_management/widgets/product_dropdown_field.dart';
import 'package:beatbox/features/product_management/widgets/product_image_picker.dart';
import 'package:beatbox/features/product_management/widgets/product_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/utils/image_picker_utils.dart';
import 'package:beatbox/utils/add_edit_product_utils.dart';
import 'package:uuid/uuid.dart';

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
    try {
      final categories = CategoryController.getAllCategory();
      final brands = BrandController.getBrands();

      setState(() {
        categoryList = categories.map((e) => e.categoryName).toList();
        brandList = brands.map((e) => e.brandName).toList();
      });
    } catch (e) {
      debugPrint('Error fetching dropdown data: $e');
    }
  }

  void _initializeFormWithProductData() {
    final product = widget.productToEdit!;
    _productNameController.text = product.productName;
    _productCodeController.text = product.productCode;
    _purchaseRateController.text = product.purchaseRate.toString();
    _salePriceController.text = product.salePrice.toString();
    _descriptionController.text = product.description;
    _quantityController.text = product.productQuantity.toString();
    selectedCategory = product.productCategory;
    selectedBrand = product.productBrand;
    if (product.image1 != null) _image1 = File(product.image1!);
    if (product.image2 != null) _image2 = File(product.image2!);
    if (product.image3 != null) _image3 = File(product.image3!);
  }

  Future<void> _pickImage(int imageNumber) async {
    final picked = await pickImageFromGallery();
    if (picked != null && mounted) {
      setState(() {
        switch (imageNumber) {
          case 1:
            _image1 = picked;
            break;
          case 2:
            _image2 = picked;
            break;
          case 3:
            _image3 = picked;
            break;
        }
      });
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
          selectedCategory = cat;
          selectedBrand = brand;
        });
      },
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_image1 == null && _image2 == null && _image3 == null) {
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
      productCode: _productCodeController.text.trim(),
      purchaseRate: double.tryParse(_purchaseRateController.text.trim()) ?? 0.0,
      salePrice: double.tryParse(_salePriceController.text.trim()) ?? 0.0,
      description: _descriptionController.text.trim(),
      image1: _image1?.path,
      image2: _image2?.path,
      image3: _image3?.path,
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
  void dispose() {
    _productNameController.dispose();
    _productCodeController.dispose();
    _quantityController.dispose();
    _purchaseRateController.dispose();
    _salePriceController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
      body: Padding(
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
                        validator: ProductValidators.validateName,
                      ),
                      ProductDropdownField(
                        label: 'Category',
                        value: selectedCategory,
                        items: categoryList.toSet().toList(),
                        icon: Icons.category_outlined,
                        validator:
                            (value) =>
                                value == null
                                    ? 'Please select a category'
                                    : null,
                        onChanged:
                            (value) => setState(() => selectedCategory = value),
                      ),
                      ProductDropdownField(
                        label: 'Brand',
                        value: selectedBrand,
                        items: brandList.toSet().toList(),
                        icon: Icons.branding_watermark_outlined,
                        validator:
                            (value) =>
                                value == null ? 'Please select a brand' : null,
                        onChanged:
                            (value) => setState(() => selectedBrand = value),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ProductTextField(
                              controller: _quantityController,
                              label: 'Quantity',
                              hintText: 'Enter quantity',
                              icon: Icons.numbers,
                              validator: ProductValidators.validateQuantity,
                              keyboardType: TextInputType.number,
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
                        validator: ProductValidators.validatePurchasePrice,
                        keyboardType: TextInputType.number,
                      ),
                      ProductTextField(
                        controller: _salePriceController,
                        label: 'Sale Price',
                        hintText: 'Enter price',
                        icon: Icons.sell_outlined,
                        validator:
                            (value) => ProductValidators.validateSalePrice(
                              value,
                              _purchaseRateController.text,
                            ),
                        keyboardType: TextInputType.number,
                      ),
                      ProductTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        hintText: 'Enter description',
                        icon: Icons.description_outlined,
                        validator: ProductValidators.validateDescription,
                        maxLines: 4,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Text(
                              'Upload at least 1 image *',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ProductImagePicker(
                                  image: _image1,
                                  label: 'Image 1',
                                  onPick: () => _pickImage(1),
                                  onRemove:
                                      () => setState(() => _image1 = null),
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: ProductImagePicker(
                                  image: _image2,
                                  label: 'Image 2',
                                  onPick: () => _pickImage(2),
                                  onRemove:
                                      () => setState(() => _image2 = null),
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: ProductImagePicker(
                                  image: _image3,
                                  label: 'Image 3',
                                  onPick: () => _pickImage(3),
                                  onRemove:
                                      () => setState(() => _image3 = null),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
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
                    color: AppColors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
