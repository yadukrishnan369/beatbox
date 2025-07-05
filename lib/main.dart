import 'dart:io';
import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/app_settings_info_management/controller/theme_controller.dart';
import 'package:beatbox/features/app_settings_info_management/ui/app_info_screen.dart';
import 'package:beatbox/features/app_settings_info_management/ui/faq_screen.dart';
import 'package:beatbox/features/app_settings_info_management/ui/reset_app_data_screen.dart';
import 'package:beatbox/features/app_settings_info_management/ui/user_manual_screen.dart';
import 'package:beatbox/features/auth/biometric_screen.dart';
import 'package:beatbox/features/bill_management/ui/bill_details_screen.dart';
import 'package:beatbox/features/bill_management/ui/bill_history_screen.dart';
import 'package:beatbox/features/home/ui/home_screen.dart';
import 'package:beatbox/features/insight_management/ui/insight_screen.dart';
import 'package:beatbox/features/product_management/ui/limited_stock_detail_screen.dart';
import 'package:beatbox/features/product_management/ui/stock_entry_details_screen.dart';
import 'package:beatbox/features/product_management/ui/stock_entry_screen.dart';
import 'package:beatbox/features/sales_management/controller/cart_controller.dart';
import 'package:beatbox/features/sales_management/controller/sales_controller.dart';
import 'package:beatbox/features/sales_management/model/cart_item_model.dart';
import 'package:beatbox/features/app_settings_info_management/ui/app_settings_screen.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:beatbox/features/sales_management/ui/billing_screen.dart';
import 'package:beatbox/features/sales_management/ui/cart_screen.dart';
import 'package:beatbox/features/sales_management/ui/sales_customer_details_screen.dart';
import 'package:beatbox/features/sales_management/ui/sales_customer_screen.dart';
import 'package:beatbox/features/splash/splash_screen.dart';
import 'package:beatbox/features/product_management/controller/brand_controller.dart';
import 'package:beatbox/features/product_management/controller/category_controller.dart';
import 'package:beatbox/features/product_management/controller/product_controller.dart';
import 'package:beatbox/features/product_management/model/brand_model.dart';
import 'package:beatbox/features/product_management/model/category_model.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/features/product_management/ui/add_edit_product_screen.dart';
import 'package:beatbox/features/product_management/ui/brand_category_screen.dart';
import 'package:beatbox/features/product_management/ui/current_stock_screen.dart';
import 'package:beatbox/features/product_management/ui/limited_stock_screen.dart';
import 'package:beatbox/features/product_management/ui/manage_stock_screen.dart';
import 'package:beatbox/features/product_management/ui/product_details_screen.dart';
import 'package:beatbox/features/product_management/ui/products_screen.dart';
import 'package:beatbox/features/product_management/ui/edit_delete_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'routes/app_routes.dart';
import 'core/app_lifecycle_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path);

  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(BrandModelAdapter());
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(CartItemModelAdapter());
  Hive.registerAdapter(SalesModelAdapter());

  await CategoryController.initBox();
  await BrandController.initBox();
  await ProductController.initBox();
  await CartController.initBox();
  await SalesController.initBox();
  await Hive.openBox('gstBox');

  await ThemeController.loadTheme();
  AppColors.updateTheme(ThemeController.isDarkMode.value);

  runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLifecycleHandler _lifecycleHandler;
  bool _biometricJustDone = false;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _lifecycleHandler = AppLifecycleHandler(
      onRequireBiometric: () {
        if (!_biometricJustDone) {
          Navigator.of(
            navigatorKey.currentContext!,
          ).pushNamed(AppRoutes.biometric);
        }
      },
      onAppPaused: () {
        _biometricJustDone = false;
      },
    );
    WidgetsBinding.instance.addObserver(_lifecycleHandler);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleHandler);
    super.dispose();
  }

  void onBiometricSuccess() {
    Future.microtask(() {
      if (mounted) {
        setState(() {
          _biometricJustDone = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: ThemeController.isDarkMode,
          builder: (context, isDark, _) {
            AppColors.updateTheme(isDark); // auto update AppColors
            return MaterialApp(
              title: 'BeatBox',
              theme: ThemeData(
                textTheme: GoogleFonts.poppinsTextTheme(),
                brightness: Brightness.light,
              ),
              darkTheme: ThemeData(
                textTheme: GoogleFonts.poppinsTextTheme(),
                brightness: Brightness.dark,
              ),
              themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              initialRoute: AppRoutes.home,
              routes: {
                AppRoutes.splash: (context) => SplashScreen(),
                AppRoutes.biometric:
                    (context) => BiometricScreen(onSuccess: onBiometricSuccess),
                AppRoutes.home: (context) => HomeScreen(),
                AppRoutes.stock: (context) => StockManageScreen(),
                AppRoutes.limitedStock: (context) => LimitedStockScreen(),
                AppRoutes.limitedStockDetail:
                    (context) => LimitedStockDetailScreen(),
                AppRoutes.currentStock: (context) => CurrentStockScreen(),
                AppRoutes.addProduct: (context) => AddProductScreen(),
                AppRoutes.updateProduct: (context) => UpdateProductScreen(),
                AppRoutes.stockEntry: (context) => StockEntryScreen(),
                AppRoutes.stockEntryDetails:
                    (context) => StockEntryDetailsScreen(),
                AppRoutes.products: (context) => ProductsScreen(),
                AppRoutes.productDetails: (context) => ProductDetailsScreen(),
                AppRoutes.brandAndCategory:
                    (context) => BrandAndCategoryScreen(),
                AppRoutes.appSettings: (context) => AppSettingsScreen(),
                AppRoutes.resetApp: (context) => ResetAppDataScreen(),
                AppRoutes.cart: (context) => CartScreen(),
                AppRoutes.billing: (context) => BillingScreen(),
                AppRoutes.salesAndCustomer:
                    (context) => SalesAndCustomerScreen(),
                AppRoutes.salesAndCustomerDetails:
                    (context) => SalesAndCustomerDetailsScreen(),
                AppRoutes.billHistory: (context) => BillHistoryScreen(),
                AppRoutes.billDetails: (context) => BillDetailsScreen(),
                AppRoutes.userManual: (context) => UserManualScreen(),
                AppRoutes.faq: (context) => FAQScreen(),
                AppRoutes.appInfo: (context) => AppInfoScreen(),
                AppRoutes.insight: (context) => InsightScreen(),
              },
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.linear(1.0)),
                  child: child!,
                );
              },
            );
          },
        );
      },
    );
  }
}
