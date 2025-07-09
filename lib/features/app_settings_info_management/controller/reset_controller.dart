import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/core/notifiers/bill_notifier.dart';
import 'package:beatbox/core/notifiers/cart_update_notifier.dart';
import 'package:beatbox/core/notifiers/insight_notifier.dart';
import 'package:beatbox/core/notifiers/product_add_notifier.dart';
import 'package:beatbox/core/notifiers/sales_notifier.dart';
import 'package:beatbox/features/app_settings_info_management/controller/theme_controller.dart';
import 'package:beatbox/features/product_management/controller/category_controller.dart';
import 'package:beatbox/features/sales_management/model/cart_item_model.dart';
import 'package:beatbox/utils/new_arrival_utils.dart';
import 'package:beatbox/widgets/Loading_widgets/reset_app_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hive/hive.dart';
import 'package:beatbox/features/product_management/model/brand_model.dart';
import 'package:beatbox/features/product_management/model/category_model.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetController {
  static Future<void> resetAppData(BuildContext context) async {
    try {
      await Hive.box<BrandModel>('brandBox').clear();
      await Hive.box<CategoryModel>('categoryBox').clear();
      await Hive.box<ProductModel>('productBox').clear();
      await Hive.box<SalesModel>('salesBox').clear();
      await Hive.box<CartItemModel>('cartBox').clear();
      await Hive.box('gstBox').clear(); //clear gst data
      // clear theme data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isDarkMode');
      await showResetAppLoadingDialog(context);
      isBillReloadNeeded.value = true;
      isSalesReloadNeeded.value = true;
      isProductReloadNeeded.value = true;
      isInsightEmptyNotifier.value = true;
      cartUpdatedNotifier.value = [];
      CategoryController.initBox();
      await NewArrivalUtils.loadNewArrivalProducts();
      ThemeController.isDarkMode.value = false;
      AppColors.updateTheme(false);
      // restart app
      Phoenix.rebirth(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong while resetting data"),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
