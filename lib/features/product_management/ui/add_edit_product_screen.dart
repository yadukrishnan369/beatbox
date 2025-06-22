import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/controller/drop_down_data_controller.dart.dart';
import 'package:beatbox/features/product_management/controller/product_controller.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/utils/image_picker_utils.dart';
import 'package:beatbox/widgets/Loading_widgets/show_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

class AddProductScreen extends StatefulWidget {
  final ProductModel? productToEdit;
  const AddProductScreen({super.key, this.productToEdit});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final CategoryController _categoryController = CategoryController();
  final BrandController _brandController = BrandController();
  String? selectedCategory;
  String? selectedBrand;

  List<String> categoryList = [];
  List<String> brandList = [];

  final _formKey = GlobalKey<FormState>();
  final uuid = Uuid();

  File? _image1;
  File? _image2;
  File? _image3;

  @override
  void initState() {
    super.initState();
    //get all catogories and brands for showing dropdown
    fetchDropdownData();

    //if edited for product, filled data in textfileds
    if (widget.productToEdit != null) {
      _productNameController.text = widget.productToEdit!.productName;
      _productCodeController.text = widget.productToEdit!.productCode;
      _purchaseRateController.text =
          widget.productToEdit!.purchaseRate.toString();
      _salePriceController.text = widget.productToEdit!.salePrice.toString();
      _descriptionController.text = widget.productToEdit!.description;
      _quantityController.text =
          widget.productToEdit!.productQuantity.toString();
      selectedCategory = widget.productToEdit!.productCategory;
      selectedBrand = widget.productToEdit!.productBrand;

      if (widget.productToEdit!.image1 != null) {
        _image1 = File(widget.productToEdit!.image1!);
      }
      if (widget.productToEdit!.image2 != null) {
        _image2 = File(widget.productToEdit!.image2!);
      }
      if (widget.productToEdit!.image3 != null) {
        _image3 = File(widget.productToEdit!.image3!);
      }
    }
  }

  Future<void> fetchDropdownData() async {
    try {
      final categories = await _categoryController.getAllCategory();
      final brands = await _brandController.getAllBrands();

      setState(() {
        categoryList = categories;
        brandList = brands;
      });
    } catch (e) {
      print('Error fetching dropdown data: $e');
    }
  }

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productCodeController = TextEditingController();
  final TextEditingController _purchaseRateController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

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
      appBar: AppBar(title: const Text('Add product')),
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
                      // Product Name Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product Name',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            margin: EdgeInsets.only(bottom: 16.h),
                            child: TextFormField(
                              controller: _productNameController,
                              decoration: InputDecoration(
                                hintText: 'Enter product name',
                                hintStyle: TextStyle(
                                  color: AppColors.textDisabled,
                                ),
                                prefixIcon: Icon(Icons.shopping_bag_outlined),
                                filled: true,
                                fillColor: AppColors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(color: AppColors.blue),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 16.h,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'This field is required';
                                }
                                final isValid = RegExp(
                                  r'[a-zA-Z]',
                                ).hasMatch(value);
                                if (!isValid) {
                                  return 'Enter Valid Product Name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      // Product Category Dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product Category',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            margin: EdgeInsets.only(bottom: 16.h),
                            child: DropdownButtonFormField<String>(
                              value:
                                  categoryList.toSet().contains(
                                        selectedCategory,
                                      )
                                      ? selectedCategory
                                      : null,
                              hint: Text(
                                'Select category',
                                style: TextStyle(color: AppColors.textDisabled),
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.category_outlined),
                                filled: true,
                                fillColor: AppColors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(color: AppColors.blue),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 16.h,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a category';
                                }
                                return null;
                              },
                              items:
                                  categoryList.toSet().toList().map((category) {
                                    return DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(category),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      // Brand Dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Brand',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            margin: EdgeInsets.only(bottom: 16.h),
                            child: DropdownButtonFormField<String>(
                              value:
                                  brandList.toSet().contains(selectedBrand)
                                      ? selectedBrand
                                      : null,
                              hint: Text(
                                'Select brand',
                                style: TextStyle(color: AppColors.textDisabled),
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.branding_watermark_outlined,
                                ),
                                filled: true,
                                fillColor: AppColors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(color: AppColors.blue),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 16.h,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a brand';
                                }
                                return null;
                              },
                              items:
                                  brandList.toSet().toList().map((brand) {
                                    return DropdownMenuItem<String>(
                                      value: brand,
                                      child: Text(brand),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedBrand = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      // Product Quantity and Product Code Row
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              // Quantity
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Quantity',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Container(
                                      margin: EdgeInsets.only(
                                        right: 8.w,
                                        bottom: 16.h,
                                      ),
                                      child: TextFormField(
                                        controller: _quantityController,
                                        decoration: InputDecoration(
                                          hintText: 'Enter quantity',
                                          hintStyle: TextStyle(
                                            color: AppColors.textDisabled,
                                          ),
                                          prefixIcon: Icon(Icons.numbers),
                                          filled: true,
                                          fillColor: AppColors.white,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                            borderSide: BorderSide(
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                            borderSide: BorderSide(
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                            borderSide: BorderSide(
                                              color: AppColors.blue,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                            vertical: 16.h,
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'This field is required';
                                          }
                                          final qty = int.tryParse(value);
                                          if (qty == null) {
                                            return 'Invalid Quantity';
                                          }

                                          if (qty <= 0) {
                                            return 'Invalid Quantity';
                                          }

                                          return null;
                                        },
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Product Code
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Product Code',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: 8.w,
                                        bottom: 16.h,
                                      ),
                                      child: TextFormField(
                                        controller: _productCodeController,
                                        decoration: InputDecoration(
                                          hintText: 'Enter product code',
                                          hintStyle: TextStyle(
                                            color: AppColors.textDisabled,
                                          ),
                                          prefixIcon: Icon(Icons.qr_code),
                                          filled: true,
                                          fillColor: AppColors.white,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                            borderSide: BorderSide(
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                            borderSide: BorderSide(
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                            borderSide: BorderSide(
                                              color: AppColors.blue,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                            vertical: 16.h,
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'This field is required';
                                          }
                                          final isValid = RegExp(
                                            r'[a-zA-Z]',
                                          ).hasMatch(value);
                                          if (!isValid) {
                                            return 'Enter valid Code';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Purchase Price Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Purchase Price',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            margin: EdgeInsets.only(bottom: 16.h),
                            child: TextFormField(
                              controller: _purchaseRateController,
                              decoration: InputDecoration(
                                hintText: 'Enter purchase price',
                                hintStyle: TextStyle(
                                  color: AppColors.textDisabled,
                                ),
                                prefixIcon: Icon(Icons.attach_money),
                                filled: true,
                                fillColor: AppColors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(color: AppColors.blue),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 16.h,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'This field is required';
                                }
                                final purchase = double.tryParse(value);

                                if (purchase == null) {
                                  return 'Enter valid Rate';
                                }

                                final parsed = double.tryParse(value);
                                if (parsed == null || parsed <= 0) {
                                  return 'Enter a valid positive Rate';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),

                      // Sale Price Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sale Price',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            margin: EdgeInsets.only(bottom: 16.h),
                            child: TextFormField(
                              controller: _salePriceController,
                              decoration: InputDecoration(
                                hintText: 'Enter sale price',
                                hintStyle: TextStyle(
                                  color: AppColors.textDisabled,
                                ),
                                prefixIcon: Icon(Icons.sell_outlined),
                                filled: true,
                                fillColor: AppColors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(color: AppColors.blue),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 16.h,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'This field is required';
                                }
                                final sales = double.tryParse(value);
                                final purchase = double.tryParse(
                                  _purchaseRateController.text,
                                );

                                if (sales == null) {
                                  return 'Enter valid Rate';
                                }

                                if (purchase != null && sales <= purchase) {
                                  return 'Sales Rate should not less than purchase rate';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),

                      // Product Description Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product Description',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            margin: EdgeInsets.only(bottom: 24.h),
                            child: TextFormField(
                              controller: _descriptionController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: 'Enter product description',
                                hintStyle: TextStyle(
                                  color: AppColors.textDisabled,
                                ),
                                prefixIcon: Icon(Icons.description_outlined),
                                filled: true,
                                fillColor: AppColors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide(color: AppColors.blue),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 16.h,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'This field is required';
                                }
                                final isValid = RegExp(
                                  r'[a-zA-Z]',
                                ).hasMatch(value);
                                if (!isValid) {
                                  return 'Enter valid Description';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      // Upload Images Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4.h),
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
                              // Image 1
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      'Image 1',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    GestureDetector(
                                      onTap: () async {
                                        File? picked =
                                            await pickImageFromGallery();
                                        if (picked != null) {
                                          setState(() {
                                            _image1 = picked;
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 80.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          border: Border.all(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        child:
                                            _image1 != null
                                                ? Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8.r,
                                                          ),
                                                      child: Image.file(
                                                        _image1!,
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: 80.h,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 4.h,
                                                      right: 4.w,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _image1 = null;
                                                          });
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                      0.5,
                                                                    ),
                                                                shape:
                                                                    BoxShape
                                                                        .circle,
                                                              ),
                                                          child: Icon(
                                                            Icons.close,
                                                            color:
                                                                AppColors.white,
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
                                    Icon(
                                      Icons.camera_alt,
                                      size: 20.sp,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16.w),
                              // Image 2
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      'Image 2',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    GestureDetector(
                                      onTap: () async {
                                        File? picked =
                                            await pickImageFromGallery();
                                        if (picked != null) {
                                          setState(() {
                                            _image2 = picked;
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 80.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          border: Border.all(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        child:
                                            _image2 != null
                                                ? Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8.r,
                                                          ),
                                                      child: Image.file(
                                                        _image2!,
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: 80.h,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 4.h,
                                                      right: 4.w,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _image2 = null;
                                                          });
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                      0.5,
                                                                    ),
                                                                shape:
                                                                    BoxShape
                                                                        .circle,
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
                                    Icon(
                                      Icons.camera_alt,
                                      size: 20.sp,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16.w),
                              // Image 3
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      'Image 3',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    GestureDetector(
                                      onTap: () async {
                                        File? picked =
                                            await pickImageFromGallery();
                                        if (picked != null) {
                                          setState(() {
                                            _image3 = picked;
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 80.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          border: Border.all(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        child:
                                            _image3 != null
                                                ? Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8.r,
                                                          ),
                                                      child: Image.file(
                                                        _image3!,
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: 80.h,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 4.h,
                                                      right: 4.w,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _image3 = null;
                                                          });
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                      0.5,
                                                                    ),
                                                                shape:
                                                                    BoxShape
                                                                        .circle,
                                                              ),
                                                          child: Icon(
                                                            Icons.close,
                                                            color:
                                                                AppColors.white,
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
                                    Icon(
                                      Icons.camera_alt,
                                      size: 20.sp,
                                      color: AppColors.primary,
                                    ),
                                  ],
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

            // Add Product Button
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 16.h),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_image1 == null && _image2 == null && _image3 == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please upload at least one image'),
                          backgroundColor: AppColors.error,
                          duration: Duration(seconds: 3),
                          action: SnackBarAction(
                            label: 'Undo',
                            textColor: AppColors.warning,
                            onPressed: () {},
                          ),
                        ),
                      );
                      return;
                    }

                    final addAndEditedProduct = ProductModel(
                      id: widget.productToEdit?.id ?? uuid.v4(),
                      productName: _productNameController.text.trim(),
                      productCategory: selectedCategory ?? '',
                      productBrand: selectedBrand ?? '',
                      productQuantity:
                          int.tryParse(_quantityController.text.trim()) ?? 0,
                      productCode: _productCodeController.text.trim(),
                      purchaseRate:
                          double.tryParse(
                            _purchaseRateController.text.trim(),
                          ) ??
                          0.0,
                      salePrice:
                          double.tryParse(_salePriceController.text.trim()) ??
                          0.0,
                      description: _descriptionController.text.trim(),
                      image1: _image1?.path,
                      image2: _image2?.path,
                      image3: _image3?.path,
                      createdDate:
                          widget.productToEdit?.createdDate ?? DateTime.now(),
                    );

                    if (widget.productToEdit != null) {
                      //  edit mode with confirmation
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              backgroundColor: AppColors.white,
                              title: Text('Confirm Update'),
                              content: Text(
                                'Are you sure you want to update this "${_productNameController.text}"?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(context, false),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(color: AppColors.error),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(
                                    'Update',
                                    style: TextStyle(color: AppColors.success),
                                  ),
                                ),
                              ],
                            ),
                      );
                      //check, if product update
                      if (confirm == true) {
                        await ProductController.updateProduct(
                          addAndEditedProduct,
                        );
                        await showLoadingDialog(
                          context,
                          message: "Updating...",
                          showSucess: true,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Product updated successfully'),
                            backgroundColor: AppColors.success,
                          ),
                        );

                        _productNameController.clear();
                        _quantityController.clear();
                        _productCodeController.clear();
                        _purchaseRateController.clear();
                        _salePriceController.clear();
                        _descriptionController.clear();

                        setState(() {
                          _image1 = null;
                          _image2 = null;
                          _image3 = null;
                          selectedCategory = null;
                          selectedBrand = null;
                        });

                        Navigator.pop(context);
                      }
                    } else {
                      // product add call
                      await ProductController.addProduct(addAndEditedProduct);
                      await showLoadingDialog(
                        context,
                        message: "Adding product",
                        showSucess: true,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Product added successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      _productNameController.clear();
                      _quantityController.clear();
                      _productCodeController.clear();
                      _purchaseRateController.clear();
                      _salePriceController.clear();
                      _descriptionController.clear();

                      setState(() {
                        _image1 = null;
                        _image2 = null;
                        _image3 = null;
                        selectedCategory = null;
                        selectedBrand = null;
                      });

                      Navigator.pop(context);
                    }
                  }
                },
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
