import 'package:beatbox/features/app_settings_info_management/ui/app_info_screen.dart';
import 'package:beatbox/features/app_settings_info_management/ui/faq_screen.dart';
import 'package:beatbox/features/app_settings_info_management/ui/user_manual_screen.dart';
import 'package:beatbox/features/bill_management/ui/bill_details_screen.dart';
import 'package:beatbox/features/bill_management/ui/bill_history_screen.dart';
import 'package:beatbox/features/home/ui/home_screen.dart';
import 'package:beatbox/features/product_management/ui/add_edit_product_screen.dart';
import 'package:beatbox/features/product_management/ui/brand_category_screen.dart';
import 'package:beatbox/features/product_management/ui/current_stock_screen.dart';
import 'package:beatbox/features/product_management/ui/limited_stock_detail_screen.dart';
import 'package:beatbox/features/product_management/ui/limited_stock_screen.dart';
import 'package:beatbox/features/product_management/ui/manage_stock_screen.dart';
import 'package:beatbox/features/product_management/ui/product_details_screen.dart';
import 'package:beatbox/features/product_management/ui/products_screen.dart';
import 'package:beatbox/features/product_management/ui/stock_entry_details_screen.dart';
import 'package:beatbox/features/product_management/ui/stock_entry_screen.dart';
import 'package:beatbox/features/product_management/ui/edit_delete_product_screen.dart';
import 'package:beatbox/features/app_settings_info_management/ui/app_settings_screen.dart';
import 'package:beatbox/features/sales_management/ui/billing_screen.dart';
import 'package:beatbox/features/sales_management/ui/cart_screen.dart';
import 'package:beatbox/features/sales_management/ui/sales_customer_details_screen.dart';
import 'package:beatbox/features/sales_management/ui/sales_customer_screen.dart';
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
  static const String limitedStockDetail = '/limitedStockDetail';
  static const String currentStock = '/currentStock';
  static const String addProduct = '/addProduct';
  static const String updateProduct = '/updateProduct';
  static const String stockEntry = '/stockEntry';
  static const String stockEntryDetails = '/stockEntryDetails';
  static const String products = '/products';
  static const String productDetails = '/productDetails';
  static const String brandAndCategory = '/brandAndCategory';
  static const String appSettings = '/appSettings';
  static const String cart = '/cart';
  static const String billing = '/billing';
  static const String salesAndCustomer = '/salesAndCustomer';
  static const String salesAndCustomerDetails = '/salesAndCustomerDetails';
  static const String billHistory = '/billHistory';
  static const String billDetails = '/billDetails';
  static const String userManual = '/userManual';
  static const String faq = '/faq';
  static const String appInfo = '/appInfo';

  /// set each routes, its screen widget
  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    biometric: (context) => BiometricScreen(onSuccess: () {}),
    home: (context) => HomeScreen(),
    stock: (context) => StockManageScreen(),
    limitedStock: (context) => LimitedStockScreen(),
    limitedStockDetail: (context) => LimitedStockDetailScreen(),
    currentStock: (context) => CurrentStockScreen(),
    addProduct: (context) => AddProductScreen(),
    updateProduct: (context) => UpdateProductScreen(),
    stockEntry: (context) => StockEntryScreen(),
    stockEntryDetails: (context) => StockEntryDetailsScreen(),
    products: (context) => ProductsScreen(),
    productDetails: (context) => ProductDetailsScreen(),
    brandAndCategory: (context) => BrandAndCategoryScreen(),
    appSettings: (context) => AppSettingsScreen(),
    cart: (context) => CartScreen(),
    billing: (context) => BillingScreen(),
    salesAndCustomer: (context) => SalesAndCustomerScreen(),
    salesAndCustomerDetails: (context) => SalesAndCustomerDetailsScreen(),
    billHistory: (context) => BillHistoryScreen(),
    billDetails: (context) => BillDetailsScreen(),
    userManual: (context) => UserManualScreen(),
    faq: (context) => FAQScreen(),
    appInfo: (context) => AppInfoScreen(),
  };

  //tracking navigation and Pause/resume the app
  static final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();
}
