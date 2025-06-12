import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/stock_manage/widgets/add_brand_modal.dart';
import 'package:beatbox/features/stock_manage/widgets/add_category_modal.dart';
import 'package:beatbox/features/stock_manage/widgets/total_sale_card.dart';
import 'package:beatbox/features/stock_manage/widgets/total_stock_card.dart';
import 'package:beatbox/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StockManageScreen extends StatefulWidget {
  const StockManageScreen({super.key});

  @override
  State<StockManageScreen> createState() => _StockManageScreenState();
}

class _StockManageScreenState extends State<StockManageScreen> {
  int _selectedIndex = 0;

  static const List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Add Category'),
    BottomNavigationBarItem(
      icon: Icon(Icons.branding_watermark),
      label: 'Add Brand',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.warning_amber_rounded),
      label: 'Limited Stock',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.inventory_2),
      label: 'Current Stock',
    ),
  ];

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AddCategoryModal(onSubmit: (name, image) {}),
      );
    } else if (index == 1) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AddBrandModal(onSubmit: (name, image) {}),
      );
    } else if (index == 2) {
      Navigator.pushNamed(context, AppRoutes.limitedStock);
    } else if (index == 3) {
      Navigator.pushNamed(context, AppRoutes.currentStock);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Stock')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [TotalStockCard(), TotalSalesCard()],
            ),
            SizedBox(height: 24.h),
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text(
                'Product Actions',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ),
            _productActionItem(Icons.add, 'Add Product', () {
              Navigator.pushNamed(context, AppRoutes.addProduct);
            }),
            _productActionItem(Icons.edit, 'Update/Edit Product', () {
              Navigator.pushNamed(context, AppRoutes.updateProduct);
            }),
            _productActionItem(Icons.history, 'Sales History', () {}),
            _productActionItem(Icons.list_alt, 'Stock Entries', () {}),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.bottomNavColor,
        items: bottomNavItems,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.white,
        unselectedItemColor: Colors.white,
        onTap: _onNavBarTap,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _productActionItem(IconData icon, String title, VoidCallback onTap) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 6.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor, size: 24.w),
        title: Text(title, style: TextStyle(fontSize: 16.sp)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
        onTap: onTap,
      ),
    );
  }
}
