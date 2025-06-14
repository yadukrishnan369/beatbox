import 'package:beatbox/features/home/ui/home_screen.dart';
import 'package:beatbox/features/product_management/ui/add_edit_product_screen.dart';
import 'package:beatbox/features/product_management/ui/brand_category_screen.dart';
import 'package:beatbox/features/product_management/ui/current_stock_screen.dart';
import 'package:beatbox/features/product_management/ui/limited_stock_screen.dart';
import 'package:beatbox/features/product_management/ui/manage_stock_screen.dart';
import 'package:beatbox/features/product_management/ui/product_details_screen.dart';
import 'package:beatbox/features/product_management/ui/products_screen.dart';
import 'package:beatbox/features/product_management/ui/stock_entry_details_screen.dart';
import 'package:beatbox/features/product_management/ui/stock_entry_screen.dart';
import 'package:beatbox/features/product_management/ui/update_delete_product_screen.dart';
import 'package:flutter/material.dart';
import '../features/splash/splash_screen.dart';
import '../features/auth/biometric_screen.dart';

class AppRoutes {
  // defining named route strings
  static const String splash = '/';
  static const String biometric = '/biometric';
  static const String home = '/home';
  static const String stock = '/stock';
  static const String limitedStock = '/limitedStock';
  static const String currentStock = '/currentStock';
  static const String addProduct = '/addProduct';
  static const String updateProduct = '/updateProduct';
  static const String stockEntry = '/stockEntry';
  static const String stockEntryDetails = '/stockEntryDetails';
  static const String products = '/products';
  static const String productDetails = '/productDetails';
  static const String brandAndCategory = '/brandAndCategory';

  /// set each routes, its screen widget
  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    biometric: (context) => BiometricScreen(onSuccess: () {}),
    home: (context) => HomeScreen(),
    stock: (context) => StockManageScreen(),
    limitedStock: (context) => LimitedStockScreen(),
    currentStock: (context) => CurrentStockScreen(),
    addProduct: (context) => AddProductScreen(),
    updateProduct: (context) => UpdateProductScreen(),
    stockEntry: (context) => StockEntryScreen(),
    stockEntryDetails: (context) => StockEntryDetailsScreen(),
    products: (context) => ProductsScreen(),
    productDetails: (context) => ProductDetailsScreen(),
    brandAndCategory: (context) => BrandAndCategoryScreen(),
  };

  //tracking navigation and Pause/resume the app
  static final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();
}
