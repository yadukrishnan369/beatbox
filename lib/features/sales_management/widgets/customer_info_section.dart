import 'package:beatbox/utils/responsive_utils.dart';
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
    final bool isWeb = Responsive.isDesktop(context);

    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isWeb ? 200.w : double.infinity),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person_outline, size: isWeb ? 8.sp : 20.sp),
                SizedBox(width: 6.w),
                Text(
                  "Customer Info",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: isWeb ? 7.sp : 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                if (isCustomerAutoFilled)
                  GestureDetector(
                    onTap: _clearCustomerDetails,
                    child: Row(
                      children: [
                        Icon(
                          Icons.clear,
                          size: isWeb ? 7.sp : 18.sp,
                          color: AppColors.error,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "Clear",
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: isWeb ? 6.sp : 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: isWeb ? 8.h : 12.h),
            Container(
              padding: EdgeInsets.all(isWeb ? 7.w : 16.w),
              decoration: BoxDecoration(
                color: AppColors.contColor,
                borderRadius: BorderRadius.circular(isWeb ? 10.r : 12.r),
              ),
              child: Column(
                children: [
                  _buildAutocompleteNameField(isWeb),
                  SizedBox(height: isWeb ? 8.h : 12.h),
                  _buildTextFormField(
                    isWeb,
                    "Phone",
                    "phone number",
                    widget.phoneController,
                    BillingUtils.validatePhone,
                  ),
                  SizedBox(height: isWeb ? 8.h : 12.h),
                  _buildTextFormField(
                    isWeb,
                    "Email",
                    "email address",
                    widget.emailController,
                    BillingUtils.validateEmail,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutocompleteNameField(bool isWeb) {
    return Row(
      children: [
        SizedBox(
          width: isWeb ? 25.w : 60.w,
          child: Text("Name", style: TextStyle(color: AppColors.textPrimary)),
        ),
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
              _showConfirmationDialog(customer);
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
                    setState(() => isCustomerAutoFilled = false);
                  }
                },
                style: TextStyle(color: AppColors.textPrimary),
                validator: BillingUtils.validateName,
                decoration: InputDecoration(
                  hintText: "Customer name",
                  hintStyle: TextStyle(
                    color: AppColors.textDisabled,
                    fontSize: isWeb ? 6.sp : 14.sp,
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(isWeb ? 6.r : 8.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isWeb ? 5.w : 12.w,
                    vertical: isWeb ? 3.h : 8.h,
                  ),
                ),
              );
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8.r),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 200.h),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      separatorBuilder: (_, __) => Divider(height: 1),
                      itemBuilder: (context, index) {
                        final option = options.elementAt(index);
                        return ListTile(
                          title: Text(
                            option,
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                          onTap: () => onSelected(option),
                        );
                      },
                    ),
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
    bool isWeb,
    String label,
    String hint,
    TextEditingController controller,
    String? Function(String?)? validator,
  ) {
    return Row(
      children: [
        SizedBox(
          width: isWeb ? 25.w : 60.w,
          child: Text(label, style: TextStyle(color: AppColors.textPrimary)),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: TextFormField(
            controller: controller,
            style: TextStyle(color: AppColors.textPrimary),
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.textDisabled,
                fontSize: isWeb ? 6.sp : 14.sp,
              ),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isWeb ? 3.r : 8.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: isWeb ? 5.w : 12.w,
                vertical: isWeb ? 3.h : 8.h,
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
            title: Text(
              "Use this customer?",
              style: TextStyle(color: AppColors.primary),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name: ${customer['name']}",
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                Text(
                  "Phone: ${customer['phone']}",
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                Text(
                  "Email: ${customer['email']}",
                  style: TextStyle(color: AppColors.textPrimary),
                ),
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
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );

    if (result == true) {
      widget.nameController.text = customer['name'] ?? '';
      widget.phoneController.text = customer['phone'] ?? '';
      widget.emailController.text = customer['email'] ?? '';
      setState(() => isCustomerAutoFilled = true);
    }
  }
}
