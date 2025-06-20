import 'dart:io';
import 'package:beatbox/features/auth/biometric_screen.dart';
import 'package:beatbox/features/home/ui/home_screen.dart';
import 'package:beatbox/features/product_management/ui/stock_entry_details_screen.dart';
import 'package:beatbox/features/product_management/ui/stock_entry_screen.dart';
import 'package:beatbox/features/sales_management/controller/cart_controller.dart';
import 'package:beatbox/features/sales_management/controller/sales_controller.dart';
import 'package:beatbox/features/sales_management/model/cart_item_model.dart';
import 'package:beatbox/features/app_settings_management/ui/app_settings_screen.dart';
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
import 'package:beatbox/features/product_management/ui/update_delete_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'routes/app_routes.dart';
import 'core/app_lifecycle_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // initialize Flutter engine
  Directory directory =
      await getApplicationDocumentsDirectory(); // get the application local storage directory fetch
  await Hive.initFlutter(directory.path);

  // register Hive adapters for model classes to enable store object data
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(BrandModelAdapter());
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(CartItemModelAdapter());
  Hive.registerAdapter(SalesModelAdapter());

  // initialize hive boxes
  await CategoryController.initBox();
  await BrandController.initBox();
  await ProductController.initBox();
  await CartController.initBox();
  await SalesController.initBox();

  await Hive.openBox('app_settings');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLifecycleHandler _lifecycleHandler; // tracks app lifecycle events
  bool _biometricJustDone = false;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    // Initialize lifecycle handler
    _lifecycleHandler = AppLifecycleHandler(
      // check needs biometric auth
      onRequireBiometric: () {
        // showing biometric if not recently completed
        if (!_biometricJustDone) {
          Navigator.of(
            navigatorKey.currentContext!,
          ).pushNamed(AppRoutes.biometric);
        }
      },
      onAppPaused: () {
        // when app go to background,reset flag.
        _biometricJustDone = false;
      },
    );
    // register lifecycle observer to receive app state changes
    WidgetsBinding.instance.addObserver(_lifecycleHandler);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleHandler);
    super.dispose();
  }

  /// handles successful biometric authentication
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
    // initialize screenUtil for responsive layout
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'BeatBox',
          // set custom font using Google Fonts
          theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          initialRoute: AppRoutes.home,
          // define all named routes in the app
          routes: {
            AppRoutes.splash: (context) => SplashScreen(),
            AppRoutes.biometric:
                (context) => BiometricScreen(onSuccess: onBiometricSuccess),
            AppRoutes.home: (context) => HomeScreen(),
            AppRoutes.stock: (context) => StockManageScreen(),
            AppRoutes.limitedStock: (context) => LimitedStockScreen(),
            AppRoutes.currentStock: (context) => CurrentStockScreen(),
            AppRoutes.addProduct: (context) => AddProductScreen(),
            AppRoutes.updateProduct: (context) => UpdateProductScreen(),
            AppRoutes.stockEntry: (context) => StockEntryScreen(),
            AppRoutes.stockEntryDetails: (context) => StockEntryDetailsScreen(),
            AppRoutes.products: (context) => ProductsScreen(),
            AppRoutes.productDetails: (context) => ProductDetailsScreen(),
            AppRoutes.brandAndCategory: (context) => BrandAndCategoryScreen(),
            AppRoutes.appSettings: (context) => AppSettingsScreen(),
            AppRoutes.cart: (context) => CartScreen(),
            AppRoutes.billing: (context) => BillingScreen(),
            AppRoutes.salesAndCustomer: (context) => SalesAndCustomerScreen(),
            AppRoutes.salesAndCustomerDetails:
                (context) => SalesAndCustomerDetailsScreen(),
          },
          // set fixed text size of user device settings
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
  }
}
