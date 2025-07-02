import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/utils/billing_utils.dart';

class CustomerInfoSection extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;

  const CustomerInfoSection({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
  });

  @override
  State<CustomerInfoSection> createState() => _CustomerInfoSectionState();
}

class _CustomerInfoSectionState extends State<CustomerInfoSection> {
  List<Map<String, String>> previousCustomers = [];
  bool isCustomerAutoFilled = false;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  void _loadCustomers() async {
    final customers = await BillingUtils.getPreviousCustomerDetails();
    setState(() {
      previousCustomers = customers;
    });
  }

  void _clearCustomerDetails() {
    widget.nameController.clear();
    widget.phoneController.clear();
    widget.emailController.clear();
    setState(() {
      isCustomerAutoFilled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.person_outline, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              "Customer Info",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 100.w),
            if (isCustomerAutoFilled)
              GestureDetector(
                onTap: _clearCustomerDetails,
                child: Row(
                  children: [
                    Icon(Icons.clear, size: 18.sp, color: AppColors.error),
                    SizedBox(width: 4.w),
                    Text(
                      "Clear",
                      style: TextStyle(
                        color: AppColors.error,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.contColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              _buildAutocompleteNameField(),
              SizedBox(height: 12.h),
              _buildTextFormField(
                "Phone",
                "phone number",
                widget.phoneController,
                BillingUtils.validatePhone,
              ),
              SizedBox(height: 12.h),
              _buildTextFormField(
                "Email",
                "email address",
                widget.emailController,
                BillingUtils.validateEmail,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAutocompleteNameField() {
    return Row(
      children: [
        SizedBox(width: 60.w, child: Text("Name")),
        SizedBox(width: 12.w),
        Expanded(
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              }
              return previousCustomers
                  .map((e) => e['name']!)
                  .where(
                    (name) => name.toLowerCase().startsWith(
                      textEditingValue.text.toLowerCase(),
                    ),
                  );
            },
            onSelected: (String selectedName) {
              final customer = previousCustomers.firstWhere(
                (e) => e['name'] == selectedName,
              );
              _showConfirmationDialog(customer); // show confirm before fill
            },
            fieldViewBuilder: (
              context,
              controller,
              focusNode,
              onEditingComplete,
            ) {
              controller.text = widget.nameController.text;
              controller.selection = TextSelection.collapsed(
                offset: controller.text.length,
              );
              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                onChanged: (val) {
                  widget.nameController.text = val;
                  if (!previousCustomers.any((e) => e['name'] == val)) {
                    setState(() {
                      isCustomerAutoFilled = false;
                    });
                  }
                },
                validator: BillingUtils.validateName,
                decoration: InputDecoration(
                  hintText: "customer name",
                  filled: true,
                  fillColor: AppColors.white,
                  hintStyle: TextStyle(
                    color: AppColors.textDisabled,
                    fontSize: 14.sp,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField(
    String label,
    String hint,
    TextEditingController controller,
    String? Function(String?)? validator,
  ) {
    return Row(
      children: [
        SizedBox(width: 60.w, child: Text(label)),
        SizedBox(width: 12.w),
        Expanded(
          child: TextFormField(
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.textDisabled,
                fontSize: 14.sp,
              ),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showConfirmationDialog(Map<String, String> customer) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: AppColors.white,
            title: Text(
              "Use this customer?",
              style: TextStyle(color: AppColors.primary),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: ${customer['name']}"),
                Text("Phone: ${customer['phone']}"),
                Text("Email: ${customer['email']}"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                ),
                child: const Text(
                  "Use Details",
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            ],
          ),
    );

    if (result == true) {
      widget.nameController.text = customer['name'] ?? '';
      widget.phoneController.text = customer['phone'] ?? '';
      widget.emailController.text = customer['email'] ?? '';
      setState(() {
        isCustomerAutoFilled = true;
      });
    }
  }
}
