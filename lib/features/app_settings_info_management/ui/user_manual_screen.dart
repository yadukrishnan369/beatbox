import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/app_settings_info_management/widgets/user_manual_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserManualScreen extends StatelessWidget {
  const UserManualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'User Manual',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Box
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.contColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'Welcome to the User-Guide! This page is specially designed to guide you step-by-step on how to use every important feature of this app effectively. Whether you are a beginner or a regular user, this guide ensures you don’t miss any functionality.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Expandable Content
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: const [
                    UserManualSection(
                      title: '1. Adding a New Product',
                      points: [
                        'Tap on the “Add Product” button.',
                        'Fill all fields like name, category, quantity, code, description, and image.',
                        'Click “Add Product” at bottom.',
                        'Item will be added to the list.',
                      ],
                    ),
                    UserManualSection(
                      title: '2. Editing an Existing Product',
                      points: [
                        'Go to Update/Delete screen.',
                        'Search and tap edit icon.',
                        'Make changes and tap “Update Product”.',
                        'Confirm pop-up will appear.',
                      ],
                    ),
                    UserManualSection(
                      title: '3. Add Category & Brand',
                      points: [
                        'Go to the Manage Stock Screen.',
                        'Tap on the "add category/brand" icon in bottom.',
                        'Enter the new name and image in the popup dialog.',
                        'Click "Add" to save.',
                        'The new Category or Brand will appear in the dropdown instantly.',
                      ],
                    ),
                    UserManualSection(
                      title: '4. Product Labels',
                      points: [
                        'Shows auto status based on stock:',
                        '• New Arrival - within 7 days.',
                        '• Limited Stock - quantity < 5.',
                        '• Out of Stock - quantity = 0.',
                        '• New Arrival/Limited - both apply.',
                      ],
                    ),
                    UserManualSection(
                      title: '5. How to Sale a Product',
                      points: [
                        'Add items to cart.',
                        'Check items and tap Confirm.',
                        'Enter customer and bill info.',
                        'Tap Generate Bill.',
                        'Sale will save & stock reduce.',
                      ],
                    ),
                    UserManualSection(
                      title: '6. Bill Details Screen',
                      points: [
                        'After sale, bill screen will open.',
                        'Shows customer, products, qty, total, etc.',
                        'Used for future reference.',
                      ],
                    ),
                    UserManualSection(
                      title: '7. Download & Share PDF',
                      points: [
                        'On bill screen, tap PDF icon.',
                        'You can download the bill as PDF.',
                        'You can share via WhatsApp, Gmail, etc.',
                      ],
                    ),
                    UserManualSection(
                      title: '8. Limited Stock Screen',
                      points: [
                        'Shows products where stock less than 5.',
                        'Useful for restocking soon.',
                        'You can update stock easily.',
                      ],
                    ),
                    UserManualSection(
                      title: '9. Current Stock / Active Product List',
                      points: [
                        'Shows only in-stock items.',
                        'Tap to view product detail.',
                        'Used for knowing what’s ready to sell.',
                      ],
                    ),
                    UserManualSection(
                      title: '10. Sales & Profit Chart',
                      points: [
                        'Check Insight screen.',
                        'See charts for total sales & profit.',
                        'Can filter by Day, Week, Month, or custom Date Range.',
                      ],
                    ),
                    UserManualSection(
                      title: '11. Export & Import All Data',
                      points: [
                        'Export button will download backup file.',
                        'Import option allows restoring from file.',
                        'Useful for switching devices or safety.',
                      ],
                    ),
                    UserManualSection(
                      title: '12. Clear All Data',
                      points: [
                        'Option available in Settings.',
                        'Confirmation will ask before deleting.',
                        'Once confirmed, all app data will reset.',
                      ],
                    ),
                    UserManualSection(
                      title: '13. Theme Toggle (Dark/Light)',
                      points: [
                        'In settings screen, enable theme toggle.',
                        'Switch between Light Mode and Dark Mode.',
                        'Automatically updates app colors and design.',
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
